import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:bullet/model/bullet_row.dart';
import 'package:bullet/model/bullet_entry.dart';
import 'package:bullet/screens/new_entry.dart';
import 'package:bullet/datastore.dart';

// Detail screen for one row for one day, showing individual entries for that row for the day.
class BulletDayRowDetail extends StatefulWidget {
  final BulletRow row;
  final DateTime day;
  BulletDayRowDetail(this.row, this.day);

  @override
  State<StatefulWidget> createState() => BulletDayRowDetailState();
}

class BulletDayRowDetailState extends State<BulletDayRowDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _dateFormatter = new DateFormat.yMMMd();
  final _timeFormatter = new DateFormat.jm();

  static const int modifyTImeIntervalMinutes = 10;

  BulletDatastore _datastore = new BulletDatastore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.row.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushNewEntryScreen,
        child: Icon(Icons.add),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 12.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                _dateFormatter.format(widget.day),
                style: Theme.of(context).textTheme.headline,
              )
            )
          ),
          DataTable(
            columns: <DataColumn>[
              DataColumn(
                label: const Text('Value'),
              ),
              DataColumn(
                label: SizedBox.shrink(),
              ),
              DataColumn(
                label: const Text('Time'),
              ),
              DataColumn(
                label: SizedBox.shrink(),
              ),
              DataColumn(
                label: SizedBox.shrink(),
              ),
            ],
            rows: widget.row.entriesForDay(widget.day).map((entry) => _buildEntryDataRow(entry)).toList(),
          ),
        ]
      ),
    );
  }

  DataRow _buildEntryDataRow(BulletEntry entry) {
    return DataRow(
      cells: <DataCell>[
        // Entry value.
        DataCell(
          Text(
            '${entry.value.toString()} ${widget.row.unitsForValueString(entry.value.toString())}',
            style: Theme.of(context).textTheme.body1,
          ),
        ), 
        // Decrement the time.
        DataCell(
          Icon(Icons.skip_previous),
          onTap: () { modifyTime(entry, -1 * modifyTImeIntervalMinutes); },
        ),
        // The time of the entry.
        DataCell(
          Text(
            _timeFormatter.format(entry.time), 
            style: Theme.of(context).textTheme.body1,
          ),
        ),
        // Increment the time.
        DataCell(
          Icon(Icons.skip_next),
          onTap: () { modifyTime(entry, modifyTImeIntervalMinutes); },
        ),
        // Delete the entry.
        DataCell(
          Icon(Icons.delete),
          onTap: () { deleteEntry(entry); },
        ),
      ],
    );
  }

  void _pushNewEntryScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewBulletEntry(widget.row)));
  }

  void deleteEntry(BulletEntry entry) {
    // TODO: Show an alert before deleting.
    setState(() { _datastore.deleteEntry(entry, widget.row); });
  }

  // TODO: what happens if this goes over the date boundary into another day?
  void modifyTime(BulletEntry entry, int minutes) {
    setState(() { _datastore.updateEntryTime(widget.row, entry, Duration(minutes: minutes)); });
  }
}
