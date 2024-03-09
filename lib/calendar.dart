import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'events.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  final List<Event> _events = [
    Event('Meeting with Team', DateTime.utc(2024, 3, 12, 10, 0)),
    Event('Lunch with Client', DateTime.utc(2024, 3, 15, 12, 30)),
    Event('Project Deadline', DateTime.utc(2024, 3, 20, 18, 0)),
    Event('Teleportation', DateTime.utc(2024, 3, 20, 18, 0)),
    Event('Conference Call', DateTime.utc(2024, 3, 25, 14, 0)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Memory Calendar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Column(
        children: [
          // Other widgets in the main Column
          Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.white.withOpacity(0.2),
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(3000, 12, 31),
                  focusedDay: _focusedDate,
                  calendarFormat: _calendarFormat,
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    titleTextStyle: TextStyle(color: Colors.white),
                    headerPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    leftChevronMargin: EdgeInsets.all(0),
                    rightChevronMargin: EdgeInsets.all(0),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: Colors.white),
                    weekdayStyle: TextStyle(color: Colors.white),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colors.white),
                    weekendTextStyle: const TextStyle(color: Color.fromARGB(255, 219, 219, 219)),
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue, width: 1),
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: Colors.lightBlueAccent, width: 1),
                    ),
                    todayTextStyle: const TextStyle(color: Colors.white),
                    selectedTextStyle:
                        const TextStyle(color: Colors.lightBlueAccent),
                  ),
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                    CalendarFormat.week: 'Week',
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDate = focusedDay;
                      _calendarFormat = CalendarFormat.week;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDate = focusedDay;
                    });
                  },
                  eventLoader: (day) {
                    // Return the events for the given day
                    return _events
                        .where((event) => isSameDay(event.date, day))
                        .toList();
                  },
                ),
                Container(
                  height: 2,
                  width: 100,
                  color: Colors.white,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: EventsWidget(events: _events, selectedDate: _selectedDate),
          )
        ],
      ),
    );
  }
}
