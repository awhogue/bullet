import 'model/model.dart';

// Abstract away the datastore for the bullet app and provide functions to retrieve data.
class BulletDatastore {
  static BulletDatastore init() {
    return new BulletDatastore();
  }

  List<BulletRow> rows() {
    List<BulletEntry> entries = BulletDatastoreUtils.generateFakeEntries();
    return entries.map((e) => e.row).toSet().toList();
  }

  List<String> rowNames() {
    List<String> rowNames = rows().map((r) => r.name).toSet().toList();
    rowNames.sort();
    return rowNames;
  }

  List<BulletEntry> entries() {
    return BulletDatastoreUtils.generateFakeEntries();
  }

  void saveEntry(BulletEntry entry) {
    print('Saving entry ' + entry.toString());
  }
}

class BulletDatastoreUtils {
  static List<BulletEntry> generateFakeEntries() {
    final List<DateTime> d = 
      [
        new DateTime(2018, 3, 29),
        new DateTime(2018, 3, 30),
        new DateTime(2018, 3, 31),
        new DateTime(2018, 4, 1),
        new DateTime(2018, 4, 2),
      ];
    
    List<BulletRow> rows = [
      new BulletRow('Coffee'), 
      new BulletRow('Alcohol'), 
      new BulletRow('Work Out'),
    ];

    return [
      new BulletEntry('3', d[0], rows[0]),
      new BulletEntry('4', d[1], rows[0]),
      new BulletEntry('2', d[2], rows[0]),
      new BulletEntry('3', d[3], rows[0]),
      new BulletEntry('5', d[4], rows[0]),
      new BulletEntry('0', d[0], rows[1]),
      new BulletEntry('0', d[1], rows[1]),
      new BulletEntry('2', d[2], rows[1]),
      new BulletEntry('5', d[3], rows[1]),
      new BulletEntry('0', d[4], rows[1]),
      new BulletEntry('X', d[0], rows[2]),
      new BulletEntry('', d[1], rows[2]),
      new BulletEntry('', d[2], rows[2]),
      new BulletEntry('X', d[3], rows[2]),
      new BulletEntry('', d[4], rows[2]),
    ];
  }
} // class BulletDatastoreUtils