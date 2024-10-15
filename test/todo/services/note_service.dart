import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remindday_app/config/config.dart';

import '../models/note_model.dart';

class TodoService {
  final String baseUrl = AppConfig.baseUrl;

  Future<Todo> createTodo(Todo todo) async {
    debugPrint("data: START CREATE DOTO");
    debugPrint("data: $todo");

    final response = await http.post(
      Uri.parse('$baseUrl/addTodo'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );
    debugPrint("data: START RESPONSE $response");

    if (response.statusCode == 200) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create todo');
    }
  }
}
