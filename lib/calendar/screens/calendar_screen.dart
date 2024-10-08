import 'package:flutter/material.dart';
import 'package:remindday_app/calendar/controllers/calendar_controller.dart';
import 'package:remindday_app/calendar/widgets/calendar_todo_list_widget.dart';
import 'package:remindday_app/calendar/widgets/calendar_widget.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarController controller;

  @override
  void initState() {
    super.initState();
    controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ปฏิทิน')),
      body: Column(
        children: [
          CalendarWidget(
            onDateSelected: controller.changeSelectedDate,
          ),
          Expanded(
            child: CalendarTodoListWidget(controller: controller),
          ),
        ],
      ),
    );
  }

}