import 'package:flutter/material.dart';
import '../widgets/register_form.dart';
import '../../group/screen/group_screen.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: RegisterForm(
          onRegisterResult: (success) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registration successful!')),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => GroupScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registration failed. Please try again.')),
              );
            }
          },
        ),
      ),
    );
  }
}