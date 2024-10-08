import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/note_model.dart';

class TodoService {
  final String baseUrl = 'http://192.168.66.43:8080/api';

  Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse('$baseUrl/addTodo'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

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
