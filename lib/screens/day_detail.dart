import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../model/bullet_row.dart';
import '../model/bullet_entry.dart';

class BulletDayDetail extends StatefulWidget {
  final BulletRow row;
  final DateTime day;
  BulletDayDetail(this.row, this.day);

  @override
  State<StatefulWidget> createState() => BulletDayDetailState();
}

class BulletDayDetailState extends State<BulletDayDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _timeFormatter = new DateFormat.jm();
  final _dateFormatter = new DateFormat.yMMMd();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${widget.row.name} (${widget.row.units})',),
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
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              shrinkWrap: true,
              children: widget.row.entries.map((entry) => _buildEntryRow(entry)).toList() + [Divider()],
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
            Expanded(
              child: Text(
                entry.value.toString(),
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            Text(
              _timeFormatter.format(entry.time), 
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ],
    );
  }
}