import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:remindday_app/config/config.dart';
import '../models/todolist_model.dart';

class TodoService {
  static const String _baseUrl = AppConfig.baseUrl;

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  Future<List<Todo>> fetchTodos(String idDevice, DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final response = await http.get(
        Uri.parse(
            '$_baseUrl/gettodo?startDate=$formattedDate&idDevice=$idDevice'),
        headers: _headers);

    if (response.statusCode == 200) {
      String decodedBody = utf8.decode(response.bodyBytes);
      List jsonResponse = json.decode(decodedBody);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> updateTodoStatus(Todo todo, String idDevice) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/updatetodo/${todo.id}'),
      headers: _headers,
      body: json.encode({'status': todo.status, 'idDevice': idDevice}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update todo status');
    }
  }

}
