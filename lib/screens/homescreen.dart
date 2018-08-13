import 'package:flutter/material.dart';
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
  List<RowString> _currentDayRows = List<RowString>();
  // Currently set to today, but eventually will be UI-controlled
  DateTime _currentDay = DateTime.now();

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
            _currentDayRows = _datastore.rowValuesForDay(_currentDay);
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
                      itemCount: _currentDayRows.length,
                      itemBuilder: (context, ii) {
                        return _buildCurrentDayRow(_currentDayRows[ii]);
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

  // One row in the list of rows from the current day.
  Widget _buildCurrentDayRow(RowString row) {
    return GestureDetector(
      onTap: () { _pushDayDetailScreen(row); },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                row.row.name,
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
            Container(
              child: Text(
                row.row.valueForDay(_currentDay) + ' ' + row.row.units,
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

  void _pushDayDetailScreen(RowString row) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BulletDayDetail(row.row, _currentDay)));
  }

  void _pushSettingsScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BulletSettings()));
  }
}