import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/todolist_model.dart';

class TodoService {
  static const String _baseUrl = 'http://192.168.66.43:8080/api';

  Future<List<Todo>> fetchTodos(String idDevice) async {
    final response = await http.get(Uri.parse('$_baseUrl/gettodo/$idDevice'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> updateTodoStatus(Todo todo,String idDevice) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/updatetodo/${todo.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': todo.status,'idDevice':idDevice
      
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update todo status');
    }
  }
}