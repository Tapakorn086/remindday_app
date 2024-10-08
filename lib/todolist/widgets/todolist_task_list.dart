import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.todos.length,
        itemBuilder: (context, index) {
          return _buildTaskItem(widget.todos[index]);
        },
      ),
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
              setState(() {
                todo.status = value! ? 'completed' : 'pending';
              });
              widget.onTodoStatusChanged(todo);
            },
          ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        todo.title ?? 'No Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: todo.status == 'completed'
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      Icon(
                        Icons.more_vert,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    todo.startTime ?? 'Not set',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    todo.description ?? 'No Description',
                    style: TextStyle(
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
}