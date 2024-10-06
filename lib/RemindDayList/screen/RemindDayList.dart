import 'package:flutter/material.dart'; 
import 'package:intl/intl.dart';

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
      home: RemindDayListScreen(),
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
  List<bool> _taskCompletionStatus = [false, false, false];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _weekDays = _generateWeekDays(_selectedDate);
    _scrollController = ScrollController(
      initialScrollOffset: 3 * 48.0,  // 48.0 is the width of each day item
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<DateTime> _generateWeekDays(DateTime centerDate) {
    return List.generate(7, (index) => centerDate.subtract(Duration(days: 3 - index)));
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
                    MaterialPageRoute(builder: (context) => AddTaskScreen()),
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
      child: ListView(
        children: [
          _buildTaskItem('08:00 นาฬิกา', 'ตื่นนอน', Colors.pink[100]!, 0),
          _buildTaskItem('09:00 นาฬิกา', 'ทานอาหารเช้า', Colors.green[100]!, 1),
          _buildTaskItem('10:00 นาฬิกา', 'ออกกำลังกาย', Colors.pink[100]!, 2),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String time, String task, Color color, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: _taskCompletionStatus[index],
              onChanged: (bool? value) {
                setState(() {
                  _taskCompletionStatus[index] = value!;
                });
              },
              activeColor: Colors.green,
              checkColor: Colors.white,
              shape: CircleBorder(),
              side: BorderSide(color: Colors.grey),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(time),
                  Text(task),
                  Icon(Icons.more_vert),
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

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Center(
        child: Text('Add your task details here!'),
      ),
    );
  }
}
