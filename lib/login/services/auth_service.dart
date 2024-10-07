import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _loginUrl = 'http://192.168.1.105:8080/api/login/sessionlogin';

  Future<bool> isLoggedIn() async {
    // ตรวจสอบ token ใน secure storage
    String? token = await _storage.read(key: 'token');
    return token != null;
  }
Future<int> login(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse(_loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      // String token = data['token'];
      int loginId = data['loginId'];
      // เก็บ token และ loginId ใน secure storage
      // await _storage.write(key: 'token', value: token);
      // await _storage.write(key: 'loginId', value: loginId.toString()); // เก็บ loginId
      

      return loginId; // คืนค่า loginId
    }
  } catch (e) {
    debugPrint('Error during login: $e');
  }
  return 0; // คืนค่า null ในกรณีที่ล็อกอินไม่สำเร็จ
}


  Future<void> logout() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'loginId');
  }
}
