import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bullet/model/bullet_row.dart';
import 'package:bullet/datastore.dart';
import 'package:bullet/util.dart';
import 'new_entry.dart';
import 'day_row_detail.dart';
import 'settings.dart';

class BulletHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BulletHomeState();
}

class BulletHomeState extends State<BulletHome> {
  BulletDatastore _datastore;

  // The rows in the journal that will be displayed on the homescreen.
  List<RowWithValue> _currentDayRowValues = List<RowWithValue>();

  // The day being displayed.
  DateTime _currentDay;

  final _dateFormatter = new DateFormat.yMMMMEEEEd();

  BulletHomeState() {
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
            _currentDayRowValues = _datastore.rowValuesForDay(_currentDay, true);
            print('Rendering Bullet Homescreen with ${_currentDayRowValues.length.toString()} rows');
            
            return ListView(
              children: <Widget>[
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
                (_currentDayRowValues.isEmpty) ?
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 100.0),
                    child: Text(
                      'No rows yet! Tap "+" to add one.',
                      style: Theme.of(context).textTheme.subhead,
                    )
                  ) :
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    child: Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      defaultColumnWidth: IntrinsicColumnWidth(),
                      columnWidths: const {
                        0: FlexColumnWidth(),
                      },
                      border: TableBorder(
                        top: BorderSide(color: Theme.of(context).dividerColor),
                        bottom: BorderSide(color: Theme.of(context).dividerColor),
                        horizontalInside: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                      children: _currentDayRowValues.map((rv) => _buildDataRow(rv)).toList(),
                    ),
                  ),
                  /* ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shrinkWrap: true,
                    children: _currentDayRowValues.map((rv) => _buildDayRow(rv)).toList() + [Divider()],
                  ), */
              ],
            );
          }
        },
      ),
    );
  }

  TableRow _buildDataRow(RowWithValue row) {
    // Render the value of the row only if it exists for this day.
    String valueString = 
      (row.value.isEmpty) ?
      '' : '${row.value} ${row.row.unitsForValueString(row.value)}';

    return TableRow(
      children: <Widget>[      
          GestureDetector(
            onTap: () { (row.value.isEmpty) ? _pushNewEntryScreen(row) : _pushDayDetailScreen(row); },
            child: Container(
              child: Text(
                row.row.name,
                style: Theme.of(context).textTheme.body1,
              ),
            ),
          ),
          // Value for today.
          Container(
            child: Text(
              valueString,
              style: Theme.of(context).textTheme.body1,
            );,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
          // Quick-add one to the row.
          // TODO: only show this for numeric rows (or show a popup text entry for non-numeric).
          Container(
            child: IconButton(
              onPressed: () { _quickAddToRow(row); },
              icon: Icon(Icons.plus_one),
            ),
          ),
          // Add an entry to the row.
          Container(
            child: IconButton(
              onPressed: () { _pushNewEntryScreen(row); },
              icon: Icon(Icons.add),
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
    if (null != row) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => NewBulletEntry(row.row)));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => NewBulletEntry()));
    }
  }

  // Inline add one to the given row.
  void _quickAddToRow(RowWithValue row) {
    setState(() { _datastore.addEntryToRow(row.row, row.row.newDefaultEntry()); });
  }

  void _pushDayDetailScreen(RowWithValue row) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BulletDayRowDetail(row.row, _currentDay)));
  }

  void _pushSettingsScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BulletSettings()));
  }
}