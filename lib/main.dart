import 'package:flutter/material.dart';
import 'screens/homescreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bullet Journal',
      theme: new ThemeData(
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent,
        disabledColor: Colors.blueGrey[200],
        iconTheme: Theme.of(context).iconTheme.copyWith(
          color: Colors.blueGrey[600],
        ),
        textTheme: Theme.of(context).textTheme.copyWith(
          subhead: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[900],
          ),
          body1: TextStyle(
            fontSize: 18.0
          ),
        ),
      ),
      home: new BulletHome(),
    );
  }
}

