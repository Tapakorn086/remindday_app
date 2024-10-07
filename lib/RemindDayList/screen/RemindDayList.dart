import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'todo.dart'; // นำเข้าคลาส Todo
import 'package:http/http.dart' as http;
import 'package:remindday_app/todo/screens/note_remind_day_screen.dart';
import 'dart:convert';

//import 'package:remindday_app/todo/screens/note_screen.dart';

class Todo {
  final int id;
  final String title;
  final String description;
  final String type;
  final String importance;
  final String status;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.importance,
    required this.status,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      importance: json['importance'],
      status: json['status'],
    );
  }
}


class RemindDayListScreen extends StatefulWidget {
  @override
  _RemindDayListScreenState createState() => _RemindDayListScreenState();
}

class _RemindDayListScreenState extends State<RemindDayListScreen> {
  late ScrollController _scrollController;
  late DateTime _selectedDate;
  late List<DateTime> _weekDays;
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _weekDays = _generateWeekDays(_selectedDate);
    _scrollController = ScrollController(initialScrollOffset: 3 * 48.0);

    // Fetch todos from API
    fetchTodos().then((fetchedTodos) {
      setState(() {
        _todos = fetchedTodos;
      });
    }).catchError((error) {
      // Handle error if needed
      print('Error fetching todos: $error');
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<DateTime> _generateWeekDays(DateTime centerDate) {
    return List.generate(7, (index) => centerDate.subtract(Duration(days: 3 - index)));
  }

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/gettodo')); // เปลี่ยน URL ให้ตรงกับ API ของคุณ

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Widget _buildWeekDays() {
    return Container(
      height: 70,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _weekDays.length,
        itemBuilder: (context, index) {
          DateTime day = _weekDays[index];
          bool isSelected = day.day == _selectedDate.day &&
              day.month == _selectedDate.month &&
              day.year == _selectedDate.year;
          bool isToday = day.day == DateTime.now().day &&
              day.month == DateTime.now().month &&
              day.year == DateTime.now().year;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = day;
              });
            },
            child: Container(
              width: 48,
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blue : (isToday ? Colors.blue[100] : Colors.grey[200]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(day).substring(0, 1),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    day.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentTask() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('กำลังทำอยู่', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('อีก 20 นาที จะเริ่ม\nออกกำลังกาย'),
                ),
              ),
              SizedBox(width: 8),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('เริ่มทำงาน'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[100]),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('เสร็จแล้ว'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[100]),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16), // Add some space before the next row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'วันนี้ทำอะไรดี ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.black),
                 onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NoteRemindDayScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildTaskList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          return _buildTaskItem(
            _todos[index].title, // or any other property you want to show
            _todos[index].description, // or any other property you want to show
          );
        },
      ),
    );
  }

  Widget _buildTaskItem(String title, String description) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('RemindDay List', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildWeekDays(),
          _buildCurrentTask(),
          _buildTaskList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
        ],
      ),
    );
  }
}
