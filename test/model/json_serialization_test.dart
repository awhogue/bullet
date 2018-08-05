import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:bullet/model/bullet_entry.dart';
import 'package:bullet/model/bullet_row.dart';

void main() {
  var codingEntry1 = BulletEntry<int>(3, new DateTime(2018, 7, 1, 13, 29, 0), 'Worked on journal app');
  var codingEntry2 = BulletEntry<int>(1, new DateTime(2018, 7, 1, 19, 15, 0), 'Worked on journal app');
  var workoutEntry1 = BulletEntry<String>('X', new DateTime(2018, 8, 2, 6, 45, 0), '2 mile run');
  var codingRow = BulletRow<int>('Coding', [codingEntry1, codingEntry2], true, 0, 'hours', 'Hours spent coding');
  var workoutRow = BulletRow<String>('Work out', [workoutEntry1], true, '', '', '');

  test('JSON serialization / deserialization: single BulletEntry', () {
    var ser = json.encode(codingEntry1.toJson());
    print(ser);
    var deser = BulletEntry.fromJson(json.decode(ser));
    expect(codingEntry1.value, equals(deser.value));
    expect(codingEntry1.time, equals(deser.time));
    expect(codingEntry1.comment, equals(deser.comment));
  });

  test('JSON serialization / deserialization: list of BulletEntry', () {
    var entries = [codingEntry1, codingEntry2, workoutEntry1];
    var ser = json.encode(entries);
    print(ser);
    var deser = BulletEntry.fromJsonList(json.decode(ser));
    print(deser);
    expect(deser.length, equals(3));
    expect(codingEntry1.value, equals(deser[0].value));
    expect(codingEntry1.type(), equals(deser[0].type()));
    expect(codingEntry1.time, equals(deser[0].time));
    expect(codingEntry1.comment, equals(deser[0].comment));
    expect(codingEntry2.value, equals(deser[1].value));
    expect(codingEntry2.type(), equals(deser[1].type()));
    expect(codingEntry2.time, equals(deser[1].time));
    expect(codingEntry2.comment, equals(deser[1].comment));
    expect(workoutEntry1.value, equals(deser[2].value));
    expect(workoutEntry1.type(), equals(deser[2].type()));
    expect(workoutEntry1.time, equals(deser[2].time));
    expect(workoutEntry1.comment, equals(deser[2].comment));
  });

  test('Empty JSON list of BulletEntry', () {
    var deser = BulletEntry.fromJsonList(json.decode('[]'));
    expect(deser.length, equals(0));
  });

  test('JSON serialization / deserialization: single BulletRow', () {
    var ser = json.encode(codingRow.toJson());
    print(ser);
    var deser = BulletRow.fromJson(json.decode(ser));
    expect(codingRow.name, equals(deser.name));
    expect(codingRow.accumulate, equals(deser.accumulate));
    expect(codingRow.units, equals(deser.units));
    expect(codingRow.comment, equals(deser.comment));
  });  

  test('JSON serialization / deserialization: list of BulletRow', () {
    var entries = [codingRow, workoutRow];
    var ser = json.encode(entries);
    print(ser);
    var deser = BulletRow.fromJsonList(json.decode(ser));
    print(deser);
    expect(deser.length, equals(2));
    expect(codingRow.name, equals(deser[0].name));
    expect(codingRow.accumulate, equals(deser[0].accumulate));
    expect(codingRow.units, equals(deser[0].units));
    expect(codingRow.comment, equals(deser[0].comment));
    expect(workoutRow.name, equals(deser[1].name));
    expect(workoutRow.accumulate, equals(deser[1].accumulate));
    expect(workoutRow.units, equals(deser[1].units));
    expect(workoutRow.comment, equals(deser[1].comment));
  });

  test('Empty JSON list of BulletRow', () {
    var deser = BulletRow.fromJsonList(json.decode('[]'));
    expect(deser.length, equals(0));
  });
}
