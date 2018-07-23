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
  static const _entriesPrefsKey = 'BulletJournalEntriesKey';

  List<BulletRow> _rows;
  List<BulletEntry> _entries;

  BulletDatastore._internal(this._rows, this._entries);

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
      String entriesJson = _prefs.getString(_entriesPrefsKey) ?? '[]';
      
      _datastore = BulletDatastore._internal(
        BulletRow.fromJsonList(json.decode(rowsJson)),
        BulletEntry.fromJsonList(json.decode(entriesJson)),
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
  int numEntries() { return _entries.length; }

  // The list of unique row names we know about.
  List<String> rowNames() {
    return _rows.map<String>((BulletRow r) => r.name).toList();
  }

  // Entries in the datastore, sorted in reverse chronological order.
  List<BulletEntry> recentEntries() {
    var e = this._entries;
    e.sort((a, b) => b.entryDate.compareTo(a.entryDate));
    return e;
  }

  // Add a new entry to the datastore.
  void addEntry(BulletEntry entry) {
    print('Adding entry ' + entry.toString());
    _entries.add(entry);
    _commit();
  }

  void addRow(BulletRow row) {
    print('Adding row ' + row.toString());
    _rows.add(row);
    _commit();
  }

  // Commit changes to SharedPreferences.
  void _commit() {
    String rowsJson = json.encode(_rows);
    _prefs.setString(_rowsPrefsKey, rowsJson);
    String entryJson = json.encode(_entries);
    _prefs.setString(_entriesPrefsKey, entryJson);
  }
}

class BulletDatastoreExcption implements Exception {
  String cause;
  BulletDatastoreExcption(this.cause);
}