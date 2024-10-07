import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../group/screen/group_screen.dart';
import '../controllers/user_controller.dart';

class UserInfoForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>(); 
  final int? loginId;

  UserInfoForm({super.key, required this.loginId});
  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return Form(
      key: _formKey, // กำหนดให้ Form ใช้ GlobalKey
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Username'),
            onChanged: (value) => userController.setUsername(value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username'; // ตรวจสอบว่ากรอกชื่อผู้ใช้หรือไม่
              }
              return null; // ถ้าไม่มีปัญหา
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
            onChanged: (value) => userController.setAge(value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your age'; // ตรวจสอบว่ากรอกอายุหรือไม่
              }
              // ตรวจสอบว่าค่าเป็นตัวเลขหรือไม่
              final age = int.tryParse(value);
              if (age == null) {
                return 'Please enter a valid number'; // ตรวจสอบค่าที่กรอกเป็นตัวเลข
              }
              return null; // ถ้าไม่มีปัญหา
            },
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Gender'),
            items: <String>['Male', 'Female', 'Other'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) => userController.setGender(value!),
            validator: (value) {
              if (value == null) {
                return 'Please select your gender'; // ตรวจสอบว่ากรอกเพศหรือไม่
              }
              return null; // ถ้าไม่มีปัญหา
            },
          ),
          ElevatedButton(
            onPressed: () async {
              userController.setLoginId(loginId!);
              if (_formKey.currentState!.validate()) {
                try {
                  await userController.saveUser();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User saved successfully')),
                  );
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const GroupScreen()),
                  );

                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save user: $error')),
                  );
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
