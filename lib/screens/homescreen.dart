import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/bullet_row.dart';
import '../datastore.dart';
import '../util.dart';
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
  DateTime _currentDay;

  final _dateFormatter = new DateFormat.yMMMMEEEEd();

  BulletHomeState() {
    // TODO: rewind to the most recent day with data?
    _currentDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bullet Journal'),
        actions: [
          IconButton(icon: Icon(Icons.settings), onPressed: _pushSettingsScreen),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushNewEntryScreen,
        child: Icon(Icons.add),
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
            print('Rendering Bullet Homescreen with ' + _currentDayRows.length.toString() + ' rows');
            
            return Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 10.0),
                    child: Column(
                      children: [
                        Text(
                          _dateFormatter.format(_currentDay),
                          style: Theme.of(context).textTheme.headline,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                          child: Text(
                            _daysAgoText(),
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: _currentDayRows.length,
                    shrinkWrap: true,
                    itemBuilder: (context, ii) {
                      return _buildDayRow(_currentDayRows[ii]);
                    }
                  ),
                ],
              )
            );
          }
        },
      ),
    );
  }

  Widget _buildDayRow(RowString row) {
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

  String _daysAgoText() {
    int daysAgo = BulletUtil.daysBeforeToday(_currentDay);
    if (daysAgo == 0) { 
      return 'Today'; 
    } else {
      return [
        daysAgo.toString(), 
        (daysAgo.abs() > 1) ? 'days' : 'day',
        (daysAgo > 0) ? 'ago' : 'from now',
      ].join(' ');
    }
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