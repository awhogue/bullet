import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:sqflite/sqflite.dart';
import 'model/model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bullet Journal',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new BulletHome(),
    );
  }
}

class BulletHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new BulletHomeState();
}

class BulletHomeState extends State<BulletHome> {
  List<BulletRow> _rows;
  List<BulletEntry> _recentEntries;
  
  final _formatter = new DateFormat(DateFormat.MONTH_DAY);
  
  BulletHomeState() {
    _rows = BulletModelUtils.generateFakeRows();
    _recentEntries = _rows.map(
      (r) => r.entries
    ).expand((e) => e).toSet().toList();
    _recentEntries.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Bullet Journal'),
      ),
      body: new Column(
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
            child: Text(entry.rowName())
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
    
  }
}