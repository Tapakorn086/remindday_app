import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import '../widgets/user_info_form.dart';

class UserInfoScreen extends StatelessWidget {
  final int? loginId;

  const UserInfoScreen({required this.loginId});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserController(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Info'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: UserInfoForm(loginId: loginId),
        ),
      ),
    );
  }
}
