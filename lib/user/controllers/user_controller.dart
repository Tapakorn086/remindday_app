import 'package:flutter/material.dart';
import 'package:remindday_app/user/models/user_model.dart';
import '../services/user_service.dart';

class UserController extends ChangeNotifier {
  final UserService userService = UserService();
  User user = User(); 

  void setUsername(String value) {
    user.username = value;
    notifyListeners();
  }

  void setAge(String value) {
    user.age = int.tryParse(value);
    notifyListeners();
  }

  void setGender(String value) {
    user.gender = value;
    notifyListeners();
  }
  
  void setLoginId(int? value){
    user.loginId = value;
    notifyListeners();
  }

  Future<void> saveUser() async {
    await userService.saveUser(user);
  }
}
