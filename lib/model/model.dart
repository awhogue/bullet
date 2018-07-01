// Models for the bullet journal.

// Represents a single row in the journal, e.g. "Hours slept" or "Coffee consumed".
class BulletRow {
  final String name;
  final String comment;
  BulletRow([this.name, this.comment = ""]);
}

// A single entry in a row, with a date and value.
class BulletEntry {
  final String value;
  final DateTime entryDate;
  // Just the name of the row, not an actual reference (until we need that).
  final String rowName;
  final String comment;

  BulletEntry([this.value, this.entryDate, this.rowName, this.comment = ""]);

  BulletEntry.fromJson(Map<String, dynamic> json) 
    : value = json['value'],
      entryDate = DateTime.parse(json['dateTime'] as String),
      rowName = json['rowName'],
      comment = json['comment'];
  
  Map<String, dynamic> toJson() => 
    { 
      'value': value,
      'entryDate': entryDate,
      'rowName': rowName,
      'comment': comment,
    };

  @override
  String toString() {
    return this.rowName + ': ' + this.value + ' (' + this.entryDate.toIso8601String() + ')';
  }
}
