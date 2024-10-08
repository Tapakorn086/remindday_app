import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekDaysWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weekDays.length,
        itemBuilder: (context, index) {
          DateTime day = weekDays[index];
          bool isSelected = day.day == selectedDate.day &&
              day.month == selectedDate.month &&
              day.year == selectedDate.year;
          bool isToday = day.day == DateTime.now().day &&
              day.month == DateTime.now().month &&
              day.year == DateTime.now().year;

          return GestureDetector(
            onTap: () => onDateSelected(day),
            child: Container(
              width: 48,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.blue
                    : (isToday ? Colors.blue[100] : Colors.grey[200]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE', 'th').format(day).replaceAll('.', ''),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    day.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
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
