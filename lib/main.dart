import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CalendarScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor:
            Colors.blueGrey[900], // Set dark bluish ash background
         textTheme: const TextTheme(
          titleSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

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
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swiped to the right
            _updateFocusedDate(-1);
          } else if (details.primaryVelocity! < 0) {
            // Swiped to the left
            _updateFocusedDate(1);
          }
        },
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Colors.white.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2040, 12, 31),
                  focusedDay: _focusedDate,
                  calendarFormat: _calendarFormat,
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    titleTextStyle: TextStyle(color: Colors.white),
                    leftChevronMargin: EdgeInsets.all(0),
                    rightChevronMargin: EdgeInsets.all(0),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekendStyle: TextStyle(color: Colors.white),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue, width: 1),
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.lightBlueAccent, width: 2),
                    ),
                    todayTextStyle: const TextStyle(color: Colors.white),
                    selectedTextStyle: const TextStyle(color: Colors.lightBlueAccent),
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
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: EventsWidget(events: _events, selectedDate: _selectedDate),
            ),
          ],
        ),
      ),
    );
  }

  void _updateFocusedDate(int monthOffset) {
    setState(() {
      _focusedDate = DateTime.utc(
        _focusedDate.year,
        _focusedDate.month + monthOffset,
        1,
      );
    });
  }
}

class EventsWidget extends StatelessWidget {
  final List<Event> events;
  final DateTime selectedDate;

  const EventsWidget({
    Key? key,
    required this.events,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredEvents = events
        .where((event) =>
            event.date.isAfter(selectedDate) &&
            event.date.isBefore(selectedDate.add(Duration(days: 1))))
        .toList();

    return ListView.builder(
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        final event = filteredEvents[index];
        return ListTile(
          title: Text(
            event.title,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            event.date.toLocal().toString(),
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}

class Event {
  final String title;
  final DateTime date;

  Event(this.title, this.date);
}
