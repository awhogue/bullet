import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/model.dart';

// Abstract away the datastore for the bullet app and provide functions to retrieve data.
//
// The main screen of the app should call init() to initialize the datastore asynchronously. 
// All other screens should be able to just call the factory constructor and get the 
// singleton instance.
class BulletDatastore {
  // Singleton instance of the datastore itself that's shared by all screens.
  static BulletDatastore _datastore;
  // Reference to SharedPreferences to be used for the life of the datastore.
  static SharedPreferences _prefs;

  // Currently store entries and rows in separate prefs entries. May want
  // to consider storing them in the same? Or if the data gets big, we may
  // need to split them up for performance reasons?
  static const _rowsPrefsKey = 'BulletJournalRowsKey';
  static const _daysPrefsKey = 'BulletJournalDaysKey';

  List<BulletRow> _rows;
  List<BulletDay> _days;

  BulletDatastore._internal(this._rows, this._days);

  // Create a BulletDatastore initialized from SharedPreferences (or an empty one if it does 
  // not yet exist).
  static Future<BulletDatastore> init() async {
    if (_datastore != null) {
      print('Called init() but BulletDatastore was already initialized');
      return _datastore;
    } else {
      print('Initializing BulletDatastore from SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();
      _prefs = prefs;
      
      String rowsJson = _prefs.getString(_rowsPrefsKey) ?? '[]';
      String daysJson = _prefs.getString(_daysPrefsKey) ?? '[]';
      
      List<BulletRow> rows = BulletRow.fromJsonList(json.decode(rowsJson));

      _datastore = BulletDatastore._internal(
        rows,
        BulletDay.fromJsonList(json.decode(daysJson), rows),
      );
      print('Created BulletDatastore with ' + _datastore.numRows().toString() + ' rows and ' + _datastore.numEntries().toString() + ' entries');
      return _datastore;
    }
  }

  factory BulletDatastore() {
    // TODO: gracefully handle uninitialized datastore. 
    if (_datastore == null) {
      throw new BulletDatastoreExcption('BulletDatastore has not been initialized. Call init() before calling BulletDatastore().');
    }
    return _datastore;
  }
  
  int numRows() { return _rows.length; }
  int numEntries() { return _days.length; }

  // The list of unique row names we know about.
  List<String> rowNames() {
    return _rows.map<String>((BulletRow r) => r.name).toList();
  }

  // Entries in the datastore, sorted in reverse chronological order.
  List<BulletDay> recentDays() {
    var d = this._days;
    d.sort((a, b) => b.entryDate.compareTo(a.entryDate)); // TODO: sub-sort alphabetically? By most recent entry?
    return d;
  }

  // Given a day, return the row it's associated with, or throws an exception if that row does not exist.
  BulletRow _rowForRowName(String rowName) {
    for (var row in this._rows) {
      if (row.name == rowName) {
        return row;
      }
    }
    throw new BulletDatastoreExcption('rowForDay could not find BulletRow with name "' + rowName);
  }

  // Add a new entry to the datastore. Creates the BulletDay if it doesn't already exist. 
  // Throws an exception if the BulletRow doesn't already exist.
  void addEntry(String rowName, BulletEntry entry) {
    print('Adding entry ' + entry.toString());

    BulletRow row = _rowForRowName(rowName);

    // Find the day, or create a new one.
    BulletDay entryDay;
    for (var day in this._days) {
      if (entry.onDay(day) && day.row.name == rowName) {
        entryDay = day;
      }
    }
    if (entryDay == null) {
      entryDay = new BulletDay(entry.entryDate, row, []);
    }
    entryDay.entries.add(entry);
    _days.add(entryDay);
    _commit();
  }

  void addRow(BulletRow row) {
    print('Adding row ' + row.toString());
    _rows.add(row);
    _commit();
  }

  void clear() {
    print('Clearing datastore!');
    _rows.clear();
    _days.clear();
    _commit();
  }

  // Commit changes to SharedPreferences.
  void _commit() {
    String rowsJson = json.encode(_rows);
    _prefs.setString(_rowsPrefsKey, rowsJson);
    String entryJson = json.encode(_days);
    _prefs.setString(_daysPrefsKey, entryJson);
  }

  static JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  void debugLogDatastore() {
    print(encoder.convert(_rows));
    print(encoder.convert(_days));
  }
}

class BulletDatastoreExcption implements Exception {
  String cause;
  BulletDatastoreExcption(this.cause);
}