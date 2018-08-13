import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:bullet/model/bullet_entry.dart';
import 'package:bullet/model/bullet_row.dart';

import 'test_data.dart';

void main() {
  test('JSON serialization / deserialization: single BulletEntry', () {
    var ser = json.encode(TestData.codingEntry1.toJson());
    print(ser);
    var deser = BulletEntry.fromJson(json.decode(ser));
    expect(TestData.codingEntry1.value, equals(deser.value));
    expect(TestData.codingEntry1.time, equals(deser.time));
    expect(TestData.codingEntry1.comment, equals(deser.comment));
  });

  test('JSON serialization / deserialization: list of BulletEntry', () {
    var entries = [TestData.codingEntry1, TestData.codingEntry2, TestData.workoutEntry1];
    var ser = json.encode(entries);
    print(ser);
    var deser = BulletEntry.fromJsonList(json.decode(ser));
    print(deser);
    expect(deser.length, equals(3));
    expect(TestData.codingEntry1.value, equals(deser[0].value));
    expect(TestData.codingEntry1.type(), equals(deser[0].type()));
    expect(TestData.codingEntry1.time, equals(deser[0].time));
    expect(TestData.codingEntry1.comment, equals(deser[0].comment));
    expect(TestData.codingEntry2.value, equals(deser[1].value));
    expect(TestData.codingEntry2.type(), equals(deser[1].type()));
    expect(TestData.codingEntry2.time, equals(deser[1].time));
    expect(TestData.codingEntry2.comment, equals(deser[1].comment));
    expect(TestData.workoutEntry1.value, equals(deser[2].value));
    expect(TestData.workoutEntry1.type(), equals(deser[2].type()));
    expect(TestData.workoutEntry1.time, equals(deser[2].time));
    expect(TestData.workoutEntry1.comment, equals(deser[2].comment));
  });

  test('Empty JSON list of BulletEntry', () {
    var deser = BulletEntry.fromJsonList(json.decode('[]'));
    expect(deser.length, equals(0));
  });

  test('JSON serialization / deserialization: single BulletRow', () {
    var ser = json.encode(TestData.codingRow.toJson());
    print(ser);
    var deser = BulletRow.fromJson(json.decode(ser));
    expect(TestData.codingRow.name, equals(deser.name));
    expect(TestData.codingRow.accumulate, equals(deser.accumulate));
    expect(TestData.codingRow.units, equals(deser.units));
    expect(TestData.codingRow.comment, equals(deser.comment));
  });  

  test('JSON serialization / deserialization: list of BulletRow', () {
    var entries = [TestData.codingRow, TestData.workoutRow];
    var ser = json.encode(entries);
    print(ser);
    var deser = BulletRow.fromJsonList(json.decode(ser));
    print(deser);
    expect(deser.length, equals(2));
    expect(TestData.codingRow.name, equals(deser[0].name));
    expect(TestData.codingRow.accumulate, equals(deser[0].accumulate));
    expect(TestData.codingRow.units, equals(deser[0].units));
    expect(TestData.codingRow.comment, equals(deser[0].comment));
    expect(TestData.workoutRow.name, equals(deser[1].name));
    expect(TestData.workoutRow.accumulate, equals(deser[1].accumulate));
    expect(TestData.workoutRow.units, equals(deser[1].units));
    expect(TestData.workoutRow.comment, equals(deser[1].comment));
  });

  test('Empty JSON list of BulletRow', () {
    var deser = BulletRow.fromJsonList(json.decode('[]'));
    expect(deser.length, equals(0));
  });
}
