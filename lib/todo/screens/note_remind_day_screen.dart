import 'package:flutter/material.dart';
import 'package:remindday_app/todo/controllers/note_controller.dart';
import 'package:remindday_app/todo/widgets/note_form_widget.dart';

class NoteRemindDayScreen extends StatefulWidget {
  const NoteRemindDayScreen({super.key});

  @override
  _NoteRemindDayScreenState createState() => _NoteRemindDayScreenState();
}

class _NoteRemindDayScreenState extends State<NoteRemindDayScreen> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _detailsController = TextEditingController();
  final _dateController = TextEditingController();
  String? _selectedType;
  String? _selectedImportance;
  String? _selectedStartTime;
  String? _selectedReminderTime;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // ตรวจสอบให้แน่ใจว่าข้อมูลที่จำเป็นมีการกรอกครบถ้วน
      if (_selectedType == null || _selectedImportance == null || _selectedStartTime == null || _selectedReminderTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน!')),
        );
        return;
      }

      try {
        await NoteController().addNote(
          title: _taskNameController.text,
          description: _detailsController.text,
          type: _selectedType!,
          importance: _selectedImportance!,
          startTime: _selectedStartTime!, // ต้องแน่ใจว่าส่งในรูปแบบที่ถูกต้อง
          startDate: _dateController.text, // ควรส่งในรูปแบบ YYYY-MM-DD
          notifyMinutesBefore: int.parse(_selectedReminderTime!.split(' ')[0]), // ต้องแปลงเป็น int
          status: 'Pending',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Reminder'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: NoteFormWidget(
          formKey: _formKey,
          taskNameController: _taskNameController,
          detailsController: _detailsController,
          dateController: _dateController,
          selectedType: _selectedType,
          selectedImportance: _selectedImportance,
          selectedStartTime: _selectedStartTime,
          selectedReminderTime: _selectedReminderTime,
          onTypeChanged: (value) => setState(() {
            _selectedType = value;
          }),
          onImportanceChanged: (value) => setState(() {
            _selectedImportance = value;
          }),
          onStartTimeChanged: (value) => setState(() {
            _selectedStartTime = value;
          }),
          onReminderTimeChanged: (value) => setState(() {
            _selectedReminderTime = value;
          }),
          onDatePicked: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (selectedDate != null) {
              setState(() {
                // เก็บค่าลง _dateController
                _dateController.text = selectedDate.toLocal().toString().split(' ')[0]; 
              });
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
