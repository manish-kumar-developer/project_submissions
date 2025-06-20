

import 'package:frontend_flutter/api/api_client.dart';

import '../models/auth_response.dart';


class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<AuthResponse> login(String email, String password) async {
    final response = await _apiClient.post('/login', {
      'email': email,
      'password': password,
    });
    return AuthResponse.fromJson(response.data);
  }

  Future<void> logout() async {
    await _apiClient.post('/logout', {});
  }
}