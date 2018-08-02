import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/bullet_day.dart';
import '../model/bullet_row.dart';
import '../datastore.dart';
import 'new_entry.dart';
import 'day_detail.dart';
import 'settings.dart';

class BulletHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BulletHomeState();
}

class BulletHomeState extends State<BulletHome> {
  BulletDatastore _datastore;

  // Recently added entries, sorted in reverse chronological order.
  List<BulletDay> _recentDays = List<BulletDay>();
  
  final _formatter = new DateFormat.MMMMd();

  BulletHomeState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bullet Journal'),
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: _pushSettingsScreen),
        ],
      ),
      body: FutureBuilder<BulletDatastore>(
        future: BulletDatastore.init(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            _datastore = snapshot.data;
            _recentDays = _datastore.recentDays();
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
                      itemCount: _recentDays.length,
                      itemBuilder: (context, ii) {
                        return _buildRecentDayRow(_recentDays[ii]);
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

  // One row in the list of recent day entries.
  Widget _buildRecentDayRow(BulletDay day) {
    return GestureDetector(
      onTap: () { _pushDayDetailScreen(day); },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            Container(
              child: Text(
                _formatter.format(day.time),
                style: Theme.of(context).textTheme.subhead,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              width: 100.0,
            ),
            Expanded(
              child: Text(
                day.row.name,
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
            Container(
              child: Text(
                BulletRow.valueForDay(day) + ' ' + day.row.units,
                style: Theme.of(context).textTheme.subhead,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
          ],
        ),
      ),
    );
  }

  void _pushNewEntryScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewBulletEntry()));
  }

  void _pushDayDetailScreen(BulletDay day) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BulletDayDetail(day)));
  }

  void _pushSettingsScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BulletSettings()));
  }
}