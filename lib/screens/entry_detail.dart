import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../model/model.dart';

class BulletEntryDetail extends StatefulWidget {
  final BulletEntry entry;
  BulletEntryDetail(this.entry);

  @override
  State<StatefulWidget> createState() => BulletEntryDetailState();
}

class BulletEntryDetailState extends State<BulletEntryDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formatter = new DateFormat.MMMMd().add_jm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Entry Detail'),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            _buildKeyValueRow('Row:', widget.entry.rowName),
            _buildKeyValueRow('Date:', _formatter.format(widget.entry.entryDate)),
            _buildKeyValueRow('Value:', widget.entry.value),
          ],
        ),
      ),
    );
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
}