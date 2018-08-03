import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:bullet/model/bullet_entry.dart';
import 'package:bullet/model/bullet_row.dart';

void main() {
  var entry1 = BulletEntry<int>(3, new DateTime(2018, 7, 1, 13, 29, 0), 'Worked on journal app');
  var entry2 = BulletEntry<int>(1, new DateTime(2018, 7, 1, 19, 15, 0), 'Worked on journal app');
  var entry3 = BulletEntry<String>('X', new DateTime(2018, 8, 2, 6, 45, 0), '2 mile run');
  var row1 = BulletRow<int>('Coding', [entry1, entry2], true, 0, 'hours', 'Hours spent coding');
  var row2 = BulletRow<String>('Work out', [entry3], true, '', '', '');

  test('JSON serialization / deserialization: single BulletEntry', () {
    var ser = json.encode(entry1.toJson());
    print(ser);
    var deser = BulletEntry.fromJson(json.decode(ser));
    expect(entry1.value, equals(deser.value));
    expect(entry1.time, equals(deser.time));
    expect(entry1.comment, equals(deser.comment));
  });

  test('JSON serialization / deserialization: list of BulletEntry', () {
    var entries = [entry1, entry2, entry3];
    var ser = json.encode(entries);
    print(ser);
    var deser = BulletEntry.fromJsonList(json.decode(ser));
    print(deser);
    expect(deser.length, equals(3));
    expect(entry1.value, equals(deser[0].value));
    expect(entry1.type(), equals(deser[0].type()));
    expect(entry1.time, equals(deser[0].time));
    expect(entry1.comment, equals(deser[0].comment));
    expect(entry2.value, equals(deser[1].value));
    expect(entry2.type(), equals(deser[1].type()));
    expect(entry2.time, equals(deser[1].time));
    expect(entry2.comment, equals(deser[1].comment));
    expect(entry3.value, equals(deser[2].value));
    expect(entry3.type(), equals(deser[2].type()));
    expect(entry3.time, equals(deser[2].time));
    expect(entry3.comment, equals(deser[2].comment));
  });

  test('Empty JSON list of BulletEntry', () {
    var deser = BulletEntry.fromJsonList(json.decode('[]'));
    expect(deser.length, equals(0));
  });

  test('JSON serialization / deserialization: single BulletRow', () {
    var ser = json.encode(row1.toJson());
    print(ser);
    var deser = BulletRow.fromJson(json.decode(ser));
    expect(row1.name, equals(deser.name));
    expect(row1.accumulate, equals(deser.accumulate));
    expect(row1.units, equals(deser.units));
    expect(row1.comment, equals(deser.comment));
  });  

  test('JSON serialization / deserialization: list of BulletRow', () {
    var entries = [row1, row2];
    var ser = json.encode(entries);
    print(ser);
    var deser = BulletRow.fromJsonList(json.decode(ser));
    print(deser);
    expect(deser.length, equals(2));
    expect(row1.name, equals(deser[0].name));
    expect(row1.accumulate, equals(deser[0].accumulate));
    expect(row1.units, equals(deser[0].units));
    expect(row1.comment, equals(deser[0].comment));
    expect(row2.name, equals(deser[1].name));
    expect(row2.accumulate, equals(deser[1].accumulate));
    expect(row2.units, equals(deser[1].units));
    expect(row2.comment, equals(deser[1].comment));
  });

  test('Empty JSON list of BulletRow', () {
    var deser = BulletRow.fromJsonList(json.decode('[]'));
    expect(deser.length, equals(0));
  });
}
