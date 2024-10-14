import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekDaysWidget extends StatefulWidget {
  final List<DateTime> weekDays;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const WeekDaysWidget({
    Key? key,
    required this.weekDays,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _WeekDaysWidgetState createState() => _WeekDaysWidgetState();
}

class _WeekDaysWidgetState extends State<WeekDaysWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToToday());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToToday() {
    final today = DateTime.now();
    final todayIndex = widget.weekDays.indexWhere((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);

    if (todayIndex != -1) {
      final scrollPosition = (todayIndex * 68.0) - (MediaQuery.of(context).size.width / 2) + 34.0;
      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.weekDays.length,
        itemBuilder: (context, index) {
          DateTime day = widget.weekDays[index];
          bool isSelected = day.day == widget.selectedDate.day &&
              day.month == widget.selectedDate.month &&
              day.year == widget.selectedDate.year;
          bool isToday = day.day == DateTime.now().day &&
              day.month == DateTime.now().month &&
              day.year == DateTime.now().year;

          return GestureDetector(
            onTap: () => widget.onDateSelected(day),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelected
                    ? Colors.deepPurple
                    : (isToday ? Colors.deepPurple.withOpacity(0.1) : Colors.white),
                boxShadow: [
                  if (isSelected || isToday)
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE', 'th').format(day).replaceAll('.', ''),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}