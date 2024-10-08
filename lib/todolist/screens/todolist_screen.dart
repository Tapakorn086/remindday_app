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

  List<Todo> _getFilteredTodos() {
    return _todos.where((todo) {
      if (todo.startDate == null) return false;
      DateTime todoDate = DateTime.parse(todo.startDate!);
      return todoDate.year == _controller.selectedDate.year &&
          todoDate.month == _controller.selectedDate.month &&
          todoDate.day == _controller.selectedDate.day;
    }).toList();
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

  void _onAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoteRemindDayScreen()),
    );
    if (result == true) {
      setState(() {
        _loadTodos();
      });
    }
  }

  void updateTodoStatus(Todo todo) async {
    try {
      await _controller.updateTodoStatus(todo);
    } catch (e) {
      debugPrint('Error updating todo status: $e');
      setState(() {
        todo.status = todo.status == 'completed' ? 'pending' : 'completed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Todo> filteredTodos = _getFilteredTodos();

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('RemindDay List', style: TextStyle(color: Colors.black)),
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
          TaskListWidget(
            todos: filteredTodos,
            onTodoStatusChanged: updateTodoStatus,
          ),
        ],
      ),
    );
  }
}
