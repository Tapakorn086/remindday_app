import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../todolist/models/todolist_model.dart';
import '../controllers/calendar_controller.dart';

class CalendarTodoListWidget extends StatelessWidget {
  final CalendarController controller;

  CalendarTodoListWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final List<Todo> sortedTodos = List.from(controller.todos)
          ..sort((a, b) => (a.startTime ?? '').compareTo(b.startTime ?? ''));

        final List<Todo> incompleteTodos = sortedTodos.where((todo) => todo.status != 'completed').toList();
        final List<Todo> completedTodos = sortedTodos.where((todo) => todo.status == 'completed').toList();

        return ListView(
          children: [
            ...incompleteTodos.asMap().entries.map((entry) {
              final int index = entry.key;
              final Todo todo = entry.value;
              return _buildTodoItem(todo, isFirst: index == 0);
            }),
            if (completedTodos.isNotEmpty) const Divider(height: 30, thickness: 2),
            ...completedTodos.map((todo) => _buildTodoItem(todo, isCompleted: true)),
          ],
        );
      },
    );
  }

  Widget _buildTodoItem(Todo todo, {bool isFirst = false, bool isCompleted = false}) {
    return Container(
      color: isFirst && !isCompleted ? Colors.yellow.withOpacity(0.3) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeWidget(todo.startTime),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  if (todo.description != null && todo.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        todo.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
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