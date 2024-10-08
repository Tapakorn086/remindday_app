import 'package:flutter/material.dart';
import 'package:remindday_app/todolist/screens/todolist_screen.dart';
import '../controllers/note_controller.dart';
import '../models/note_model.dart' as ModelTodo;
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_text_field.dart';

class NoteRemindDayScreen extends StatefulWidget {
  const NoteRemindDayScreen({super.key});

  @override
  _NoteRemindDayScreenState createState() => _NoteRemindDayScreenState();
}

class _NoteRemindDayScreenState extends State<NoteRemindDayScreen> {
  final _formKey = GlobalKey<FormState>();
  final TodoController _todoController = TodoController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _selectedType;
  String? _selectedImportance;
  TimeOfDay? _selectedStartTime;
  int? _selectedNotifyMinutes;
  DateTime? _selectedStartDate;

  List<String> _generateTimeList() {
    return List.generate(
        24, (index) => '${index.toString().padLeft(2, '0')}:00');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Add ToDo"),
        backgroundColor: const Color(0xFFE6E6FA),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  label: 'ชื่องาน',
                  controller: _titleController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'เพิ่มรายละเอียด',
                  controller: _descriptionController,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'ประเภท',
                  items: const ['เรียน', 'งาน', 'อื่นๆ'],
                  value: _selectedType,
                  onChanged: (value) => setState(() => _selectedType = value),
                ),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'สำคัญมากน้อย',
                  items: const ['สำคัญมาก', 'สำคัญปานกลาง', 'สำคัญน้อย'],
                  value: _selectedImportance,
                  onChanged: (value) =>
                      setState(() => _selectedImportance = value),
                ),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'เวลาที่ต้องการให้แจ้งเตือน',
                  items: _generateTimeList(),
                  value: _selectedStartTime?.format(context),
                  onChanged: (value) {
                    if (value != null) {
                      final parts = value.split(':');
                      setState(() => _selectedStartTime =
                          TimeOfDay(hour: int.parse(parts[0]), minute: 0));
                    }
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdown(
                  label: 'เวลาเตือนก่อนกิจกรรมเริ่ม',
                  items: const [
                    '5 นาที',
                    '10 นาที',
                    '15 นาที',
                    '30 นาที',
                    '1 ชั่วโมง'
                  ],
                  value: _selectedNotifyMinutes?.toString(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedNotifyMinutes =
                          int.parse(value.split(' ')[0]));
                    }
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'เลือกวันที่จะแจ้งเตือน',
                  controller: _dateController,
                  readOnly: true,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedStartDate = pickedDate;
                        _dateController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color(0xFFE6E6FA),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _submitForm,
                  child: const Text('เพิ่มข้อมูล'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async  {
    if (_formKey.currentState!.validate()) {
          String? idDevice = await _todoController.getidDevice();

      final newTodo = ModelTodo.Todo(
        title: _titleController.text,
        description: _descriptionController.text,
        idDevice: idDevice.toString(),
        type: _selectedType!,
        importance: _selectedImportance!,
        startDate: _selectedStartDate!,
        startTime: _selectedStartTime!,
        notifyMinutesBefore: _selectedNotifyMinutes!,
        status: 'Pending',
      );

      _todoController.addTodo(newTodo);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo added successfully')),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => TodoDayListScreen()),
      );
    }
  }
}
