import 'dart:async';
import 'package:flutter/material.dart';
import 'package:remindday_app/todolist/controllers/todolist_controller.dart';
import '../models/todolist_model.dart';

class CurrentTaskWidget extends StatefulWidget {
  final VoidCallback onAddTask;
  final List<Todo> currentTask;
  final Function refreshTodos;

  const CurrentTaskWidget({
    super.key,
    required this.onAddTask,
    required this.currentTask,
    required this.refreshTodos,
  });

  @override
  _CurrentTaskWidgetState createState() => _CurrentTaskWidgetState();
}

class _CurrentTaskWidgetState extends State<CurrentTaskWidget> {
  final RemindDayListController _controller = RemindDayListController();
  late Timer _timer;
  DateTime now = DateTime.now().add(const Duration(hours: 7));

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        now = DateTime.now().add(const Duration(hours: 7));
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getRemainingTimeText(
      String startDateTime, String title, int? notifyBeforeStart) {
    DateTime timenow = DateTime.now();
    String startDateTimeString = "$startDateTime ${widget.currentTask[0].startTime}";
    DateTime startDateTimeObj = DateTime.parse(startDateTimeString);
    Duration difference = startDateTimeObj.difference(timenow);
    int totalMinutes = difference.inMinutes;

    debugPrint("check startDateTimeObj: $startDateTimeObj");
    debugPrint("check timenow: $timenow");
    debugPrint("check totalMinyes: $totalMinutes");
    debugPrint("check difference: $difference");

    if (totalMinutes > 360) {
      return "ยังไม่ถึงเวลาเริ่มงาน";
    } else if (totalMinutes <= 360 && totalMinutes > notifyBeforeStart!) {
      if (totalMinutes > 60) {
        int hours = totalMinutes ~/ 60;
        int minutes = totalMinutes % 60;
        return "งาน $title จะเริ่มในอีก $hours ชั่วโมง $minutes นาที";
      } else {
        return "งาน $title จะเริ่มในอีก 1 ชั่วโมง";
      }
    } else if (totalMinutes <= notifyBeforeStart! && totalMinutes > 0) {
      return "ใกล้จะถึงเวลาทำงาน $title จะเริ่มในอีก $totalMinutes นาที";
    } else {
      return "งาน [ $title ] เลยกำหนดการมาแล้ว";
    }
  }

  bool _shouldShowStartButton(DateTime startDateTime) {
    DateTime timenow = DateTime.now();
    Duration difference = startDateTime.difference(timenow);
    int totalMinutes = difference.inMinutes;
    return totalMinutes <= 360;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        if (widget.currentTask.isEmpty)
          _buildEmptyTaskWidget()
        else
          _buildCurrentTaskCard(),
        const SizedBox(height: 16),
        _buildAddTaskButton(),
      ],
    );
  }

  Widget _buildEmptyTaskWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'ไม่มีงานที่ต้องทำ',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.onAddTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('เพิ่มงานใหม่',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTaskCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.currentTask[0].title.toString(),
              style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(height: 8),
            Text(
              (() {
                DateTime startDateTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  int.parse(widget.currentTask[0].startTime!.split(':')[0]),
                  int.parse(widget.currentTask[0].startTime!.split(':')[1]),
                );
                return _getRemainingTimeText(
                  widget.currentTask[0].startDate.toString(),
                  widget.currentTask[0].title.toString(),
                  widget.currentTask[0].notifyMinutesBefore,
                );
              })(),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_shouldShowStartButton(DateTime(
                      now.year,
                      now.month,
                      now.day,
                      int.parse(widget.currentTask[0].startTime!.split(':')[0]),
                      int.parse(widget.currentTask[0].startTime!.split(':')[1]),
                    )) &&
                    widget.currentTask[0].status != 'working')
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        widget.currentTask[0].status = "working";
                      });
                      await _controller.updateTodoStatus(widget.currentTask[0]);
                      widget.refreshTodos();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('เริ่มทำงาน',
                        style: TextStyle(color: Colors.white)),
                  ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      widget.currentTask[0].status = "completed";
                    });
                    await _controller.updateTodoStatus(widget.currentTask[0]);
                    widget.refreshTodos();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('เสร็จแล้ว',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTaskButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'วันนี้ทำอะไรดี',
            style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.deepPurple, size: 30),
            onPressed: widget.onAddTask,
          ),
        ],
      ),
    );
  }
}
