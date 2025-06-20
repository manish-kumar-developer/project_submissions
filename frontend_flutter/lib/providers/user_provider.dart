import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:frontend_flutter/api/auth_service.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AuthService _authService = AuthService();

  Map<String, dynamic>? get user => _user;
  String? get userRole => _user?['role'];

  UserProvider() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      // For simplicity, we'll store minimal user data
      // In a real app, you might want to fetch fresh user data
      final email = await _storage.read(key: 'user_email');
      final role = await _storage.read(key: 'user_role');

      if (email != null && role != null) {
        _user = {
          'email': email,
          'role': role,
        };
        notifyListeners();
      }
    }
  }

  Future<void> setUser(Map<String, dynamic> userData) async {
    _user = userData;

    // Persist user data
    await _storage.write(key: 'user_email', value: userData['email']);
    await _storage.write(key: 'user_role', value: userData['role']);

    notifyListeners();
  }

  Future<void> clearUser() async {
    _user = null;

    // Clear stored user data
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'user_role');

    notifyListeners();
  }

  Future<void> refreshUser() async {
    try {
      // In a real app, you would make an API call to /user endpoint
      // For this example, we'll just reload from storage
      await _loadUserFromStorage();
    } catch (e) {
      print('Failed to refresh user: $e');
    }
  }
}