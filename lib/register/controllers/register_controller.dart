import 'package:flutter/material.dart';

import '../services/register_service.dart';

class RegisterController {
  final RegisterService _registerService = RegisterService();

  Future<String> register(String email, String password) async {
    try {
      bool success = await _registerService.register(email, password);
      if (success) {
        return "success";
      } else {
        return "Registration failed. Please try again.";
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      return "An error occurred. Please try again later.";
    }
  }
}