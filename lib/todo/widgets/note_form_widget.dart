import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController taskNameController;
  final TextEditingController detailsController;
  final TextEditingController dateController;
  final String? selectedType;
  final String? selectedImportance;
  final String? selectedStartTime;
  final String? selectedReminderTime;
  final Function(String?) onTypeChanged;
  final Function(String?) onImportanceChanged;
  final Function(String?) onStartTimeChanged;
  final Function(String?) onReminderTimeChanged;
  final Function() onDatePicked;

  NoteFormWidget({
    required this.formKey,
    required this.taskNameController,
    required this.detailsController,
    required this.dateController,
    required this.selectedType,
    required this.selectedImportance,
    required this.selectedStartTime,
    required this.selectedReminderTime,
    required this.onTypeChanged,
    required this.onImportanceChanged,
    required this.onStartTimeChanged,
    required this.onReminderTimeChanged,
    required this.onDatePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: taskNameController,
            decoration: InputDecoration(
              labelText: 'ชื่องาน',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกชื่องาน';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: detailsController,
            decoration: InputDecoration(
              labelText: 'เพิ่มรายละเอียด',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedType,
            decoration: InputDecoration(
              labelText: 'ประเภท',
              border: OutlineInputBorder(),
            ),
            items: ['เรียน', 'งาน', 'อื่นๆ'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onTypeChanged,
            validator: (value) => value == null ? 'กรุณาเลือกประเภท' : null,
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedImportance,
            decoration: InputDecoration(
              labelText: 'สำคัญมากน้อย',
              border: OutlineInputBorder(),
            ),
            items: ['สำคัญมาก', 'สำคัญปานกลาง', 'สำคัญน้อย'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onImportanceChanged,
            validator: (value) => value == null ? 'กรุณาเลือกความสำคัญ' : null,
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedStartTime,
            decoration: InputDecoration(
              labelText: 'เวลาที่ต้องการให้แจ้งเตือน',
              border: OutlineInputBorder(),
            ),
            items: List.generate(24, (index) {
              return DropdownMenuItem<String>(
                value: '$index:00',
                child: Text('$index:00'),
              );
            }),
            onChanged: onStartTimeChanged,
            validator: (value) => value == null ? 'กรุณาเลือกเวลาเริ่มต้น' : null,
          ),
          SizedBox(height: 16),
          
        
          TextFormField(
            controller: dateController,
            decoration: InputDecoration(
              labelText: 'เลือกวันที่จะแจ้งเตือน',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: onDatePicked,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณาเลือกวันที่';
              }
              return null;
            },
          ),
            SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedReminderTime,
            decoration: InputDecoration(
              labelText: 'เวลาเตือนก่อนกิจกรรมเริ่ม',
              border: OutlineInputBorder(),
            ),
            items: ['5 นาที', '10 นาที', '15 นาที', '30 นาที', '1 ชั่วโมง'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onReminderTimeChanged,
            validator: (value) => value == null ? 'กรุณาเลือกเวลาเตือน' : null,
          ),
        ],
      ),
    );
  }
}
