import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';
import 'package:device_info_plus/device_info_plus.dart';

class TodoController extends ChangeNotifier {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;


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

  Future<String?> getidDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }
    return null;
  }
}
