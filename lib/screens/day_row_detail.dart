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
              children: widget.row.entriesForDay(widget.day).map((entry) => _buildEntryDataRow(entry)).toList(),
            ),
          ),
        ]
      ),
    );
  }

  TableRow _buildEntryDataRow(BulletEntry entry) {
    return TableRow(
      children: <Widget>[
        // Entry value.
        Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            '${entry.value.toString()} ${widget.row.unitsForValueString(entry.value.toString())}',
            style: Theme.of(context).textTheme.body1,
          ),
        ),
        // Decrement the time.
        IconButton(
          icon: Icon(Icons.chevron_left),
          color: Theme.of(context).buttonColor,
          onPressed: () { modifyTime(entry, -1 * modifyTImeIntervalMinutes); },
        ),
        // The time of the entry.
        Container(
          alignment: Alignment.centerRight,
          child: Text(
            _timeFormatter.format(entry.time), 
            style: Theme.of(context).textTheme.body1,
          ),
        ),
        // Increment the time.
        IconButton(
          icon: Icon(Icons.chevron_right),
          color: Theme.of(context).buttonColor,
          onPressed: () { modifyTime(entry, modifyTImeIntervalMinutes); },
        ),
        // Delete the entry.
        IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).buttonColor,
          onPressed: () { deleteEntry(entry); },
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
