import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:sqflite/sqflite.dart';
import 'model/model.dart';

void main() => runApp(new MyApp());

final _biggerFont = const TextStyle(fontSize: 18.0);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bullet Journal',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new BulletTable(),
    );
  }
}

class BulletTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new BulletTableState();
}

class BulletTableState extends State<BulletTable> {
  List<BulletRow> _rows;
  // Unique set of dates we know about (for the column headers).
  List<DateTime> _dates;
  
  final _formatter = new DateFormat(DateFormat.MONTH_DAY);

  BulletTableState() {
    _rows = BulletRow.generateFakeRows();
    _dates = _rows.map(
      (r) => r.entries.map(
        (e) => e.dateTime
      )
    ).expand((d) => d).toSet().toList();
    _dates.sort();
    print('dates.length: ' + _dates.length.toString());
  }

  Widget _buildTable() {
    return new DataTable(
      columns: _buildHeaderColumns(),
      rows: _rows.map((r) => _buildRow(r)).toList(),
    );
  }

  List<DataColumn> _buildHeaderColumns() {
    return 
      [new DataColumn(label: new Text(''))]
        ..addAll(_dates.map((d) => new DataColumn(
          label: new RotatedBox(
            quarterTurns: 3,
            child: new Text(_formatter.format(d), style: _biggerFont),
          )
        )
      ).toList());
  }

  DataRow _buildRow(BulletRow row) {
    return new DataRow(
      cells: [new DataCell(new Text(row.name, style: _biggerFont))]
        ..addAll(row.entries.map((e) => 
          new DataCell(new Text(e.value, style: _biggerFont))).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Bullet Journal'),
      ),
      body: _buildTable(),
    );
  }
}