import 'package:intl/intl.dart';

// Models for the bullet journal.

// Represents a single row in the journal, e.g. "Hours slept" or "Coffee consumed".
class BulletRow {
  final String name;
  final String comment;
  BulletRow([this.name, this.comment = ""]);
}

// A single entry in a row, with a date and value.
// TODO: this is OK for a pretty sparse matrix, but eventually want a better representation
// for a table like this.
class BulletEntry {
  final String value;
  final DateTime dateTime;
  // TODO: Do we even need a BulletRow object? Or can we just have a string and handle
  // it by `select where row='Foo'`? The only thing we'd lose is comments.
  final BulletRow row;
  final String comment;

  BulletEntry([this.value, this.dateTime, this.row, this.comment = ""]);

  final  _formatter = DateFormat(DateFormat.MONTH_DAY);
  @override
  String toString() {
    return this.row.name + ': ' + this.value + ' (' + this._formatter.format(this.dateTime) + ')';
  }
}
