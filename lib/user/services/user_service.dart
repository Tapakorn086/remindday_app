import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remindday_app/config/config.dart';
import 'package:remindday_app/user/models/user_model.dart';

class UserService {
    static const String _baseUrl = AppConfig.baseUrl;
  final String apiUrl = "$_baseUrl/user/register";
  Future<Map<String, int>> saveUser(User user) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': user.username,
        'age': user.age,
        'gender': user.gender,
        'login': {
          'id': user.loginId,
        },
        'groups': [],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save user');
    } else {
      final data = jsonDecode(response.body);
      int userId = data['id'];
      return {'userId': userId};
    }
  }
}
