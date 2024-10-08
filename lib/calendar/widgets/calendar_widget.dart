import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  CalendarWidget({required this.onDateSelected});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('th_TH', null);
  }

  String _getThaiMonth(DateTime date) {
    List<String> thaiMonths = [
      'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
      'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
    ];
    return thaiMonths[date.month - 1];
  }

  String _getThaiDay(DateTime date) {
    List<String> thaiDays = ['จันทร์', 'อังคาร', 'พุธ', 'พฤหัสบดี', 'ศุกร์', 'เสาร์', 'อาทิตย์'];
    return thaiDays[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'th_TH',
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          widget.onDateSelected(selectedDay);
        }
      },
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextFormatter: (date, locale) => 
          '${_getThaiMonth(date)} ${date.year + 543}',
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.black),
        weekendStyle: TextStyle(color: Colors.red),
      ),
      calendarStyle: const CalendarStyle(
        weekendTextStyle: TextStyle(color: Colors.red),
        holidayTextStyle: TextStyle(color: Colors.red),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          return Center(
            child: Text(
              '${date.day}',
              style: TextStyle(color: date.weekday == 7 || date.weekday == 6 ? Colors.red : Colors.black),
            ),
          );
        },
        selectedBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              '${date.day}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        todayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              '${date.day}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
    );
  }
}