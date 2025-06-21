import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_flutter/api/auth_service.dart';


class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get userRole => _user?['role'];
  Map<String, dynamic>? get user => _user;

  AuthProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userJson = await _storage.read(key: 'user_data');
    if (userJson != null) {
      try {
        _user = json.decode(userJson);
        notifyListeners();
      } catch (e) {
        print('Error loading user data: $e');
        await _storage.delete(key: 'user_data');
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _authService.login(email, password);
      _user = response.user; // Store only user data

      await Future.wait([
        _storage.write(key: 'auth_token', value: response.token),
        _storage.write(key: 'user_data', value: json.encode(response.user)),
      ]);

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Login failed: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      await Future.wait([
        _storage.delete(key: 'auth_token'),
        _storage.delete(key: 'user_data'),
      ]);
      _user = null;
      notifyListeners();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'auth_token');
    final userJson = await _storage.read(key: 'user_data');
    return token != null && userJson != null;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}