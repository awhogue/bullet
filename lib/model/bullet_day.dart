import 'package:intl/intl.dart';
import 'bullet_row.dart';

// A single day in a row, which may consist of multiple BulletEntry entries.
class BulletDay {
  // The date the entry happened. Time fields (hour, minute, etc.) are ignored.
  final DateTime entryDate;
  // The name of the row this entry is in. For now, this is just a string that is identical to 
  // the "name" field of BulletRow. Someday we'll make this a real ID.
  final BulletRow row;
  // The individual entries within the day.
  List<BulletEntry> entries;

  final _formatter = new DateFormat.MMMMd();

  BulletDay([this.entryDate, this.row, this.entries]);

  BulletEntry lastEntry() {
    return this.entries.reduce((value, element) {
      if (element.entryDate.isAfter(value.entryDate)) {
        return element;
      } else {
        return value;
      }
    });
  }

  @override
  String toString() {
    return _formatter.format(this.entryDate) + ' ' + this.row.name + ': ' + this.entries.toString();
  }

   Map<String, dynamic> toJson() => 
    { 
      'entryDate': entryDate.toIso8601String(),
      'rowName': row.name,
      'entries': entries,
    };

  // Find a row in the given list of rows. Someday we'll have real foreign keys.
  static BulletRow _findRow(String rowName, List<BulletRow> rows) {
    for (var row in rows) {
      if (row.name == rowName) return row;
    }
    return null;
  }

  // Create a BulletDay from the given json. Rows should have been created already, and passed in.
  BulletDay.fromJson(Map<String, dynamic> json, List<BulletRow> rows) :
    entryDate = DateTime.parse(json['entryDate'] as String),
    row = _findRow(json['rowName'], rows),
    entries = BulletEntry.fromJsonList(json['entries']);

  static List<BulletDay> fromJsonList(List<dynamic> json, List<BulletRow> rows) {
    return json.map<BulletDay>((day) => BulletDay.fromJson(day, rows)).toList();
  }
}

// A particular entry within a day, with a time of entry. May be displayed 
// individually or rolled up into a BulletDay
class BulletEntry {
  // The value of the entry, e.g. "10" or "X"
  final String value;
  // The date and time the entry happened.
  final DateTime entryDate;
  // A comment for the entry.
  final String comment;

  BulletEntry([this.value, this.entryDate, this.comment = ""]);

  bool onDay(BulletDay day) {
    return (
      this.entryDate.year == day.entryDate.year &&
      this.entryDate.month == day.entryDate.month &&
      this.entryDate.day == day.entryDate.day
    );
  }

  @override
  String toString() {
    return this.value + ' (' + this.entryDate.toIso8601String() + ')';
  }

  Map<String, dynamic> toJson() => 
    { 
      'value': value,
      'entryDate': entryDate.toIso8601String(),
      'comment': comment,
    };

  BulletEntry.fromJson(Map<String, dynamic> json)
    : value = json['value'],
      entryDate = DateTime.parse(json['entryDate'] as String),
      comment = json['comment'];

  static List<BulletEntry> fromJsonList(List<dynamic> json) {
    return json.map<BulletEntry>((entry) => BulletEntry.fromJson(entry)).toList();
  }
}
