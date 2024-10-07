import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remindday_app/todo/models/note_model.dart';


class NoteService {
  final String apiUrl = "http://192.168.1.104:8080/api/addTodo"; // เปลี่ยน URL ตามที่ต้องการ

  Future<void> addNote(Note note) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(note.toJson()), // ต้องมีฟังก์ชัน toJson() ใน Note
      );

      if (response.statusCode == 201) {
        print('Note added successfully!');
        
      } else {
        print('Failed to add note. Status code: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}


 //| title |description | type | importance |start_time |start_date | notify_minutes_before |