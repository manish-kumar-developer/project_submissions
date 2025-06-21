import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_flutter/api/auth_service.dart';
import 'package:frontend_flutter/api/error_utils.dart'; // Import the ErrorUtils

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  Map<String, dynamic>? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String? get userRole => _user?['role'];
  Map<String, dynamic>? get user => _user;

  AuthProvider() {
    _loadUserData();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  Future<void> _loadUserData() async {
    try {
      final userJson = await _storage.read(key: 'user_data');
      if (userJson != null) {
        _user = json.decode(userJson);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      await _storage.delete(key: 'user_data');
      // Use ErrorUtils for storage-related errors
      _errorMessage = ErrorUtils.getFriendlyErrorMessage(e);
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _clearMessages();
      _isLoading = true;
      notifyListeners();

      final response = await _authService.login(email, password);
      _user = response.user;

      await Future.wait([
        _storage.write(key: 'auth_token', value: response.token),
        _storage.write(key: 'user_data', value: json.encode(response.user)),
      ]);

      _successMessage = 'Welcome back!';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      // Convert any error to a user-friendly message using ErrorUtils
      _errorMessage = ErrorUtils.getFriendlyErrorMessage(e);
      notifyListeners();

      // Clear error after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        _errorMessage = null;
        notifyListeners();
      });
    }
  }

  Future<void> logout() async {
    try {
      _clearMessages();
      await _authService.logout();
    } catch (e) {
      // Convert any error to a user-friendly message using ErrorUtils
      _errorMessage = ErrorUtils.getFriendlyErrorMessage(e);
      notifyListeners();

      // Clear error after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        _errorMessage = null;
        notifyListeners();
      });
    } finally {
      try {
        await Future.wait([
          _storage.delete(key: 'auth_token'),
          _storage.delete(key: 'user_data'),
        ]);
      } catch (e) {
        debugPrint('Storage deletion error: $e');
        // Use ErrorUtils for storage errors
        _errorMessage = ErrorUtils.getFriendlyErrorMessage(e);
        notifyListeners();
      }

      _user = null;
      _successMessage = 'You have been logged out';
      notifyListeners();
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      final userJson = await _storage.read(key: 'user_data');
      return token != null && userJson != null;
    } catch (e) {
      debugPrint('Login check error: $e');
      return false;
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'auth_token');
    } catch (e) {
      debugPrint('Token retrieval error: $e');
      return null;
    }
  }
}