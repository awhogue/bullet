import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:bullet/model/model.dart';

void main() {
  test('JSON serialization / deserialization: single BulletEntry', () {
    var entry = BulletEntry('3', new DateTime(2018, 7, 1, 13, 29, 0), 'Hours spent coding', 'Worked on journal app');
    var ser = json.encode(entry.toJson());
    print(ser);
    var deser = BulletEntry.fromJson(json.decode(ser));
    expect(entry.value, equals(deser.value));
    expect(entry.entryDate, equals(deser.entryDate));
    expect(entry.rowName, equals(deser.rowName));
    expect(entry.comment, equals(deser.comment));
  });

  test('JSON serialization / deserialization: list of BulletEntry', () {
    var entry1 = BulletEntry('3', new DateTime(2018, 7, 1, 13, 29, 0), 'Hours spent coding', 'Worked on journal app');
    var entry2 = BulletEntry('4', new DateTime(2018, 7, 14, 22, 03, 0), 'Hours spent coding', 'Worked on journal app');
    var entries = [entry1, entry2];
    var ser = json.encode(entries);
    print(ser);
    var deser = BulletEntry.fromJsonList(json.decode(ser));
    print(deser);
    expect(deser.length, equals(2));
    expect(entry1.value, equals(deser[0].value));
    expect(entry1.entryDate, equals(deser[0].entryDate));
    expect(entry1.rowName, equals(deser[0].rowName));
    expect(entry1.comment, equals(deser[0].comment));
    expect(entry2.value, equals(deser[1].value));
    expect(entry2.entryDate, equals(deser[1].entryDate));
    expect(entry2.rowName, equals(deser[1].rowName));
    expect(entry2.comment, equals(deser[1].comment));
  });

  test('Empty JSON List', () {
    var deser = BulletEntry.fromJsonList(json.decode('[]'));
    expect(deser.length, equals(0));
  });
}
