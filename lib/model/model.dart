// Models for the bullet journal.

// Represents a single row in the journal, e.g. "Hours slept" or "Coffee consumed".
class BulletRow {
  final String name;
  List<BulletEntry> entries;
  final String comment;
  BulletRow([this.name, this.entries, this.comment = ""]);
}

// A single entry in a row, with a date and value.
// TODO: this is OK for a pretty sparse matrix, but eventually want a better representation
// for a table like this.
class BulletEntry {
  final String value;
  final DateTime dateTime;
  final String comment;
  BulletEntry([this.value, this.dateTime, this.comment = ""]);
}

class BulletModelUtils {
  static List<BulletRow> generateFakeRows() {
    final List<DateTime> d = 
      [
        new DateTime(2018, 3, 29),
        new DateTime(2018, 3, 30),
        new DateTime(2018, 3, 31),
        new DateTime(2018, 4, 1),
        new DateTime(2018, 4, 2),
      ];
    
    return [
      new BulletRow('Coffee', 
        [
          new BulletEntry('3', d[0]),
          new BulletEntry('4', d[1]),
          new BulletEntry('2', d[2]),
          new BulletEntry('3', d[3]),
          new BulletEntry('5', d[4]),
        ]
      ),
      new BulletRow('Alcohol', 
        [
          new BulletEntry('0', d[0]),
          new BulletEntry('0', d[1]),
          new BulletEntry('2', d[2]),
          new BulletEntry('5', d[3]),
          new BulletEntry('0', d[4]),
        ]
      ),
      new BulletRow('Work Out', 
        [
          new BulletEntry('X', d[0]),
          new BulletEntry('', d[1]),
          new BulletEntry('', d[2]),
          new BulletEntry('X', d[3]),
          new BulletEntry('', d[4]),
        ]
      ),
    ];
  }
} // class BulletModelUtils