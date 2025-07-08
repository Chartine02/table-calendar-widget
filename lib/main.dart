import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const TableCalendarDemo());
}

class TableCalendarDemo extends StatelessWidget {
  const TableCalendarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Calendar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CalendarDemoPage(),
    );
  }
}

class CalendarDemoPage extends StatefulWidget {
  const CalendarDemoPage({super.key});

  @override
  State<CalendarDemoPage> createState() => _CalendarDemoPageState();
}

class _CalendarDemoPageState extends State<CalendarDemoPage>
    with TickerProviderStateMixin {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime? _selectedDay;
  late DateTime? _rangeStart;
  late DateTime? _rangeEnd;
  late Map<DateTime, List<Event>> _events;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _rangeStart = null;
    _rangeEnd = null;
    _events = _getEvents();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Sample events for demonstration
  Map<DateTime, List<Event>> _getEvents() {
    final now = DateTime.now();
    final events = <DateTime, List<Event>>{};

    // Add some sample events
    events[DateTime(now.year, now.month, now.day)] = [
      Event('Team Meeting', 'Discuss project progress'),
      Event('Lunch with Client', 'Business lunch'),
    ];

    events[DateTime(now.year, now.month, now.day + 2)] = [
      Event('Doctor Appointment', 'Annual checkup'),
    ];

    events[DateTime(now.year, now.month, now.day + 5)] = [
      Event('Birthday Party', 'Friend\'s birthday'),
      Event('Movie Night', 'Watch new release'),
    ];

    events[DateTime(now.year, now.month, now.day + 10)] = [
      Event('Conference Call', 'International meeting'),
    ];

    return events;
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final events = <Event>[];
    for (
      DateTime d = start;
      d.isBefore(end.add(const Duration(days: 1)));
      d = d.add(const Duration(days: 1))
    ) {
      events.addAll(_getEventsForDay(d));
    }
    return events;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
    });
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
    });
  }

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Calendar Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Toggle theme (you can implement theme switching here)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar Format Selector
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFormatButton(CalendarFormat.month, 'Month'),
                _buildFormatButton(CalendarFormat.twoWeeks, '2 Weeks'),
                _buildFormatButton(CalendarFormat.week, 'Week'),
              ],
            ),
          ),

          // Main Calendar Widget
          TableCalendar<Event>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: _onFormatChanged,
            onPageChanged: _onPageChanged,

            // Event markers
            eventLoader: _getEventsForDay,

            // Custom styling
            calendarStyle: CalendarStyle(
              // Selected day styling
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),

              // Today styling
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),

              // Range styling
              rangeHighlightColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.1),
              rangeStartDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),

              // Weekend styling
              weekendTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),

              // Outside days styling
              outsideDaysVisible: true,
              outsideTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),

              // Default day styling
              defaultTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),

              // Event marker styling
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              markerSize: 8.0,
              markerMargin: const EdgeInsets.symmetric(horizontal: 0.3),
            ),

            // Header styling
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12.0),
              ),
              formatButtonTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              titleTextStyle: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Theme.of(context).colorScheme.primary,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            // Days of week styling
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              weekendStyle: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Calendar builders for custom day widgets
            calendarBuilders: CalendarBuilders(
              // Custom marker builder
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      width: 8.0,
                      height: 8.0,
                      child: Center(
                        child: Text(
                          '${events.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 6.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },

              // Custom selected day builder
              selectedBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },

              // Custom today builder
              todayBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Events List
          Expanded(child: _buildEventsList()),
        ],
      ),

      // Floating Action Button for adding events
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFormatButton(CalendarFormat format, String label) {
    final isSelected = _calendarFormat == format;
    return ElevatedButton(
      onPressed: () => _onFormatChanged(format),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
        foregroundColor:
            isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
      ),
      child: Text(label),
    );
  }

  Widget _buildEventsList() {
    List<Event> events;
    String title;

    if (_rangeStart != null && _rangeEnd != null) {
      events = _getEventsForRange(_rangeStart!, _rangeEnd!);
      title =
          'Events (${DateFormat('MMM dd').format(_rangeStart!)} - ${DateFormat('MMM dd').format(_rangeEnd!)})';
    } else if (_selectedDay != null) {
      events = _getEventsForDay(_selectedDay!);
      title = 'Events for ${DateFormat('MMM dd, yyyy').format(_selectedDay!)}';
    } else {
      events = _getEventsForDay(_focusedDay);
      title = 'Events for ${DateFormat('MMM dd, yyyy').format(_focusedDay)}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child:
              events.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No events for this period',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Icon(Icons.event, color: Colors.white),
                          ),
                          title: Text(
                            event.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(event.description),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _removeEvent(event);
                            },
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Event'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Event Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    _addEvent(
                      _selectedDay ?? _focusedDay,
                      Event(titleController.text, descriptionController.text),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  void _addEvent(DateTime day, Event event) {
    setState(() {
      final key = DateTime(day.year, day.month, day.day);
      if (_events[key] != null) {
        _events[key]!.add(event);
      } else {
        _events[key] = [event];
      }
    });
  }

  void _removeEvent(Event event) {
    setState(() {
      _events.removeWhere((key, events) {
        events.remove(event);
        return events.isEmpty;
      });
    });
  }
}

class Event {
  final String title;
  final String description;

  Event(this.title, this.description);

  @override
  String toString() => title;
}
