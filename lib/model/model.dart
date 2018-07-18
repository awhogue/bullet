// Models for the bullet journal.

// Represents a single row in the journal, e.g. "Hours slept" or "Coffee consumed".
// NOTE: not currently used – bring it back when creating new rows with comments and units.
class BulletRow {
  // The name of the row, e.g. "Coffee" or "Sleep"
  final String name;
  // The units for the row, e.g. "mg" or "hours".
  final String units;
  // A comment for the row.
  final String comment;
  BulletRow([this.name, this.units, this.comment = ""]);
}

// A single entry in a row, with a date and value.
class BulletEntry {
  // The value of the entry, e.g. "10" or "X"
  final String value;
  // The date the entry happened.
  final DateTime entryDate;
  // The name of the row this entry is in. (Eventually this may need to be an actual reference to a BulletRow.)
  final String rowName;
  // A comment for the entry.
  final String comment;

  BulletEntry([this.value, this.entryDate, this.rowName, this.comment = ""]);

  @override
  String toString() {
    return this.rowName + ': ' + this.value + ' (' + this.entryDate.toIso8601String() + ')';
  }

  BulletEntry.fromJson(Map<String, dynamic> json)
    : value = json['value'],
      entryDate = DateTime.parse(json['entryDate'] as String),
      rowName = json['rowName'],
      comment = json['comment'];

  Map<String, dynamic> toJson() => 
    { 
      'value': value,
      'entryDate': entryDate.toIso8601String(),
      'rowName': rowName,
      'comment': comment,
    };

  static List<BulletEntry> fromJsonList(List<dynamic> json) {
    return json.map<BulletEntry>((entry) => BulletEntry.fromJson(entry)).toList();
  }
}
