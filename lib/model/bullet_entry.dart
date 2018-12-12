import 'package:bullet/util.dart';

// A single entry in the journal, parameterized by the datatype of the entry itself
// (e.g. String or int).
//
// The parameterized type needs to handle the following operations:
//   toString()
//   +
class BulletEntry<T> {
  // The value of the entry itself.
  final T value;
  // The date and time the entry happened.
  final DateTime time;
  // A comment for the entry.
  final String comment;

  BulletEntry([this.value, this.time, this.comment = ""]);

  BulletEntry copyWithTime(DateTime time) {
    return BulletEntry(this.value, time, this.comment);
  }

  // The value of this entry as a string.
  @override String toString() { return value.toString(); }

  @override bool operator ==(o) => o is BulletEntry<T> && o.value == value && o.time == time && o.comment == comment;
  @override int get hashCode => '${value.toString()} ${time.toString()} $comment'.hashCode;

  // The type of this entry. 
  // TODO: how to do reflection in dart for things like fromJson?
  // TODO: or just switch to using RowType
  String type() { return value.runtimeType.toString(); }

  bool onDay(DateTime day) {
    return BulletUtil.sameDay(this.time, day);
  }

  // Return the most recent value in the given list of entries.
  static BulletEntry lastValue(List<BulletEntry> entries) {
    return entries.reduce((value, element) {
      if (element.time.isAfter(value.time)) {
        return element;
      } else {
        return value;
      }
    });
  }

  // Basic toJson for an entry. Subclasses should call this and add their fields to the Map.
  Map<String, dynamic> toJson() => 
    { 
      'value': value,
      'type': type(),
      'time': time.toIso8601String(),
      'comment': comment,
    };

  // Reflect on the stored 'type' in JSON and instantiate the right type of BulletEntry.
  static BulletEntry fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'String': 
        return BulletEntry<String>(
          json['value'], 
          DateTime.parse(json['time'] as String),
          json['comment'],
        );
      case 'int':
        return BulletEntry<int>(
          json['value'],
          DateTime.parse(json['time'] as String),
          json['comment'],
        );
      // TODO: handle boolean / checkmark fields?
      default: throw new BulletEntryException('Unknown BulletEntry type in json: ' + json['type']);
    }
  }

  static List<BulletEntry> fromJsonList(List<dynamic> json) {
    return json.map<BulletEntry>((entry) => fromJson(entry)).toList();
  }
}

class BulletEntryException implements Exception {
  String cause;
  BulletEntryException(this.cause);
}