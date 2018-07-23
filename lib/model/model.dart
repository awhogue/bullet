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

  @override
  String toString() {
    return 
      this.name + ': ' + 
      dataTypeToUserString(dataType) + ' ' + 
      multiEntryTypeToUserString(multiEntryType) + 
      (units.isEmpty ? ' in ' + units : ' (no units)');
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

// A single entry in a row, with a date and value.
class BulletEntry {
  // The value of the entry, e.g. "10" or "X"
  final String value;
  // The date the entry happened.
  final DateTime entryDate;
  // The name of the row this entry is in. For now, this is just a string that is identical to 
  // the "name" field of BulletRow. Someday we'll make this a real ID.
  final String rowName;
  // A comment for the entry.
  final String comment;

  BulletEntry([this.value, this.entryDate, this.rowName, this.comment = ""]);

  @override
  String toString() {
    return this.rowName + ': ' + this.value + ' (' + this.entryDate.toIso8601String() + ')';
  }

  Map<String, dynamic> toJson() => 
    { 
      'value': value,
      'entryDate': entryDate.toIso8601String(),
      'rowName': rowName,
      'comment': comment,
    };

  BulletEntry.fromJson(Map<String, dynamic> json)
    : value = json['value'],
      entryDate = DateTime.parse(json['entryDate'] as String),
      rowName = json['rowName'],
      comment = json['comment'];

  static List<BulletEntry> fromJsonList(List<dynamic> json) {
    return json.map<BulletEntry>((entry) => BulletEntry.fromJson(entry)).toList();
  }
}
