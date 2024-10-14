import 'package:flutter/material.dart';
import '../controllers/note_controller.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_text_field.dart';
import '../models/note_model.dart' as modeltodo;

class NoteRemindDayScreen extends StatefulWidget {
  final DateTime selectedDate;

  const NoteRemindDayScreen({super.key, required this.selectedDate});

  @override
  _NoteRemindDayScreenState createState() => _NoteRemindDayScreenState();
}

class _NoteRemindDayScreenState extends State<NoteRemindDayScreen> {
  final _formKey = GlobalKey<FormState>();
  final TodoController _todoController = TodoController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _selectedType = 'เลือกประเภท';
  String _selectedImportance = 'เลือกระดับความสำคัญ';
  String _selectedStartTime = 'เลือกเวลาแจ้งเตือน';
  String _selectedNotifyMinutes = 'เลือกเวลาเตือนก่อนกิจกรรม';
  DateTime? _selectedStartDate;

  bool _autoValidate = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStartDate = widget.selectedDate;
    _dateController.text = "${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}";
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  List<String> _generateTimeList() {
    return List.generate(24, (index) => '${index.toString().padLeft(2, '0')}:00');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("เพิ่มรายการใหม่", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFE6E6FA),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE6E6FA), Colors.white],
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  CustomTextField(
                    label: 'ชื่องาน',
                    controller: _titleController,
                    icon: Icons.title,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'กรุณากรอกชื่องาน';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'เพิ่มรายละเอียด',
                    controller: _descriptionController,
                    maxLines: 3,
                    icon: Icons.description,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          label: 'ประเภท',
                          items: const ['เลือกประเภท', 'เรียน', 'งาน', 'อื่นๆ'],
                          value: _selectedType,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedType = value);
                            }
                          },
                          icon: Icons.category,
                          validator: _validateDropdown,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomDropdown(
                          label: 'ระดับความสำคัญ',
                          items: const ['เลือกระดับความสำคัญ', 'สำคัญมาก', 'สำคัญปานกลาง', 'สำคัญน้อย'],
                          value: _selectedImportance,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedImportance = value);
                            }
                          },
                          icon: Icons.priority_high,
                          validator: _validateDropdown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          label: 'เวลาที่ต้องการให้แจ้งเตือน',
                          items: ['เลือกเวลาแจ้งเตือน', ..._generateTimeList()],
                          value: _selectedStartTime,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedStartTime = value);
                            }
                          },
                          icon: Icons.access_time,
                          validator: _validateDropdown,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomDropdown(
                          label: 'เวลาเตือนก่อนกิจกรรมเริ่ม',
                          items: const ['เลือกเวลาเตือนก่อนกิจกรรม', '5 นาที', '10 นาที', '15 นาที', '30 นาที', '1 ชั่วโมง'],
                          value: _selectedNotifyMinutes,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedNotifyMinutes = value);
                            }
                          },
                          icon: Icons.notifications,
                          validator: _validateDropdown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'เลือกวันที่จะแจ้งเตือน',
                    controller: _dateController,
                    readOnly: true,
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedStartDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedStartDate = pickedDate;
                          _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        });
                      }
                    },
                    icon: Icons.calendar_today,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาเลือกวันที่';
                      }
                      return null;
                    },
                  ),
                   const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isLoading ? null : _submitForm,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('เพิ่มข้อมูล', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  String? _validateDropdown(String? value) {
    if (value == null || ['เลือกประเภท', 'เลือกระดับความสำคัญ', 'เลือกเวลาแจ้งเตือน', 'เลือกเวลาเตือนก่อนกิจกรรม'].contains(value)) {
      return 'กรุณาเลือกข้อมูล';
    }
    return null;
  }

  void _submitForm() async {
    setState(() {
      _autoValidate = true;
      _isLoading = true;
    });
    
    if (_formKey.currentState!.validate()) {
      String? idDevice = await _todoController.getidDevice();

      final newTodo = modeltodo.Todo(
        title: _titleController.text,
        description: _descriptionController.text,
        idDevice: idDevice.toString(),
        type: _selectedType,
        importance: _selectedImportance,
        startDate: _selectedStartDate!,
        startTime: TimeOfDay(
          hour: int.parse(_selectedStartTime.split(':')[0]),
          minute: 0,
        ),
        notifyMinutesBefore: _parseNotifyMinutes(_selectedNotifyMinutes),
        status: 'Pending',
      );

      await _todoController.addTodo(newTodo);

      setState(() {
        _isLoading = false;
      });

      if (mounted) { 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('เพิ่มรายการสำเร็จ'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        Navigator.of(context).pop(true);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  int _parseNotifyMinutes(String value) {
    switch (value) {
      case '5 นาที':
        return 5;
      case '10 นาที':
        return 10;
      case '15 นาที':
        return 15;
      case '30 นาที':
        return 30;
      case '1 ชั่วโมง':
        return 60;
      default:
        return 0;
    }
  }
}