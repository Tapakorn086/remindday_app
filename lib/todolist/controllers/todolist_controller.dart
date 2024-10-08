import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

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
    return List.generate(7, (index) => centerDate.subtract(Duration(days: 3 - index)));
  }

  Future<List<Todo>> fetchTodos(String deviceId) async {
    debugPrint("==========$deviceId");
    try {
      return await _todoService.fetchTodos(deviceId);
    } catch (e) {
      print('Error fetching todos: $e');
      return [];
    }
  }
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
}