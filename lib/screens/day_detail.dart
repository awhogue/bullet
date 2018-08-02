import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../model/bullet_day.dart';

class BulletDayDetail extends StatefulWidget {
  final BulletDay day;
  BulletDayDetail(this.day);

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
        title: Text('Day Entry Detail'),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: _buildRows(),
        ),
      ),
    );
  }

  List<Widget> _buildRows() {
    List<Widget> rows = [
      _buildKeyValueRow('Row:', widget.day.row.name),
      _buildKeyValueRow('Date:', _dateFormatter.format(widget.day.time)),
    ];
    rows.addAll(widget.day.entries.map((entry) => _buildEntryRow(entry)));
    return rows;
  }

  Widget _buildKeyValueRow(String key, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 100.0,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(key, style: Theme.of(context).textTheme.title),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.title),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryRow(BulletEntry entry) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 8.0, 8.0, 8.0),
      child: Row(
        children: [
          Container(
            width: 100.0,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              _timeFormatter.format(entry.time), 
              style: Theme.of(context).textTheme.body2
            ),
          ),
          Expanded(
            child: Text(entry.value, style: Theme.of(context).textTheme.body2),
          ),
        ],
      ),
    );
  }
}