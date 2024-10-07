import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();
  var userId = 0;

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      Map<String, dynamic> loginData =
          await _authService.login(email, password);
      return loginData;
    } catch (e) {
      debugPrint('Login error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
