import 'dart:convert';
import '../models/group_model.dart';
import 'package:http/http.dart' as http;

class GroupService {
  final String apiUrl = 'http://192.168.1.105:8080/api/group';

  Future<List<Group>> getGroupsByUserId(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl/getGroupByUserId/$userId'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((group) => Group.fromJson(group)).toList();
    } else {
      throw Exception('Failed to load groups for user: ${response.statusCode}');
    }
  }

  Future<String> addGroup(String name, String description, int ownerId) async {
    final response = await http.post(
      Uri.parse('$apiUrl/createGroup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(
          {'name': name, 'description': description, 'ownerId': ownerId}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('referralCode')) {
        return responseData['referralCode'];
      } else {
        throw Exception('Referral code not found in response');
      }
    } else {
      throw Exception('Failed to add group: ${response.statusCode}');
    }
  }
}
