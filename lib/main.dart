import 'package:flutter/material.dart';
import 'screens/homescreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bullet Journal',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new BulletHome(),
    );
  }
}

