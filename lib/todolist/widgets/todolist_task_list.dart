import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todolist_model.dart';

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
    return Expanded(
      child: ListView(
        children: [
          ...incompleteTodos.map(_buildTaskItem),
          if (completedTodos.isNotEmpty) const Divider(height: 30, thickness: 2),
          ...completedTodos.map(_buildTaskItem),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Todo todo) {
    Color backgroundColor = _getBackgroundColor(todo.importance);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 80, // ปรับความสูงตามความเหมาะสม
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
          Checkbox(
            value: todo.status == 'completed',
            onChanged: (bool? value) {
              setState(() {
                todo.status = value! ? 'completed' : 'pending';
              });
              widget.onTodoStatusChanged(todo);
              _sortAndSeparateTodos();
            },
          ),
          _buildTimeWidget(todo.startTime),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
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
                      color: Colors.grey[600],
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

  Color _getBackgroundColor(String? importance) {
    switch (importance?.toLowerCase()) {
      case 'สำคัญมาก':
        return Colors.red[100]!;
      case 'สำคัญปานกลาง':
        return Colors.yellow[100]!;
      case 'สำคัญน้อย':
        return Colors.green[100]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Widget _buildTimeWidget(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return const SizedBox(width: 50);
    }

    try {
      final time = DateFormat('HH:mm').parse(timeString);
      final formattedTime = DateFormat('HH:mm').format(time);
      return Container(
        width: 50,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          formattedTime,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      );
    } catch (e) {
      return const SizedBox(width: 50);
    }
  }
}