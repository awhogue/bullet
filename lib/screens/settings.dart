import 'dart:async';
import 'package:flutter/material.dart';
import '../datastore.dart';

class BulletSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BulletSettingsState();
}

class BulletSettingsState extends State<BulletSettings> {
  BulletDatastore _datastore = new BulletDatastore();

  BulletSettingsState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bullet Journal Settings'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: RaisedButton(
                  onPressed: _promptClearDatastore,
                  child: Text('Clear Journal'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _promptClearDatastore() async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Clear Journal?'),
            content: SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  Text('Really clear journal?'),
                  Text('All data will be deleted!'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  _datastore.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
  }
}