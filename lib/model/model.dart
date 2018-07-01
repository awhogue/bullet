import 'package:intl/intl.dart';

// Models for the bullet journal.

// Represents a single row in the journal, e.g. "Hours slept" or "Coffee consumed".
class BulletRow {
  final String name;
  final String comment;
  BulletRow([this.name, this.comment = ""]);
}

// A single entry in a row, with a date and value.
class BulletEntry {
  final String value;
  final DateTime dateTime;
  // Just the name of the row, not an actual reference (until we need that).
  final String rowName;
  final String comment;

  BulletEntry([this.value, this.dateTime, this.rowName, this.comment = ""]);

  @override
  String toString() {
    return this.rowName + ': ' + this.value + ' (' + this.dateTime.toIso8601String() + ')';
  }
}
