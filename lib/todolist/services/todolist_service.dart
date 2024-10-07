import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todolist_model.dart';

class TodoService {
  static const String _baseUrl = 'http://localhost:8080/api';

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse('$_baseUrl/gettodo'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}