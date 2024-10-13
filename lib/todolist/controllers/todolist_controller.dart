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
    return List.generate(
        7, (index) => centerDate.subtract(Duration(days: 3 - index)));
  }

  Future<List<Todo>> fetchTodos(
      {required String deviceId, required DateTime date}) async {
    try {
      return await _todoService.fetchTodos(deviceId, date);
    } catch (e) {
      debugPrint('Error fetching todos: $e');
      return [];
    }
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
      throw e;
    }
  }
  //   // ฟังก์ชันใหม่สำหรับดึง Todo ปัจจุบันที่ใกล้เริ่ม
  // Future<Todo?> fetchCurrentTodo(DateTime date, int notifyMinutesBefore) async {
  //   List<Todo> todos = await fetchTodos(deviceId: (await getDeviceId()) ?? '', date: date);
  //   DateTime now = DateTime.now();

  //   // ค้นหา Todo ที่จะเริ่มต้นในอีก notifyMinutesBefore นาที
  //   for (var todo in todos) {
  //     DateTime startDateTime = DateTime.parse('${todo.startDate} ${todo.startTime}');
  //     if (startDateTime.isAfter(now) && startDateTime.isBefore(now.add(Duration(minutes: notifyMinutesBefore)))) {
  //       return todo; // คืนค่า Todo ที่จะเริ่มต้นในเวลาใกล้เคียง
  //     }
  //   }
  //   return null; // ถ้าไม่มี Todo ที่ตรงตามเงื่อนไข
  // }
}
