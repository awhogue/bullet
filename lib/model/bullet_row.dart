// A BulletRow models the semantic data for a single row within a journal,
// e.g. 'Coffee' or 'Workout' or 'Sleep'.

import 'bullet_day.dart';

// The most generic type of BulletRow, containing free text.
class BulletRow {
  // The name of the row, e.g. "Coffee" or "Sleep"
  final String name;

  // When a second value gets added to this row in the same day, do we 
  // keep two separate entities, or accumulate them?
  final bool accumulate;

  // A comment for the row.
  final String comment;

  BulletRow([this.name, this.accumulate, this.comment = '']);

  // Render the value in this row for the given day. 
  String valueForDay(BulletDay day) {
    if (this.accumulate) {
      return BulletRow.joinedValuesForDay(day);
    } else {
      return BulletRow.lastValueForDay(day);
    }
  }

  // Returns true if the given value is allowed for this BulletRow type. 
  // E.g. if the row is a number range, is the entry within the range?
  bool valueIsValid(String value) { return true; }

  static String lastValueForDay(BulletDay day) {
    return day.lastEntry().value;
  }

  static String joinedValuesForDay(BulletDay day) {
    return day.entries.map((e) => e.value).toList().join('');
  }

  @override
  String toString() {
    return this.name + ' (' + (accumulate ? 'acc' : 'sep') + ')';
  }

  Map<String, dynamic> toJson() => 
    { 
      'type': 'BulletRow',  // TODO: replace this with Classname?
      'name': name,
      'accumulate': accumulate,
      'comment': comment,
    };

  BulletRow.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      accumulate = json['accumulate'],
      comment = json['comment'];

  static BulletRow anyRowFromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'BulletRow': return BulletRow.fromJson(json);
      case 'CheckmarkRow': return CheckmarkRow.fromJson(json);
      case 'NumberRow': return NumberRow.fromJson(json);
      case 'NumberRangeRow': return NumberRangeRow.fromJson(json);
      default: throw new BulletRowExcption('Unknown BulletRow type in json: ' + json['type']);
    }
  }


  static List<BulletRow> fromJsonList(List<dynamic> json) {
    return json.map<BulletRow>((entry) => BulletRow.fromJson(entry)).toList();
  }
}

// A journal entry that is a simple checkmark – did I do it or not?
class CheckmarkRow extends BulletRow {
  static const String checked = '√';
  static const String unchecked = '_';

  CheckmarkRow([String name, bool accumulate, String comment = '']): super(name, accumulate, comment);

  @override
  String toString() {
    return super.toString() + ' (type: Checkmark)';
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['type'] = 'CheckmarkRow';
    return json;
  }

  CheckmarkRow.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

// A journal entry that contains numbers. 
// TODO: currently storing everything as strings, which requires parsing, but we could push this
// inheritance down into the BulletEntry to store values as ints somehow?
class NumberRow extends BulletRow {
  final String units;

  NumberRow([String name, bool accumulate, String units, String comment = '']) : 
    this.units = units,
    super(name, accumulate);

  @override
  String valueForDay(BulletDay day) {
    if (this.accumulate) {
      return day.entries.fold(0, (value, element) => value + int.parse(element.value)).toString();
    } else {
      return BulletRow.lastValueForDay(day);
    }
  }

  @override
  String toString() {
    return super.toString() + ' (type: Number in ' + units + ')';
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['type'] = 'NumberRow';
    json['units'] = units;
    return json;
  }

  NumberRow.fromJson(Map<String, dynamic> json)
    : units = json['units'],
      super.fromJson(json);
}

// A journal entry that contains numbers, restricted to a certain range. 
class NumberRangeRow extends NumberRow {
  // The max and min for entries in this row, inclusive.
  final int max;
  final int min;

  NumberRangeRow([String name, bool accumulate, String units, int min, int max, String comment = '']) : 
    this.max = max,
    this.min = min,
    super(name, accumulate, units);

  @override
  bool valueIsValid(String value) {
    int val = int.parse(value);
    return (val <= this.max && val >= this.min);
  }

  @override
  String toString() {
    return super.toString() + ' (type: Number in ' + units + ' range [' + min.toString() + ',' + max.toString() + '])';
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['type'] = 'NumberRangeRow';
    json['max'] = max;
    json['min'] = min;
    return json;
  }

  NumberRangeRow.fromJson(Map<String, dynamic> json)
    : max = json['max'],
      min = json['min'],
      super.fromJson(json);
}

class BulletRowExcption implements Exception {
  String cause;
  BulletRowExcption(this.cause);
}