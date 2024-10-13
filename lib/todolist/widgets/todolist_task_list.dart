// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/todolist_model.dart';

// class TaskListWidget extends StatefulWidget {
//   final List<Todo> todos;
//   final Function(Todo) onTodoStatusChanged;

//   const TaskListWidget({
//     Key? key,
//     required this.todos,
//     required this.onTodoStatusChanged,
//   }) : super(key: key);

//   @override
//   _TaskListWidgetState createState() => _TaskListWidgetState();
// }

// class _TaskListWidgetState extends State<TaskListWidget> {
//   late List<Todo> incompleteTodos;
//   late List<Todo> completedTodos;

//   @override
//   void initState() {
//     super.initState();
//     _sortAndSeparateTodos();
//   }

//   @override
//   void didUpdateWidget(TaskListWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.todos != oldWidget.todos) {
//       _sortAndSeparateTodos();
//     }
//   }

//   void _sortAndSeparateTodos() {
//     List<Todo> sortedTodos = List.from(widget.todos)
//       ..sort((a, b) => (a.startTime ?? '').compareTo(b.startTime ?? ''));
    
//     incompleteTodos = sortedTodos.where((todo) => todo.status != 'completed').toList();
//     completedTodos = sortedTodos.where((todo) => todo.status == 'completed').toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView(
//         children: [
//           ...incompleteTodos.map(_buildTaskItem),
//           if (completedTodos.isNotEmpty) const Divider(height: 30, thickness: 2),
//           ...completedTodos.map(_buildTaskItem),
//         ],
//       ),
//     );
//   }

//   Widget _buildTaskItem(Todo todo) {
//     Color backgroundColor;
//     switch (todo.importance?.toLowerCase()) {
//       case 'สำคัญมาก':
//         backgroundColor = Colors.red[100]!;
//         break;
//       case 'สำคัญปานกลาง':
//         backgroundColor = Colors.yellow[100]!;
//         break;
//       case 'สำคัญน้อย':
//         backgroundColor = Colors.green[100]!;
//         break;
//       default:
//         backgroundColor = Colors.grey[200]!;
//     }

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         children: [
//           Checkbox(
//             value: todo.status == 'completed',
//             onChanged: (bool? value) {
//               setState(() {
//                 todo.status = value! ? 'completed' : 'pending';
//               });
//               widget.onTodoStatusChanged(todo);
//               _sortAndSeparateTodos();
//             },
//           ),
//           _buildTimeWidget(todo.startTime),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: backgroundColor,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     todo.title ?? 'No Title',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       decoration: todo.status == 'completed'
//                           ? TextDecoration.lineThrough
//                           : TextDecoration.none,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     todo.description ?? 'No Description',
//                     style: TextStyle(
//                       fontSize: 14,
//                       decoration: todo.status == 'completed'
//                           ? TextDecoration.lineThrough
//                           : TextDecoration.none,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimeWidget(String? timeString) {
//     if (timeString == null || timeString.isEmpty) {
//       return const SizedBox(width: 50);
//     }

//     try {
//       final time = DateFormat('HH:mm').parse(timeString);
//       final formattedTime = DateFormat('HH:mm').format(time);
//       return SizedBox(
//         width: 50,
//         child: Text(
//           formattedTime,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.blue[700],
//           ),
//         ),
//       );
//     } catch (e) {
//       return const SizedBox(width: 50);
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // อย่าลืม import provider
import '../models/todolist_model.dart';
import '../notifiers/todo_notifier.dart';

class TaskListWidget extends StatefulWidget {
  final List<Todo> todos;
  final Function(Todo) onTodoStatusChanged;

  const TaskListWidget({
    Key? key,
    required this.todos,
    required this.onTodoStatusChanged,
  }) : super(key: key);

  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  late List<Todo> incompleteTodos;
  late List<Todo> completedTodos;

  @override
  void initState() {
    super.initState();
    _sortAndSeparateTodos();
  }

  @override
  void didUpdateWidget(TaskListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.todos != oldWidget.todos) {
      _sortAndSeparateTodos();
    }
  }

  void _sortAndSeparateTodos() {
    List<Todo> sortedTodos = List.from(widget.todos)
      ..sort((a, b) => (a.startTime ?? '').compareTo(b.startTime ?? ''));
    
    incompleteTodos = sortedTodos.where((todo) => todo.status != 'completed').toList();
    completedTodos = sortedTodos.where((todo) => todo.status == 'completed').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoNotifier>(
      builder: (context, todoNotifier, child) {
        // รับ todos จาก TodoNotifier
        final todos = todoNotifier.todos;

        // แยก todo เป็น completed และ incomplete
        _sortAndSeparateTodos();

        return Expanded(
          child: ListView(
            children: [
              ...incompleteTodos.map(_buildTaskItem),
              if (completedTodos.isNotEmpty) const Divider(height: 30, thickness: 2),
              ...completedTodos.map(_buildTaskItem),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskItem(Todo todo) {
    Color backgroundColor;
    switch (todo.importance?.toLowerCase()) {
      case 'สำคัญมาก':
        backgroundColor = Colors.red[100]!;
        break;
      case 'สำคัญปานกลาง':
        backgroundColor = Colors.yellow[100]!;
        break;
      case 'สำคัญน้อย':
        backgroundColor = Colors.green[100]!;
        break;
      default:
        backgroundColor = Colors.grey[200]!;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: todo.status == 'completed',
            onChanged: (bool? value) {
              if (value != null) {
                String newStatus = value ? 'completed' : 'pending';
                todo.status = newStatus;

                // อัปเดตสถานะใน TodoNotifier
                Provider.of<TodoNotifier>(context, listen: false).updateTodoStatus(todo, newStatus);

                // เรียกใช้ onTodoStatusChanged
                widget.onTodoStatusChanged(todo);
                
                // เรียก sortAndSeparateTodos เพื่อให้ UI อัปเดต
                _sortAndSeparateTodos();
              }
            },
          ),
          _buildTimeWidget(todo.startTime),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title ?? 'No Title',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: todo.status == 'completed'
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    todo.description ?? 'No Description',
                    style: TextStyle(
                      fontSize: 14,
                      decoration: todo.status == 'completed'
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeWidget(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return const SizedBox(width: 50);
    }

    try {
      final time = DateFormat('HH:mm').parse(timeString);
      final formattedTime = DateFormat('HH:mm').format(time);
      return SizedBox(
        width: 50,
        child: Text(
          formattedTime,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.blue[700],
          ),
        ),
      );
    } catch (e) {
      return const SizedBox(width: 50);
    }
  }
}
