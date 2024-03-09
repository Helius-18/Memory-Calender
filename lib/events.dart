import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

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

    return Container(
      margin: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: filteredEvents.length,
        itemBuilder: (context, index) {
          final event = filteredEvents[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              shape: BoxShape.rectangle,
              color: Colors.white.withOpacity(0.2),
            ),
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              title: Text(
                event.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                DateFormat.yMMMMd().add_jm().format(event.date.toLocal()),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Event {
  final String title;
  final DateTime date;

  Event(this.title, this.date);
}
