import 'package:inflection/inflection.dart';
import 'bullet_entry.dart';

// What type of row is this?
enum RowType {
  Number, // => int
  Text, // => String
}

// How do we handle multiple entries on the same day for this row?
enum MultiEntryHandling {
  Separate, // Keep them separate
  Sum, // Sum them up
  Average, // Average them
  KeepLast, // Keep the most recent entry only
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

  // List of entries for this row.
  // TODO: This obviously won't scale to a larger journal, will need a real database
  // instead of just a list.
  List<BulletEntry<V>> entries;

  // How do we handle multiple entries in the same day?
  final MultiEntryHandling multiEntryHandling;

  // Type for this row.
  final RowType type;

  // The default value for entries created in this row.
  final V defaultValue;

  // Minimum and maximum value for this row (for numeric types).
  final V minValue;
  final V maxValue;

  // What units is this row measured in, if any?
  final String units;

  // A comment for the row.
  final String comment;

  BulletRow(
    this.name, 
    this.entries, 
    this.multiEntryHandling, 
    this.type,
    {
      this.defaultValue,
      this.minValue,
      this.maxValue,
      this.units = '',
      this.comment = ''
    }
  );

  static BulletRow rowFromStrings(
    String rowName,
    MultiEntryHandling multiEntryHandling,
    RowType type,
    String defaultValue,
    String minValue,
    String maxValue,
    String units,
    String comment,
  ) {
    switch (type) {
      case RowType.Number: {
        return new BulletRow<int>(
          rowName,
          [],
          multiEntryHandling,
          type,
          defaultValue: (defaultValue.isNotEmpty) ? int.parse(defaultValue) : null,
          minValue: (minValue.isNotEmpty) ? int.parse(minValue) : null,
          maxValue: (maxValue.isNotEmpty) ? int.parse(maxValue) : null,
          units: units,
          comment: comment
        );
      }
      case RowType.Text:
      default: {
        return new BulletRow<String>(
          rowName,
          [],
          multiEntryHandling,
          type,
          defaultValue: (defaultValue.isNotEmpty) ? defaultValue : null,
          units: units,
          comment: comment
        );
      }
    }
  }

  // Factory to create a new BulletEntry using the right data type for the given RowType.
  static BulletEntry newEntryForType(
    RowType t,
    String stringValue,
    DateTime time,
    String comment,
  ) {
    switch (t) {
      case RowType.Number:
        return BulletEntry<int>(int.parse(stringValue), time, comment);
      case RowType.Text: // Fall through to avoid compiler complaints.
      default:
        return BulletEntry<String>(stringValue, time, comment);
    }
  }

  // Creates a new "default" BulletEntry for this row.
  // E.g. for an accumulated numeric row, this would create an entry that was just a "1" at the current time.
  BulletEntry newDefaultEntry() {
    if (this.type == RowType.Number) {
      return BulletEntry<int>(
          int.parse(this.defaultValue.toString()), DateTime.now());
    }
    return BulletEntry<String>(this.defaultValue.toString(), DateTime.now());
  }

  // When accumulating a value in this row, what is the start value? E.g. for
  // a row with numbers, start with 0.
  dynamic _startValue() {
    switch (type) {
      case RowType.Number:
        return 0;
      case RowType.Text:
      default:
        return '';
    }
  }

  // Return a renderable value for a set of entries in one day of this row.
  String valueForDay(DateTime day) {
    var value = _valueForEntries(entries.where(((e) => e.onDay(day))).toList());
    print('[$name].valueForDay(${day.toString()}) [' +
        entries.map((e) => e.value).toString() +
        '] => "$value"');
    return value;
  }

  // Return the value for the given entries, respecting the MultiEntryHandling for this row.
  String _valueForEntries(List<BulletEntry<V>> entries) {
    if (entries.isEmpty) return '';
    switch (this.multiEntryHandling) {
      case MultiEntryHandling.Sum:
        return entries.fold(_startValue(), (v, e) => v + e.value).toString();
      case MultiEntryHandling.Average:
        return (entries.fold(_startValue(), (v, e) => v + e.value) /
                entries.length)
            .toString();
      case MultiEntryHandling.KeepLast:
        return BulletEntry.lastValue(entries).value;
      case MultiEntryHandling
          .Separate: // fall through to use this as default case and make the compiler happy.
      default:
        return entries.map((e) => e.value.toString()).join(', ');
    }
  }

  // TODO: move this into the datastore?
  List<BulletEntry<V>> entriesForDay(DateTime day) {
    return entries.where((e) => e.onDay(day)).toList();
  }

  // Return a displayable string for this row's units for the given value, aware of pluralization
  // if this is a numeric value.
  String unitsForValueString(String value) {
    switch (this.type) {
      case RowType.Number:
        {
          int intVal = int.parse(value);
          if (intVal == 1) {
            return singularize(units);
          }
          return pluralize(units);
        }
      default:
        return units;
    }
  }

  @override
  String toString() {
    String unitsStr = (null != this.units && this.units.isNotEmpty) ? '$units ,' : '';
    return '$name ($unitsStr$type)';
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'entries': entries,
        'multiEntryHandling': multiEntryHandling.toString(),
        'type': type.toString(),
        'defaultValue': defaultValue,
        'minValue': minValue,
        'maxValue': maxValue,
        'units': units,
        'comment': comment,
      };

  static RowType typeFromString(String type) {
    return RowType.values.firstWhere((v) => v.toString() == type);
  }

  static MultiEntryHandling multiFromString(String type) {
    return MultiEntryHandling.values.firstWhere((v) => v.toString() == type);
  }

  BulletRow.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        entries = BulletEntry.fromJsonList(json['entries']),
        multiEntryHandling = multiFromString(json['multiEntryHandling']),
        type = typeFromString(json['type']),
        defaultValue = json['defaultValue'],
        minValue = json['minValue'],
        maxValue = json['maxValue'],
        units = json['units'],
        comment = json['comment'];

  static List<BulletRow> fromJsonList(List<dynamic> json) {
    return json.map<BulletRow>((entry) => BulletRow.fromJson(entry)).toList();
  }
}
