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

  List<BulletEntry> _recentEntries;
  
  final _formatter = DateFormat(DateFormat.MONTH_DAY);
  
  BulletHomeState() {
    _datastore = BulletDatastore.init();

    _recentEntries = _datastore.entries();
    _recentEntries.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bullet Journal'),
      ),
      body: Column(
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

  Widget _buildRecentEntryRow(BulletEntry entry) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
            child: Text(_formatter.format(entry.dateTime)), 
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            width: 100.0,
          ),
          Expanded(
            child: Text(entry.row.name),
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