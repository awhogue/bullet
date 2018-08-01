import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:bullet/model/bullet_day.dart';
import 'package:bullet/model/bullet_row.dart';

void main() {
  var entry1 = BulletEntry('3', new DateTime(2018, 7, 1, 13, 29, 0), 'Worked on journal app');
  var entry2 = BulletEntry('1', new DateTime(2018, 7, 1, 19, 15, 0), 'Worked on journal app');
  var row1 = BulletRow('Coding', 
                        BulletRowDataType.Number, 
                        BulletRowMultiEntryType.Accumulate, 
                        'hours', 
                        'Hours spent coding');
  var day1 = BulletDay(new DateTime(2018, 7, 1), row1, [entry1, entry2]);
  var row2 = BulletRow('Workout', 
                        BulletRowDataType.Checkmark, 
                        BulletRowMultiEntryType.Separate, 
                        '', 
                        'One workout session');

  test('JSON serialization / deserialization: single BulletEntry', () {    
    var ser = json.encode(entry1.toJson());
    print(ser);
    var deser = BulletEntry.fromJson(json.decode(ser));
    expect(entry1.value, equals(deser.value));
    expect(entry1.entryDate, equals(deser.entryDate));
    expect(entry1.comment, equals(deser.comment));
  });

  test('JSON serialization / deserialization: list of BulletEntry', () {
    var entries = [entry1, entry2];
    var ser = json.encode(entries);
    print(ser);
    var deser = BulletEntry.fromJsonList(json.decode(ser));
    print(deser);
    expect(deser.length, equals(2));
    expect(entry1.value, equals(deser[0].value));
    expect(entry1.entryDate, equals(deser[0].entryDate));
    expect(entry1.comment, equals(deser[0].comment));
    expect(entry2.value, equals(deser[1].value));
    expect(entry2.entryDate, equals(deser[1].entryDate));
    expect(entry2.comment, equals(deser[1].comment));
  });

  test('Empty JSON list of BulletEntry', () {
    var deser = BulletEntry.fromJsonList(json.decode('[]'));
    expect(deser.length, equals(0));
  });

  test('JSON serialization / deserialization: single BulletDay', () {
    var ser = json.encode(day1.toJson());
    print(ser);
    var deser = BulletDay.fromJson(json.decode(ser), [row1, row1]);
    expect(day1.entryDate, equals(deser.entryDate));
    expect(day1.row.name, equals(deser.row.name));
    expect(day1.entries.length, equals(2));
    expect(day1.entries[0].value, equals(deser.entries[0].value));
    expect(day1.entries[0].entryDate, equals(deser.entries[0].entryDate));
    expect(day1.entries[1].value, equals(deser.entries[1].value));
    expect(day1.entries[1].entryDate, equals(deser.entries[1].entryDate));
  });

  test('JSON serialization / deserialization: list of BulletEntry', () {
    var entries = [entry1, entry2];
    var ser = json.encode(entries);
    print(ser);
    var deser = BulletEntry.fromJsonList(json.decode(ser));
    print(deser);
    expect(deser.length, equals(2));
    expect(entry1.value, equals(deser[0].value));
    expect(entry1.entryDate, equals(deser[0].entryDate));
    expect(entry1.comment, equals(deser[0].comment));
    expect(entry2.value, equals(deser[1].value));
    expect(entry2.entryDate, equals(deser[1].entryDate));
    expect(entry2.comment, equals(deser[1].comment));
  });

  test('Empty JSON list of BulletEntry', () {
    var deser = BulletEntry.fromJsonList(json.decode('[]'));
    expect(deser.length, equals(0));
  });

  test('JSON serialization / deserialization: single BulletRow', () {
    var row = BulletRow('Coding', 
                        BulletRowDataType.Number, 
                        BulletRowMultiEntryType.Accumulate, 
                        'hours', 
                        'Hours spent coding');
    var ser = json.encode(row.toJson());
    print(ser);
    var deser = BulletRow.fromJson(json.decode(ser));
    expect(row.name, equals(deser.name));
    expect(row.dataType, equals(deser.dataType));
    expect(row.multiEntryType, equals(deser.multiEntryType));
    expect(row.units, equals(deser.units));
    expect(row.comment, equals(deser.comment));
  });  

  test('JSON serialization / deserialization: list of BulletRow', () {
    
    var entries = [row1, row2];
    var ser = json.encode(entries);
    print(ser);
    var deser = BulletRow.fromJsonList(json.decode(ser));
    print(deser);
    expect(deser.length, equals(2));
    expect(row1.name, equals(deser[0].name));
    expect(row1.dataType, equals(deser[0].dataType));
    expect(row1.multiEntryType, equals(deser[0].multiEntryType));
    expect(row1.units, equals(deser[0].units));
    expect(row1.comment, equals(deser[0].comment));
    expect(row2.name, equals(deser[1].name));
    expect(row2.dataType, equals(deser[1].dataType));
    expect(row2.multiEntryType, equals(deser[1].multiEntryType));
    expect(row2.units, equals(deser[1].units));
    expect(row2.comment, equals(deser[1].comment));
  });

  test('Empty JSON list of BulletRow', () {
    var deser = BulletRow.fromJsonList(json.decode('[]'));
    expect(deser.length, equals(0));
  });
}
