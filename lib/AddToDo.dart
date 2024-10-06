import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NoteRemindDayScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class NoteRemindDayScreen extends StatefulWidget {
  const NoteRemindDayScreen({super.key, required this.title});

  final String title;

  @override
  _NoteRemindDayScreenState createState() => _NoteRemindDayScreenState();
}

class _NoteRemindDayScreenState extends State<NoteRemindDayScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedType;
  String? _selectedImportance;
  String? _selectedStartTime;
  String? _selectedReminderTime;
  DateTime? _selectedStartDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('NoteRemindDay'),
        backgroundColor: Color(0xFFE6E6FA), // Light purple color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
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
                  decoration: InputDecoration(
                    labelText: 'เพิ่มรายละเอียด',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
              
                DropdownButtonFormField<String>(
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
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                  validator: (value) => value == null ? 'กรุณาเลือกประเภท' : null,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
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
                  onChanged: (value) {
                    setState(() {
                      _selectedImportance = value;
                    });
                  },
                  validator: (value) => value == null ? 'กรุณาเลือกความสำคัญ' : null,
                ),
               
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'เวลาเริ่มต้น',
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(24, (index) {
                    return DropdownMenuItem<String>(
                      value: '$index:00',
                      child: Text('$index:00'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedStartTime = value;
                    });
                  },
                  validator: (value) => value == null ? 'กรุณาเลือกเวลาเริ่มต้น' : null,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
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
                  onChanged: (value) {
                    setState(() {
                      _selectedReminderTime = value;
                    });
                  },
                  validator: (value) => value == null ? 'กรุณาเลือกเวลาเตือน' : null,
                ),
                   SizedBox(height: 16),
                  TextFormField(
                  decoration: InputDecoration(
                    labelText: 'เลือกวันที่เริ่มต้น',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    _selectedStartDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                  },
                ),
             
                SizedBox(height: 24),
                ElevatedButton(
                  child: const Text('เพิ่มข้อมูล'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, 
                    backgroundColor: Color(0xFFE6E6FA),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process data
                      // You can implement your data processing logic here
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
        ],
        onTap: (index) {
          // Handle bottom navigation tap here
        },
      ),
    );
  }
}
