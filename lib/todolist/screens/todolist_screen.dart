// import 'package:flutter/material.dart';
// import '../../todo/screens/note_remind_day_screen.dart';
// import '../controllers/todolist_controller.dart';
// import '../models/todolist_model.dart';
// import '../widgets/todolist_current_task.dart';
// import '../widgets/todolist_day_widget.dart';
// import '../widgets/todolist_task_list.dart';

// class TodoDayListScreen extends StatefulWidget {
//   @override
//   _TodoDayListScreenState createState() => _TodoDayListScreenState();
// }

// class _TodoDayListScreenState extends State<TodoDayListScreen> {
//   final RemindDayListController _controller = RemindDayListController();
//   List<Todo> _todos = [];
//   String? deviceId;

//   @override
//   void initState() {
//     super.initState();
//     _loadDeviceId();
//   }

//   Future<void> _loadDeviceId() async {
//     deviceId = await _controller.getDeviceId();
//     if (deviceId != null) {
//       _loadTodos();
//     } else {
//       debugPrint("Device ID is null");
//     }
//   }

//   List<Todo> _getFilteredTodos() {
//     return _todos.where((todo) {
//       if (todo.startDate == null) return false;
//       DateTime todoDate = DateTime.parse(todo.startDate!);
//       return todoDate.year == _controller.selectedDate.year &&
//           todoDate.month == _controller.selectedDate.month &&
//           todoDate.day == _controller.selectedDate.day;
//     }).toList();
//   }

//   Future<void> _loadTodos() async {
//   if (deviceId == null) {
//     debugPrint("Device ID is null");
//     return;
//   }
  
//   try {
//     final todos = await _controller.fetchTodos(
//       deviceId: deviceId.toString(),
//       date: _controller.selectedDate,
//     );
//     setState(() {
//       _todos = todos;
//     });
//   } catch (e) {
//     debugPrint("Error fetching todos: $e");
//   }
// }

  

//   void _onDateSelected(DateTime date) async {
//     setState(() {
//       _controller.selectedDate = date;
//     });
//     await _loadTodos();
//   }

// void _onAddTask() async {
//   DateTime now = DateTime.now();
//   DateTime today = DateTime(now.year, now.month, now.day);
//   DateTime selectedDate = DateTime(_controller.selectedDate.year, _controller.selectedDate.month, _controller.selectedDate.day);

//   if (selectedDate.isBefore(today)) {
//     // แสดงข้อความแจ้งเตือนว่าไม่สามารถเพิ่มงานในวันที่ผ่านมาแล้วได้
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('ไม่สามารถเพิ่มงานในวันที่ผ่านมาแล้วได้'),
//         backgroundColor: Colors.red,
//       ),
//     );
//     return;
//   }

//   final result = await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => NoteRemindDayScreen(selectedDate: _controller.selectedDate)),
//   );
//   if (result == true) {
//     setState(() {
//       _loadTodos();
//     });
//   }
// }

//   void updateTodoStatus(Todo todo) async {
//     try {
//       await _controller.updateTodoStatus(todo);
//     } catch (e) {
//       debugPrint('Error updating todo status: $e');
//       setState(() {
//         todo.status = todo.status == 'completed' ? 'pending' : 'completed';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Todo> filteredTodos = _getFilteredTodos();

//     return Scaffold(
//       appBar: AppBar(
//         title:
//             const Text('RemindDay List', style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           WeekDaysWidget(
//             weekDays: _controller.weekDays,
//             selectedDate: _controller.selectedDate,
//             onDateSelected: _onDateSelected,
//           ),
//           CurrentTaskWidget(
//              onAddTask: _onAddTask,
            
//           //   todos: filteredTodos, // ส่ง todos ทั้งหมด
//           ),
//           TaskListWidget(
//             todos: filteredTodos,
//             onTodoStatusChanged: updateTodoStatus,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // เพิ่ม import
import '../../todo/screens/note_remind_day_screen.dart';
import '../controllers/todolist_controller.dart';
import '../models/todolist_model.dart';
import '../widgets/todolist_current_task.dart';
import '../widgets/todolist_day_widget.dart';
import '../widgets/todolist_task_list.dart';
import '../notifiers/todo_notifier.dart'; // เพิ่ม import

class TodoDayListScreen extends StatefulWidget {
  @override
  _TodoDayListScreenState createState() => _TodoDayListScreenState();
}

class _TodoDayListScreenState extends State<TodoDayListScreen> {
  final RemindDayListController _controller = RemindDayListController();
  String? deviceId;

  @override
  void initState() {
    super.initState();
    _loadDeviceId();
  }

  Future<void> _loadDeviceId() async {
    deviceId = await _controller.getDeviceId();
    if (deviceId != null) {
      await _loadTodos();
    } else {
      debugPrint("Device ID is null");
    }
  }

  Future<void> _loadTodos() async {
    if (deviceId == null) {
      debugPrint("Device ID is null");
      return;
    }
    
    try {
      final todos = await _controller.fetchTodos(
        deviceId: deviceId.toString(),
        date: _controller.selectedDate,
      );
      Provider.of<TodoNotifier>(context, listen: false).setTodos(todos); // ใช้ TodoNotifier
    } catch (e) {
      debugPrint("Error fetching todos: $e");
    }
  }

  void _onDateSelected(DateTime date) async {
    setState(() {
      _controller.selectedDate = date;
    });
    await _loadTodos();
  }

  void _onAddTask() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime selectedDate = DateTime(_controller.selectedDate.year, _controller.selectedDate.month, _controller.selectedDate.day);

    if (selectedDate.isBefore(today)) {
      // แสดงข้อความแจ้งเตือนว่าไม่สามารถเพิ่มงานในวันที่ผ่านมาแล้วได้
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่สามารถเพิ่มงานในวันที่ผ่านมาแล้วได้'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteRemindDayScreen(selectedDate: _controller.selectedDate)),
    );
    if (result == true) {
      await _loadTodos(); // โหลด ToDo ใหม่หลังจากเพิ่ม
    }
  }

void updateTodoStatus(Todo todo) async {
  try {
    // อัปเดตสถานะ Todo ใน API หรือฐานข้อมูล
    await _controller.updateTodoStatus(todo);
    
    // เปลี่ยนสถานะ Todo และอัปเดตใน Notifier
    String newStatus = todo.status == 'completed' ? 'pending' : 'completed';
    todo.status = newStatus; // เปลี่ยนสถานะ
    Provider.of<TodoNotifier>(context, listen: false).updateTodoStatus(todo, newStatus);
    
    // เรียก notifyListeners() ใน Notifier เพื่ออัปเดต UI
  } catch (e) {
    debugPrint('Error updating todo status: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    List<Todo> filteredTodos = Provider.of<TodoNotifier>(context).todos.where((todo) {
      if (todo.startDate == null) return false;
      DateTime todoDate = DateTime.parse(todo.startDate!);
      return todoDate.year == _controller.selectedDate.year &&
          todoDate.month == _controller.selectedDate.month &&
          todoDate.day == _controller.selectedDate.day;
    }).toList();

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
          CurrentTaskWidget(
            onAddTask: _onAddTask,
          ),
          TaskListWidget(
            todos: filteredTodos,
            onTodoStatusChanged: updateTodoStatus,
          ),
        ],
      ),
    );
  }
}

