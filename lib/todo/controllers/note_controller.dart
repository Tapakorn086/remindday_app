import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../services/note_service.dart';

class TodoController extends ChangeNotifier {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<void> fetchTodos() async {
    try {
      _todos = await _todoService.getTodos();
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> addTodo(Todo todo) async {
    debugPrint("data: $todo");
    debugPrint("data: ${json.encode(todo.toJson())}");
    try {
      final newTodo = await _todoService.createTodo(todo);
      _todos.add(newTodo);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }
}