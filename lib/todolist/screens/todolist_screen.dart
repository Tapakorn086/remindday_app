import 'package:flutter/material.dart';
import '../../todo/screens/note_remind_day_screen.dart';
import '../controllers/todolist_controller.dart';
import '../models/todolist_model.dart';
import '../widgets/todolist_current_task.dart';
import '../widgets/todolist_day_widget.dart';
import '../widgets/todolist_task_list.dart';

class TodoDayListScreen extends StatefulWidget {
  @override
  _TodoDayListScreenState createState() => _TodoDayListScreenState();
}

class _TodoDayListScreenState extends State<TodoDayListScreen> {
  final RemindDayListController _controller = RemindDayListController();
  List<Todo> _todos = [];
  String? deviceId;

  @override
  void initState() {
    super.initState();
    _loadDeviceId();
  }

  Future<void> _loadDeviceId() async {
    deviceId = await _controller.getDeviceId();
    if (deviceId != null) {
      _loadTodos();
    } else {
      debugPrint("Device ID is null");
    }
  }

  void _loadTodos() async {
    final todos = await _controller.fetchTodos(deviceId.toString());
    setState(() {
      _todos = todos;
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _controller.selectedDate = date;
    });
  }

  void _onAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoteRemindDayScreen()),
    );
  }
  void updateTodoStatus(Todo todo) async {
  setState(() {});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RemindDay List', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          WeekDaysWidget(
            weekDays: _controller.weekDays,
            selectedDate: _controller.selectedDate,
            onDateSelected: _onDateSelected,
          ),
          CurrentTaskWidget(onAddTask: _onAddTask),
          TaskListWidget(todos: _todos,onTodoStatusChanged: updateTodoStatus,),
        ],
      ),
    );
  }
}
