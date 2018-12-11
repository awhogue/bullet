import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/bullet_entry.dart';
import 'model/bullet_row.dart';

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

  List<BulletRow> _rows;

  BulletDatastore._internal(this._rows);

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
      
      List<BulletRow> rows = BulletRow.fromJsonList(json.decode(rowsJson));

      _datastore = BulletDatastore._internal(rows);
      print('Created BulletDatastore with ${_datastore.numRows().toString()} rows and ${_datastore.numEntries().toString()} entries');
      
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
  int numEntries() { 
    return _rows.fold(0, (sum, row) => sum + row.entries.length);
  }

  // The list of unique row names we know about.
  List<String> rowNames() {
    return _rows.map<String>((BulletRow r) => r.name).toList();
  }

  // Rows and values in the datastore for a given day. 
  // If includeEmpty is true, include rows that don't yet have a value for this day.
  List<RowWithValue> rowValuesForDay(DateTime day, bool includeEmpty) {
    List<RowWithValue> rowValues = [];
    for (var row in _rows) {
      var value = row.valueForDay(day);
      if (includeEmpty || value.isNotEmpty) {
        rowValues.add(RowWithValue(row, value));
      }
    }
    return rowValues;
  }

  // Given the name of a row, return the row it's associated with, or throws an exception if that row does not exist.
  BulletRow rowForRowName(String rowName) {
    for (var row in this._rows) {
      if (row.name == rowName) {
        return row;
      }
    }
    throw new BulletDatastoreExcption('_rowForRowName() could not find BulletRow with name "' + rowName);
  }

  // Add a new entry to the datastore given a string name for a row.
  // Throws an exception if the BulletRow doesn't already exist.
  void addEntryToRowString(String rowName, BulletEntry entry) {
    BulletRow row = rowForRowName(rowName);
    addEntryToRow(row, entry);
  }

  // Add a new entry to the datastore for the given row.
  void addEntryToRow(BulletRow row, BulletEntry entry) {
    print('Adding entry ' + entry.toString());
    row.entries.add(entry);
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
    _commit();
  }

  // Commit changes to SharedPreferences.
  void _commit() {
    String rowsJson = json.encode(_rows);
    _prefs.setString(_rowsPrefsKey, rowsJson);
  }

  static JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  void debugLogDatastore() {
    print(encoder.convert(_rows));
  }
}

class BulletDatastoreExcption implements Exception {
  String cause;
  BulletDatastoreExcption(this.cause);
}