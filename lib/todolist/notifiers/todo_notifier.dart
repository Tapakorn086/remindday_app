import 'package:flutter/material.dart';
import '../models/todolist_model.dart';

class TodoNotifier extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void setTodos(List<Todo> todos) {
    _todos = todos;
    notifyListeners();
  }

  void updateTodoStatus(Todo todo, String newStatus) {
    todo.status = newStatus;
    notifyListeners();
  }
  
}
