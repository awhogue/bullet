import 'package:flutter_test/flutter_test.dart';

import 'package:bullet/model/bullet_entry.dart';
import 'package:bullet/model/bullet_row.dart';

void main() {
  var codingEntry1 = BulletEntry<int>(3, new DateTime(2018, 7, 1, 13, 29, 0), 'Worked on journal app');
  var codingEntry2 = BulletEntry<int>(1, new DateTime(2018, 7, 1, 19, 15, 0), 'Worked on journal app');
  var workoutEntry1 = BulletEntry<String>('X', new DateTime(2018, 8, 2, 6, 45, 0), '2 mile run');
  var codingRow = BulletRow<int>('Coding', [codingEntry1, codingEntry2], true, 0, 'hours', 'Hours spent coding');
  var workoutRow = BulletRow<String>('Work out', [workoutEntry1], true, '', '', '');

  test('BulletRow.valueForDay', () {
    expect(codingRow.valueForDay(new DateTime(2018, 7, 1)), equals('4'));
    expect(workoutRow.valueForDay(new DateTime(2018, 8, 2)), equals('X'));
  });
}