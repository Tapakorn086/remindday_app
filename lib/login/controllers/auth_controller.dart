import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();
  var userId = 0;

  Future<int?> login(String email, String password) async {
    try {
      userId = await _authService.login(email, password);
      return userId;
    } catch (e) {
      debugPrint('Login error: $e');
      return userId;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}