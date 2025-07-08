import 'package:flutter/material.dart';
import 'calendar_demo_page.dart';

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
