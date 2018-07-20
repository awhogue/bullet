import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/model.dart';
import '../datastore.dart';
import 'new_entry.dart';

class BulletHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BulletHomeState();
}

class BulletHomeState extends State<BulletHome> {
  BulletDatastore _datastore;

  // Recently added entries, sorted in reverse chronological order.
  List<BulletEntry> _recentEntries = List<BulletEntry>();
  
  final _formatter = DateFormat(DateFormat.MONTH_DAY);

  BulletHomeState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bullet Journal'),
      ),
      // TODO: refactor this database initialization / FutureBuilder into an InheritedWidget a la 
      // https://stackoverflow.com/questions/46990200/flutter-how-to-pass-user-data-to-all-views
      // https://docs.flutter.io/flutter/widgets/InheritedWidget-class.html
      // or maybe
      // https://github.com/brianegan/scoped_model/blob/master/lib/scoped_model.dart
      body: FutureBuilder<BulletDatastore>(
        future: BulletDatastore.init(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            _datastore = snapshot.data;
            _recentEntries = _datastore.recentEntries();
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: RaisedButton(
                        onPressed: _pushNewEntry,
                        child: Text('New Entry'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      itemCount: _recentEntries.length,
                      itemBuilder: (context, ii) {
                        return _buildRecentEntryRow(_recentEntries[ii]);
                      }
                    )
                  ),
                ]
              )
            );
          }
        },
      ),
    );
  }

  // One row in the list of recently added entries.
  Widget _buildRecentEntryRow(BulletEntry entry) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
            child: Text(_formatter.format(entry.entryDate)), 
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            width: 100.0,
          ),
          Expanded(
            child: Text(entry.rowName),
          ),
          Container(
            child: Text(entry.value), 
            padding: EdgeInsets.symmetric(horizontal: 8.0)
          ),
        ],
      ),
    );
  }

  void _pushNewEntry() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewBulletEntry()));
  }
}