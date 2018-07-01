import 'model/model.dart';

// Abstract away the datastore for the bullet app and provide functions to retrieve data.
class BulletDatastore {
  static BulletDatastore init() {
    return new BulletDatastore();
  }

  // List<BulletRow> rows() {
  //   List<BulletEntry> entries = BulletDatastoreUtils.generateFakeEntries();
  //   return entries.map((e) => e.row).toSet().toList();
  // }

  List<String> rowNames() {
    List<String> rowNames = BulletDatastoreUtils.generateFakeEntries().map((e) => e.rowName).toSet().toList();
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
    
    return [
      new BulletEntry('3', d[0], 'Coffee'),
      new BulletEntry('4', d[1], 'Coffee'),
      new BulletEntry('2', d[2], 'Coffee'),
      new BulletEntry('3', d[3], 'Coffee'),
      new BulletEntry('5', d[4], 'Coffee'),
      new BulletEntry('0', d[0], 'Alcohol'),
      new BulletEntry('0', d[1], 'Alcohol'),
      new BulletEntry('2', d[2], 'Alcohol'),
      new BulletEntry('5', d[3], 'Alcohol'),
      new BulletEntry('0', d[4], 'Alcohol'),
      new BulletEntry('X', d[0], 'Work Out'),
      new BulletEntry('', d[1], 'Work Out'),
      new BulletEntry('', d[2], 'Work Out'),
      new BulletEntry('X', d[3], 'Work Out'),
      new BulletEntry('', d[4], 'Work Out'),
    ];
  }
} // class BulletDatastoreUtils