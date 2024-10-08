import 'package:flutter/material.dart';
import '../models/todolist_model.dart';

class TaskListWidget extends StatelessWidget {
  final List<Todo> todos;

  const TaskListWidget({Key? key, required this.todos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return _buildTaskItem(todos[index]);
        },
      ),
    );
  }

  Widget _buildTaskItem(Todo todo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title ?? 'No Title',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(todo.description ?? 'No Description'),
                  const SizedBox(height: 4),
                  Text('Status: ${todo.status ?? 'Unknown'}'),
                  Text('Start Date: ${todo.startDate ?? 'Not set'}'),
                  Text('Start Time: ${todo.startTime ?? 'Not set'}'),
                  Text('Importance: ${todo.importance ?? 'Not set'}'),
                  Text('Type: ${todo.type ?? 'Not set'}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}