// A single entry in the journal.
abstract class BulletEntry {
  // The date and time the entry happened.
  final DateTime time;
  // A comment for the entry.
  final String comment;

  BulletEntry([this.time, this.comment = ""]);

  // The value of this entry as a string.
  String value();

  // The type of this entry. 
  // TODO: how to do reflection in dart for things like fromJson?
  String type();

  bool onDay(DateTime day) {
    return (
      this.time.year == day.year &&
      this.time.month == day.month &&
      this.time.day == day.day
    );
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

  // Accumulate the value of this entry with the given entry into a single value.
  // E.g. for a NumberEntry, sum the numbers.
  dynamic accumulateValues(dynamic other) {
    return this.value() + ' ' + other;
  }
  // The starting value for accumulateValues().
  dynamic startValue() { return ''; }

  @override String toString() { return '"' + value() + '" (' + type() + ') ' + time.toString(); }

  // Basic toJson for an entry. Subclasses should call this and add their fields to the Map.
  Map<String, dynamic> toJson() => 
    { 
      'value': value(),
      'type': type(),
      'time': time.toIso8601String(),
      'comment': comment,
    };

  // Basic fromJson for an entry. Subclasses should call this and pull their fields (including value) from the Map.
  BulletEntry.fromJsonMap(Map<String, dynamic> json)
    : time = DateTime.parse(json['time'] as String),
      comment = json['comment'];

  // Reflect on the stored 'type' in JSON and instantiate the right type of BulletEntry.
  factory BulletEntry.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'TextEntry': return TextEntry.fromJson(json);
      case 'CheckmarkEntry': return CheckmarkEntry.fromJson(json);
      case 'NumberEntry': return NumberEntry.fromJson(json);
      default: throw new BulletEntryException('Unknown BulletEntry type in json: ' + json['type']);
    }
  }

  static List<BulletEntry> fromJsonList(List<dynamic> json) {
    return json.map<BulletEntry>((entry) => BulletEntry.fromJson(entry)).toList();
  }
}

class TextEntry extends BulletEntry {
  final String val;
  TextEntry([String val, DateTime time, String comment = '']) :
    this.val = val,
    super(time, comment);
  
  @override String value() { return val; }
  @override String type() { return 'TextEntry'; }

  TextEntry.fromJson(Map<String, dynamic> json)
    : val = json['value'],
      super.fromJsonMap(json);
}

class CheckmarkEntry extends BulletEntry {
  static const String checked = '√';
  static const String unchecked = '_';

  final bool val;
  CheckmarkEntry([bool val, DateTime time, String comment = '']) :
    this.val = val,
    super(time, comment);
  
  @override String value() { return (val ? checked : unchecked); }
  @override String type() { return 'CheckmarkEntry'; }

  CheckmarkEntry.fromJson(Map<String, dynamic> json)
    : val = (json['value'] == checked),
      super.fromJsonMap(json);
}

class NumberEntry extends BulletEntry {
  final int val;
  NumberEntry([int val, DateTime time, String comment = '']) :
    this.val = val,
    super(time, comment);
  
  @override String value() { return val.toString(); }
  @override String type() { return 'NumberEntry'; }

  dynamic accumulateValues(dynamic other) {
    return this.value() + other;
  }
  dynamic startValue() { return 0; }

  NumberEntry.fromJson(Map<String, dynamic> json)
    : val = int.parse(json['value']),
      super.fromJsonMap(json);
}

class BulletEntryException implements Exception {
  String cause;
  BulletEntryException(this.cause);
}