import 'package:intl/intl.dart';

// Models for the bullet journal.

// Types that the data in an entry can take.
enum BulletRowDataType {
  // A boolean value – did I do this today or not?
  Checkmark,
  // A numeric value, e.g. how many cups of coffee did I drink?
  Number,
  // A number that falls within a certain range, e.g. "Energy" on a scale of 0-10.
  NumberRange,
  // A row that's just free text.
  FreeText,
  // TODO: add an "Enumeration" type that limits a row to one of a small set of values.
}

// Ways a row can handle multiple entries in the same day.
enum BulletRowMultiEntryType {
  // Subsequent entries in the same day will overwrite the old value.
  Overwrite,
  // Subsequent entries are stored separately, but display as an accumulation. 
  // E.g. Entering "Coffee: 1" twice in the same day displays as "2"
  // E.g. Entering "Workout: X" twice in the same day displays as "XX"
  Accumulate,
  // Additional entries are stored and displayed as separate.
  // E.g. Entering "Energy: 4" and "Energy: 7" in the same day will show as two separate entries.
  Separate,
}

// Represents a single row in the journal, e.g. "Sleep" or "Coffee" or "Work out."
class BulletRow {
  // The name of the row, e.g. "Coffee" or "Sleep"
  final String name;

  // What type of row this is.
  final BulletRowDataType dataType;
  // How to treat multiple entries for this row.
  final BulletRowMultiEntryType multiEntryType;
  
  // The units for the row, e.g. "mg" or "hours".
  final String units;
  // A comment for the row.
  final String comment;
  BulletRow([this.name, this.dataType, this.multiEntryType, this.units, this.comment = ""]);

  static String dataTypeToUserString(BulletRowDataType dataType) {
    switch (dataType) {
      case BulletRowDataType.Checkmark:    return 'Checkmark';
      case BulletRowDataType.Number:       return 'Number';
      case BulletRowDataType.NumberRange:  return 'Number Range';
      case BulletRowDataType.FreeText:     return 'Free Text';
      default: 
        print('Warning: unhandled BulletRowDataType in DataTypeString(): ' + dataType.toString());
        return 'Unknown';
    }
  }

  // Reverse BulletRowDataType.toString() (NOT dataTypeToUserString()).
  // TODO: is there a way to use generics for this for any enum?
  static BulletRowDataType dataTypeFromString(String input) {
    for (BulletRowDataType t in BulletRowDataType.values) {
      if (t.toString() == input) return t;
    }
    print('Warning: unhandled BulletRowDataType in dataTypeFromString(): ' + input);
    return null;
  }

  static String multiEntryTypeToUserString(BulletRowMultiEntryType entryType) {
    switch (entryType) {
      case BulletRowMultiEntryType.Overwrite:  return 'Overwriting';
      case BulletRowMultiEntryType.Accumulate: return 'Accumulating';
      case BulletRowMultiEntryType.Separate:   return 'Separating';
      default:
        print('Warning: unhandled BulletRowMultiEntryType in MultiEntryTypeString(): ' + entryType.toString());
        return 'Unknown';
    }
  }

  // Reverse BulletRowDataType.toString() (NOT dataTypeToUserString()).
  static BulletRowMultiEntryType multiEntryTypeFromString(String input) {
    for (BulletRowMultiEntryType t in BulletRowMultiEntryType.values) {
      if (t.toString() == input) return t;
    }
    print('Warning: unhandled BulletRowMultiEntryType in multiEntryTypeFromString(): ' + input);
    return null;
  }

  // Return the value for a day using the appropriate multi-entry rules for this datatype.
  // TODO: this needs a test for the different BulletRowDataTypes.
  static String valueForDay(BulletDay day) {
    switch(day.row.multiEntryType) {
      case BulletRowMultiEntryType.Overwrite:
        return day.lastEntry().value;
      case BulletRowMultiEntryType.Accumulate: {
        switch(day.row.dataType) {
          case BulletRowDataType.Number:  // fall through and treat all numbers the same.
          case BulletRowDataType.NumberRange:
            return day.entries.fold(0, (value, element) => value + int.parse(element.value)).toString();
          default: break;  // compiler gets confused if we try to do the return here.
        }
        return day.entries.fold('', (value, element) => value + element.value);
      }
      case BulletRowMultiEntryType.Separate:
        return day.entries.map((e) => e.value).toList().join(',');
      default: {
        print('Warning: unhandled BulletRowDataType in valueForDay(): ' + day.row.toString());
        return 'Error';
      }
    }
  }

  @override
  String toString() {
    return 
      this.name + ': ' + 
      dataTypeToUserString(dataType) + ' ' + 
      multiEntryTypeToUserString(multiEntryType) + 
      (units.isEmpty ? ' (no units)' : ' in ' + units);
  }

  Map<String, dynamic> toJson() => 
    { 
      'name': name,
      'dataType': dataType.toString(),
      'multiEntryType': multiEntryType.toString(),
      'units': units,
      'comment': comment,
    };

  BulletRow.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      dataType = BulletRow.dataTypeFromString(json['dataType']),
      multiEntryType = BulletRow.multiEntryTypeFromString(json['multiEntryType']),
      units = json['units'],
      comment = json['comment'];

  static List<BulletRow> fromJsonList(List<dynamic> json) {
    return json.map<BulletRow>((entry) => BulletRow.fromJson(entry)).toList();
  }
}

// A single day in a row, which may consist of multiple BulletEntry entries.
class BulletDay {
  // The date the entry happened. Time fields are ignored.
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
