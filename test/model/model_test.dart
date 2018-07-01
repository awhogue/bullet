import 'package:flutter_test/flutter_test.dart';

import 'package:bullet/model/model.dart';

void main() {
  test('JSON serialization / deserialization: single BulletEntry', () {
    var entry = BulletEntry('3', new DateTime(2018, 7, 1, 13, 29, 0), 'Hours spent coding', 'Worked on journal app');
    var json = entry.toJson();
    print(json);
    var deser = BulletEntry.fromJson(json);
    expect(entry.value, equals(deser.value));
    expect(entry.entryDate, equals(deser.entryDate));
    expect(entry.rowName, equals(deser.rowName));
    expect(entry.comment, equals(deser.comment));
  });
}
