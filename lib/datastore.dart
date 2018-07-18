import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/model.dart';

// Abstract away the datastore for the bullet app and provide functions to retrieve data.
class BulletDatastore {
  static const _entriesPrefsKey = 'BulletJournalEntriesKey';

  List<BulletEntry> entries;

  BulletDatastore(this.entries);

  // Create a BulletDatastore initialized from SharedPreferences (or an empty one if it does not yet exist).
  static Future<BulletDatastore> init() async {
    final prefs = await SharedPreferences.getInstance();
    String entriesJson = prefs.getString(_entriesPrefsKey) ?? '[]';
    return new BulletDatastore(BulletEntry.fromJsonList(json.decode(entriesJson)));
  }

  // The list of unique row names we know about.
  List<String> rowNames() {
    return entries.map((e) => e.rowName).toSet().toList();
  }

  // Entries in the datastore, sorted in reverse chronological order.
  List<BulletEntry> recentEntries() {
    var e = this.entries;
    e.sort((a, b) => b.entryDate.compareTo(a.entryDate));
    return e;
  }

  // Add a new entry to the datastore.
  void addEntry(BulletEntry entry) {
    print('Adding entry ' + entry.toString());
    entries.add(entry);
    _commit();
  }

  // Commit changes to SharedPreferences.
  void _commit() async {
    final prefs = await SharedPreferences.getInstance();
    String entryJson = json.encode(entries);
    prefs.setString(_entriesPrefsKey, entryJson);
  }
}
