import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/todolist_model.dart';

class TodoService {
  static const String _baseUrl = 'http://192.168.66.43:8080/api';

  Future<List<Todo>> fetchTodos(String idDevice) async {
    debugPrint("==========Service: $idDevice");
    final response = await http.get(Uri.parse('$_baseUrl/gettodo/$idDevice'));

    debugPrint("==========response: $response");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      debugPrint("==========jsonResponse: $jsonResponse");

      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
