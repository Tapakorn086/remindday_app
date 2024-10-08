import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:remindday_app/config/config.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _baseUrl = AppConfig.baseUrl;
  final String _loginUrl = '$_baseUrl/login/sessionlogin';

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
      debugPrint("data: $email,$password");
      debugPrint("data: ${jsonDecode(response.body)}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        int loginId = data['loginId'];
        bool hasInfo = data['hasInfo'];
        int userId = 00;
        debugPrint("data: $userId,$hasInfo,$loginId");

        await _storage.write(key: 'loginId', value: loginId.toString());

        if (hasInfo == false) {
          return {'loginId': loginId, 'hasInfo': hasInfo};
        } else {
          userId = data['userId'];
          debugPrint("data: $userId,$hasInfo,$loginId");
          return {'loginId': loginId, 'hasInfo': hasInfo, 'userId': userId};
        }
      }
    } catch (e) {
      debugPrint('Error during login: $e');
    }

    return {'loginId': 0, 'hasInfo': false, 'userId': 0};
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'loginId');
  }
}
