import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:remindday_app/todolist/widgets/todolist_detail_task.dart';
import '../models/todolist_model.dart';

class TaskListWidget extends StatefulWidget {
  final List<Todo> todos;
  final Function(Todo) onTodoStatusChanged;
  final VoidCallback refreshTodos;

  const TaskListWidget({
    super.key,
    required this.todos,
    required this.onTodoStatusChanged,
    required this.refreshTodos,
  });

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
    setState(() {
      List<Todo> sortedTodos = List.from(widget.todos)
        ..sort((a, b) => (a.startTime ?? '').compareTo(b.startTime ?? ''));

      incompleteTodos =
          sortedTodos.where((todo) => todo.status != 'completed').toList();
      completedTodos =
          sortedTodos.where((todo) => todo.status == 'completed').toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          ...incompleteTodos.map(_buildTaskItem),
          if (completedTodos.isNotEmpty)
            const Divider(height: 30, thickness: 2),
          ...completedTodos.map(_buildTaskItem),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Todo todo) {
    Color backgroundColor = _getBackgroundColor(todo.importance);
    bool isWorking = todo.status == 'working';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoDetailScreen(todo: todo),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border:
                  isWorking ? Border.all(color: Colors.blue, width: 2) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 8,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomLeft: Radius.circular(6),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Checkbox(
                          value: todo.status == 'completed',
                          onChanged: (bool? value) async {
                            todo.status = value! ? 'completed' : 'pending';
                            await widget.onTodoStatusChanged(todo);
                            widget.refreshTodos();
                          },
                        ),
                        _buildTimeWidget(todo.startTime),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _truncateText(
                                            todo.title ?? 'No Title', 25),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          decoration: todo.status == 'completed'
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (isWorking)
                                      const Icon(Icons.work,
                                          color: Colors.blue, size: 20),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _truncateText(
                                            todo.description ??
                                                'No Description',
                                            50),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          decoration: todo.status == 'completed'
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isWorking)
            Positioned(
              top: 0,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'กำลังทำงานอยู่',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    return text.length > maxLength
        ? '${text.substring(0, maxLength)}...'
        : text;
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
