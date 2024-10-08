import 'package:flutter/material.dart';

class Todo {
  final String title;
  final String description;
  final String idDevice;
  final String type;
  final String importance;
  final DateTime startDate;
  final TimeOfDay startTime;
  final int notifyMinutesBefore;
  final String status;

  Todo({
    required this.title,
    required this.description,
    required this.idDevice,
    required this.type,
    required this.importance,
    required this.startDate,
    required this.startTime,
    required this.notifyMinutesBefore,
    required this.status,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      description: json['description'],
      idDevice: json['idDevice'],
      type: json['type'],
      importance: json['importance'],
      startDate: DateTime.parse(json['startDate']),
      startTime: TimeOfDay.fromDateTime(DateTime.parse(json['startTime'])),
      notifyMinutesBefore: json['notifyMinutesBefore'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'idDevice': idDevice,
      'type': type,
      'importance': importance,
      'startDate': startDate.toIso8601String(),
      'startTime': DateTime(startDate.year, startDate.month, startDate.day, startTime.hour, startTime.minute).toIso8601String(),
      'notifyMinutesBefore': notifyMinutesBefore,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'Todo(title: $title, description: $description,idDevice: $idDevice, type: $type, importance: $importance, startDate: $startDate, startTime: 10:10, notifyMinutesBefore: $notifyMinutesBefore, status: $status)';
  }
}