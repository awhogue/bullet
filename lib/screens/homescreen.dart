import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/model.dart';
import '../datastore.dart';
import 'new_entry.dart';
import 'entry_detail.dart';

class BulletHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BulletHomeState();
}

class BulletHomeState extends State<BulletHome> {
  BulletDatastore _datastore;

  // Recently added entries, sorted in reverse chronological order.
  List<BulletEntry> _recentEntries = List<BulletEntry>();
  
  final _formatter = new DateFormat.MMMMd();

  BulletHomeState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bullet Journal'),
      ),
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
                        onPressed: _pushNewEntryScreen,
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
    return GestureDetector(
      onTap: () { _pushEntryDetailScreen(entry); },
      child: Container(
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
      ),
    );
  }

  void _pushNewEntryScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewBulletEntry()));
  }

  void _pushEntryDetailScreen(BulletEntry entry) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BulletEntryDetail(entry)));
  }
}