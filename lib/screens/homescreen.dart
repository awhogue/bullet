import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bullet/model/bullet_row.dart';
import 'package:bullet/datastore.dart';
import 'package:bullet/util.dart';
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
  List<RowWithValue> _currentDayRowValues = List<RowWithValue>();
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
            _currentDayRowValues = _datastore.rowValuesForDay(_currentDay);
            print('Rendering Bullet Homescreen with ' + _currentDayRowValues.length.toString() + ' rows');
            
            return Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            _dateFormatter.format(_currentDay),
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            _daysAgoText(),
                            style: Theme.of(context).textTheme.subhead,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shrinkWrap: true,
                    children: _currentDayRowValues.map((rv) => _buildDayRow(rv)).toList() + [Divider()],
                  ),
                  Divider(),
                ],
              )
            );
          }
        },
      ),
    );
  }

  Widget _buildDayRow(RowWithValue row) {
    // Render the value of the row only if it exists for this day.
    Widget valueWidget = 
      (row.value.isEmpty) ?
      Text('') :
      Text(
        '${row.value} ${row.row.unitsForValue(row.value)}',
        style: Theme.of(context).textTheme.body1,
      );

    // Render an add/edit button. 
    // If the row has a value, the button edits the existing value.
    // If the row does not yet have a value, the button adds an entry.
    // TODO: if the row has an int value, this button should increment the value without needing to visit the edit screen.
    Widget addEditButton =
      (row.value.isEmpty) ?
        IconButton(
          onPressed: () { _pushNewEntryScreen(row); },
          icon: new Icon(Icons.add),
        ) :
        IconButton(
          onPressed: () { _pushDayDetailScreen(row); },
          icon: new Icon(Icons.edit),
        );

    return 
      Column(
        children: [
          Divider(),
          GestureDetector(
            onTap: () { (row.value.isEmpty) ? _pushNewEntryScreen(row) : _pushDayDetailScreen(row); },
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.row.name,
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                  Container(
                    child: valueWidget,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  Container(
                    child: addEditButton,
                  ),
                ],
              ),
            ),
          ),
        ],
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

  void _pushNewEntryScreen([RowWithValue row]) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewBulletEntry(row.row)));
  }

  void _pushDayDetailScreen(RowWithValue row) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BulletDayDetail(row.row, _currentDay)));
  }

  void _pushSettingsScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BulletSettings()));
  }
}