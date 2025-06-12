import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendarScreen extends StatelessWidget {
  final Map<DateTime, int> availableSeatsPerDay; // تاريخ -> عدد المقاعد

  const CustomCalendarScreen({required this.availableSeatsPerDay, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("اختر تاريخ الرحلة")),
      body: TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(Duration(days: 30)),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final seats = availableSeatsPerDay[DateTime(day.year, day.month, day.day)];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${day.day}'),
                if (seats != null)
                  Text('مقاعد: $seats', style: TextStyle(fontSize: 10, color: Colors.green)),
              ],
            );
          },
        ),
        selectedDayPredicate: (day) => false, // تحديد اليوم يتم خارجيًا
        onDaySelected: (selectedDay, focusedDay) {
          Navigator.pop(context, selectedDay); // رجّع التاريخ المختار
        },
      ),
    );
  }
}
