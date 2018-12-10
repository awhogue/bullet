import 'package:inflection/inflection.dart';
import 'bullet_entry.dart';

// What type of row is this?
enum RowType { 
  Number, // => int
  Text,   // => String
}

// Simple pair of a BulletRow and a String value.
class RowWithValue {
  BulletRow row;
  String value;
  RowWithValue(this.row, this.value);

  @override
  String toString() {
    return 'RowWithValue($row.name, $value)';
  }  
}

// A BulletRow models the semantic data for a single row within a journal,
// e.g. 'Coffee' or 'Workout' or 'Sleep'.
class BulletRow<V> {
  // The name of the row, e.g. "Coffee" or "Sleep"
  final String name;

  // When a second value gets added to this row in the same day, do we 
  // keep two separate entities, or accumulate them?
  final bool accumulate;

  // Type for this row. 
  final RowType type;
  
  // What units is this row measured in, if any?
  final String units;

  // A comment for the row.
  final String comment;

  // List of entries for this row. 
  // TODO: This obviously won't scale to a larger journal, will need a real database
  // instead of just a list.
  List<BulletEntry<V>> entries;

  BulletRow([this.name, this.entries, this.accumulate, this.type, this.units = '', this.comment = '']);

  // Factory to create a new BulletEntry using the right data type for the given RowType.
  static BulletEntry newEntryForType(
    RowType t,
    String stringValue,
    DateTime time,
    String comment,
  ) {
    switch (t) {
      case RowType.Number: return BulletEntry<int>(int.parse(stringValue), time, comment);
      case RowType.Text: // Fall through to avoid compiler complaints.
      default: return BulletEntry<String>(stringValue, time, comment);
    }
  }

  // When accumulating a value in this row, what is the start value? E.g. for 
  // a row with numbers, start with 0.
  dynamic startValue() {
    switch (type) {
      case RowType.Number: return 0;
      case RowType.Text:
      default: return '';
    }
  }

  // Return a renderable value for a set of entries in one day of this row.
  String valueForDay(DateTime day) {
    var value = _valueForEntries(entries.where(((e) => e.onDay(day))).toList());
    print('[$name].valueForDay(${day.toString()}) [' + entries.map((e) => e.value).toString() + '] => "$value"');
    return value;
  }

  // Return the (potentially accumulated) value for the given entries.
  String _valueForEntries(List<BulletEntry<V>> entries) {
    if (entries.isEmpty) return '';
    if (this.accumulate) {
      return entries.fold(startValue(), (value, element) => value + element.value).toString();
    } else {
      return BulletEntry.lastValue(entries).value();
    }
  }

  List<BulletEntry<V>> entriesForDay(DateTime day) {
    return entries.where((e) => e.onDay(day)).toList();
  }

  // Return a displayable string for this row's units for the given value, aware of pluralization 
  // if this is a numeric value.
  String unitsForValue(String value) {
    switch (type) {
      case RowType.Number: {
        int intVal = int.parse(value);
        if (intVal == 1) {
          return singularize(units);
        }
        return pluralize(units);
      }
      default: return units;
    }
  }

  @override
  String toString() {
    return '$name ($units, $type)';
  }

  Map<String, dynamic> toJson() => 
    { 
      'name': name,
      'entries': entries,
      'accumulate': accumulate,
      'type': type.toString(),
      'units': units,
      'comment': comment,
    };

  static RowType typeFromString(String type) {
    return RowType.values.firstWhere((v) => v.toString() == type);
  }
  BulletRow.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      entries = BulletEntry.fromJsonList(json['entries']),
      accumulate = json['accumulate'],
      type = typeFromString(json['type']),
      units = json['units'],
      comment = json['comment'];

  static List<BulletRow> fromJsonList(List<dynamic> json) {
    return json.map<BulletRow>((entry) => BulletRow.fromJson(entry)).toList();
  }
}


