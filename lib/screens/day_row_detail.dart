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
  final _timeFormatter = new DateFormat.jm();
  final _dateFormatter = new DateFormat.yMMMd();

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
      body: Container(
        child: Column(
          children: [
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
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              shrinkWrap: true,
              children: widget.row.entriesForDay(widget.day).map((entry) => _buildEntryRow(entry)).toList() + [Divider()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryRow(BulletEntry entry) {
    return Column(
      children: [
        Divider(),
        Row(
          children: [
            // The value for this entry.
            Expanded(
              child: Text(
                '${entry.value.toString()} ${widget.row.unitsForValueString(entry.value.toString())}',
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            // The time of the entry.
            Text(
              _timeFormatter.format(entry.time), 
              style: Theme.of(context).textTheme.body1,
            ),
            // Delete the entry.
            Container(
              child: IconButton(
                onPressed: () { _deleteEntry(entry); },
                icon: new Icon(Icons.delete),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _pushNewEntryScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewBulletEntry(widget.row)));
  }

  void _deleteEntry(entry) {
    // TODO: Show an alert before deleting.
    setState(() { _datastore.deleteEntry(entry, widget.row); });
  }
}