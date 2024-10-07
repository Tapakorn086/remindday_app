import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _loginUrl = 'http://192.168.1.105:8080/api/login/sessionlogin';

  Future<bool> isLoggedIn() async {
    String? token = await _storage.read(key: 'token');
    return token != null;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        int loginId = data['loginId'];
        bool hasInfo = data['hasInfo'];  

        await _storage.write(key: 'loginId', value: loginId.toString());

        return {'loginId': loginId, 'hasInfo': hasInfo};
      }
    } catch (e) {
      debugPrint('Error during login: $e');
    }

    return {'loginId': 0, 'hasInfo': false};  
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'loginId');
  }
}
