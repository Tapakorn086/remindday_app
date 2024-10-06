import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 
import 'package:http/http.dart' as http; 
import 'dart:convert'; 

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _loginUrl = 'http://192.168.1.105:8080/api/login'; 

  Future<bool> isLoggedIn() async {
    // ตรวจสอบ token ใน secure storage
    String? token = await _storage.read(key: 'token');
    return token != null;
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        // สมมุติว่าคุณได้รับ token จาก API
        final data = jsonDecode(response.body);
        String token = data['token']; 
        await _storage.write(key: 'token', value: token);
        return true;
      }
    } catch (e) {
      debugPrint('Error during login: $e');
    }
    return false;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
