import 'package:flutter/material.dart';

class CurrentTaskWidget extends StatelessWidget {
  final VoidCallback onAddTask;

  const CurrentTaskWidget({super.key, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('กำลังทำอยู่',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('อีก 20 นาที จะเริ่ม\nออกกำลังกาย'),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[100]),
                    child: const Text('เริ่มทำงาน'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[100]),
                    child: const Text('เสร็จแล้ว'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'วันนี้ทำอะไรดี ',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add,
                    color: Colors.black, size: 30),
                onPressed:
                    onAddTask,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
