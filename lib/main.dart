import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            // Dragged down
            setState(() {
              _calendarFormat = CalendarFormat.week;
            });
          }
        },
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Colors.white
                  .withOpacity(0.2), // Set a transparent glassy background
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2040, 12, 31),
                  focusedDay: _selectedDate,
                  calendarFormat: _calendarFormat,
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    leftChevronVisible: true,
                    rightChevronVisible: true,
                    titleTextStyle: TextStyle(color: Colors.white),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekendStyle: TextStyle(
                        color: Colors.white), // White text for weekends
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(
                        color: Colors.white), // White text for default days
                    todayDecoration: BoxDecoration(
                      color: Colors
                          .transparent, // Transparent background for today
                      shape: BoxShape.rectangle, // Square shape for today
                      borderRadius: BorderRadius.circular(
                          8), // Adjust the border radius as needed
                      border: Border.all(color: Colors.blue, width: 1),
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors
                          .transparent, // Transparent background for selected day
                      shape:
                          BoxShape.rectangle, // Square shape for selected day
                      borderRadius: BorderRadius.circular(
                          8), // Adjust the border radius as needed
                      border:
                          Border.all(color: Colors.lightBlueAccent, width: 2),
                    ),
                    todayTextStyle: const TextStyle(
                        color: Colors.white), // White text for today's date
                    selectedTextStyle: const TextStyle(
                        color: Colors
                            .lightBlueAccent), // Light blue text for selected date
                  ),
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
                      _calendarFormat = CalendarFormat.week;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _selectedDate = focusedDay;
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
}

class EventsWidget extends StatelessWidget {
  final List<Event> events;
  final DateTime selectedDate;

  const EventsWidget(
      {super.key, required this.events, required this.selectedDate});

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
            style: const TextStyle(color: Colors.white), // Set text color for events
          ),
          subtitle: Text(
            event.date.toLocal().toString(),
            style: const TextStyle(
                color: Colors.white), // Set text color for event dates
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
