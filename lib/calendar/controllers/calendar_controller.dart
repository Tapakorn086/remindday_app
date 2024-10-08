import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import '../../todolist/models/todolist_model.dart';
import '../../todolist/services/todolist_service.dart';

class CalendarController extends ChangeNotifier {
  final TodoService _todoService = TodoService();
  DateTime _selectedDate = DateTime.now();
  List<Todo> _todos = [];

  DateTime get selectedDate => _selectedDate;
  List<Todo> get todos => _todos;

  Future<void> changeSelectedDate(DateTime date) async {
    _selectedDate = date;
    await _fetchTodosForSelectedDate();
    notifyListeners();
  }

  Future<void> _fetchTodosForSelectedDate() async {
    String? deviceId = await _getDeviceId();
    if (deviceId != null) {
      try {
        _todos = await _todoService.fetchTodos(deviceId, _selectedDate);
      } catch (e) {
        debugPrint('Error fetching todos: $e');
        _todos = [];
      }
    }
  }

  Future<String?> _getDeviceId() async {
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

  Future<void> updateTodoStatus(Todo todo) async {
    String? deviceId = await _getDeviceId();
    if (deviceId != null) {
      try {
        await _todoService.updateTodoStatus(todo, deviceId);
        await _fetchTodosForSelectedDate();
        notifyListeners();
      } catch (e) {
        debugPrint('Error updating todo status: $e');
        throw e;
      }
    }
  }

  Future<void> initCalendar() async {
    await _fetchTodosForSelectedDate();
    notifyListeners();
  }
}