import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    // Dummy authentication check
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'test@example.com' && password == 'password') {
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }
}
