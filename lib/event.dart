import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final TimeOfDay time;

  Event(this.title, this.description, this.time);

  @override
  String toString() => title;
}
