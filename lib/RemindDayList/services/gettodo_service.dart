import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:remindday_app/RemindDayList/models/gettodo.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'http://localhost:8080/api/'});

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse('${baseUrl}gettodo'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}
