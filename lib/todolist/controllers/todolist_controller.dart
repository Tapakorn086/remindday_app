import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todolist_model.dart';
import '../services/todolist_service.dart';

class RemindDayListController {
  final TodoService _todoService = TodoService();
  DateTime _selectedDate = DateTime.now();
  late List<DateTime> _weekDays;
  

  RemindDayListController() {
    _weekDays = _generateWeekDays(_selectedDate);
  }

  DateTime get selectedDate => _selectedDate;
  List<DateTime> get weekDays => _weekDays;

  set selectedDate(DateTime date) {
    _selectedDate = date;
    _weekDays = _generateWeekDays(date);
  }

  List<DateTime> _generateWeekDays(DateTime centerDate) {
    return List.generate(
        7, (index) => centerDate.subtract(Duration(days: 3 - index)));
  }

  Future<List<Todo>> fetchTodos(
      {required String deviceId, required DateTime date}) async {
    try {
      final data = await _todoService.fetchTodos(deviceId, date);
      return data;
    } catch (e) {
      debugPrint('Error fetching todos: $e');
      return [];
    }
  }

Future<List<Todo>> fetchCurrentTodo(List<Todo> data) async {
  final now = DateTime.now();
  final dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  List<Todo> filteredTodos = [];

  for (var todo in data) {
    if (todo.status?.toLowerCase() == 'pending' || todo.status?.toLowerCase() == 'working') {
      final startDateTime = dateFormat.parse("${todo.startDate} ${todo.startTime}");
      final differenceInHours = startDateTime.difference(now).inHours;

      if (differenceInHours <= 6 && differenceInHours >= 0) {
        debugPrint("Todo item '${todo.title}' is pending and starts within the next 6 hours.");
        filteredTodos.add(todo); 
      }
    }
  }

  filteredTodos.sort((a, b) {
    final aTime = DateFormat("HH:mm").parse(a.startTime.toString());
    final bTime = DateFormat("HH:mm").parse(b.startTime.toString());
    return aTime.compareTo(bTime);
  });

  return filteredTodos;
}

//fetchcurrent
  Future<String?> getDeviceId() async {
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
    var idDevice = await getDeviceId();
    try {
      await _todoService.updateTodoStatus(todo, idDevice.toString());
    } catch (e) {
      debugPrint('Error updating todo status: $e');
      rethrow;
    }
  }
}
