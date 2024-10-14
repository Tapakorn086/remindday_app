import 'dart:async';
import 'package:flutter/material.dart';
import 'package:remindday_app/todolist/controllers/todolist_controller.dart';
import '../models/todolist_model.dart';
import '../services/todolist_service.dart';

class CurrentTaskWidget extends StatefulWidget {
  final VoidCallback onAddTask;
  final List<Todo> currentTask;

  const CurrentTaskWidget({
    Key? key,
    required this.onAddTask,
    required this.currentTask,
  }) : super(key: key);

  @override
  _CurrentTaskWidgetState createState() => _CurrentTaskWidgetState();
}

class _CurrentTaskWidgetState extends State<CurrentTaskWidget> {
  final TodoService _todoService = TodoService();
  late String _deviceId;
  late Timer _timer;
  DateTime now = DateTime.now().add(const Duration(hours: 7));

  @override
  void initState() {
    super.initState();
    _initDeviceId();
    _startTimer();
  }

  Future<void> _initDeviceId() async {
    _deviceId = await RemindDayListController().getDeviceId() ?? '';
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

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  String _getRemainingTimeText(DateTime startDateTime, DateTime now,
      String title, int? notifyBeforeStart) {
    DateTime timenow = DateTime.now();
    Duration difference = startDateTime.difference(timenow);
    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);
    int totalMinutes = hours * 60 + minutes;

    if (totalMinutes > 360) {
      return "ยังไม่มีงานที่ต้องทำ $totalMinutes";
    } else if (totalMinutes <= 6 && totalMinutes > 0) {
      return "งาน $title จะเริ่มในอีก $totalMinutes";
    } else if (totalMinutes <= notifyBeforeStart! && totalMinutes>0) {
      return "ใกล้จะถึงเวลาทำงาน $title";
    } else {
      return "งาน [ $title ] เลยกำหนดการมาแล้วนะ";
    }
  }

  Future<void> _updateTodoStatus(Todo todo, String newStatus) async {
    setState(() {
      todo.status = newStatus;
    });

    try {
      await _todoService.updateTodoStatus(todo, _deviceId);
    } catch (e) {
      setState(() {
        todo.status = todo.status == 'working' ? 'pending' : todo.status;
      });
      debugPrint('Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาดในการอัปเดตสถานะ')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building CurrentTaskWidget");
    debugPrint("Current Tasks: ${widget.currentTask.length}");
    debugPrint("Current Time: ${now.toString()}");

    for (var todo in widget.currentTask) {
      debugPrint(
          "Current Task: ${todo.title}, Status: ${todo.status}, Start Date: ${todo.startDate}, Start Time: ${todo.startTime}, Notify Before: ${todo.notifyMinutesBefore}");
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        if (widget.currentTask.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'ไม่มีงานปัจจุบัน',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: widget.onAddTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                      ),
                      child: const Text('เพิ่มงานใหม่'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: widget.currentTask.length,
              itemBuilder: (context, index) {
                Todo todo = widget.currentTask[index];
                DateTime startDateTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  int.parse(todo.startTime!.split(':')[0]),
                  int.parse(todo.startTime!.split(':')[1]),
                );

                String remainingTime = _getRemainingTimeText(startDateTime, now,
                    todo.title.toString(), todo.notifyMinutesBefore);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: startDateTime.isBefore(now)
                          ? Colors.red[100]
                          : Colors.yellow[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          startDateTime.isBefore(now)
                              ? 'เลยกำหนดการ'
                              : todo.status == 'working'
                                  ? 'กำลังทำอยู่'
                                  : 'กำลังรอเริ่ม',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: startDateTime.isBefore(now)
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          remainingTime,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (todo.status == 'pending')
                              ElevatedButton(
                                onPressed: () {
                                  _updateTodoStatus(todo, "working");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink[100],
                                ),
                                child: const Text('เริ่มทำงาน'),
                              )
                            else if (todo.status == 'working')
                              const Text(
                                'กำลังทำอยู่',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _updateTodoStatus(todo, "completed");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[100],
                              ),
                              child: const Text('เสร็จแล้ว'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '  วันนี้ทำอะไรดี ',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black, size: 30),
              onPressed: widget.onAddTask,
            ),
          ],
        ),
      ],
    );
  }
}
