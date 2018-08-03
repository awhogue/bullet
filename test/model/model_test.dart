import 'package:flutter_test/flutter_test.dart';

import 'package:bullet/model/bullet_entry.dart';
import 'package:bullet/model/bullet_row.dart';

void main() {
  var codingRow = BulletRow<NumberEntry>('Coding', true, 'hours', 'Hours spent coding');
  var codingEntry1 = NumberEntry(3, new DateTime(2018, 7, 1, 13, 29, 0), 'Worked on journal app');
  var codingEntry2 = NumberEntry(1, new DateTime(2018, 7, 1, 19, 15, 0), 'Worked on journal app');
  
  var energyRow = BulletRow<NumberEntry>('Energy', false, '', 'Energy on a scale of 1-10');
  var energyEntry1 = NumberEntry(5, new DateTime(2018, 7, 1, 7, 29, 0), '');
  var energyEntry2 = NumberEntry(8, new DateTime(2018, 7, 1, 19, 15, 0), '');

  test('BulletRow.valueForDay', () {
    expect(codingRow.valueForDay([codingEntry1, codingEntry2]), equals(4));
  });
}