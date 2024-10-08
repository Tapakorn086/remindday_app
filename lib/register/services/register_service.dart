import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  // final String apiUrl = 'http://10.0.0.0.2:8080/api/register';
  final String apiUrl = 'http://192.168.66.43:8080/api/login/registerlogin';

  Future<bool> register(String email, String password) async {

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('User registered successfully');
        return true;
      } else if (response.statusCode == 400) {
        debugPrint('Registration failed: ${response.body}');
        return false;
      } else {
        debugPrint('Registration failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error during registration: $e');
      return false;
    }
  }
}