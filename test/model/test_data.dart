import 'package:bullet/model/bullet_entry.dart';
import 'package:bullet/model/bullet_row.dart';

class TestData {
  static BulletEntry codingEntry1 = BulletEntry<int>(3, new DateTime(2018, 7, 1, 13, 29, 0), 'Worked on journal app');
  static BulletEntry codingEntry2 = BulletEntry<int>(1, new DateTime(2018, 7, 1, 19, 15, 0), 'Worked on journal app');
  static BulletEntry workoutEntry1 = BulletEntry<String>('X', new DateTime(2018, 8, 2, 6, 45, 0), '2 mile run');
  static BulletRow codingRow = BulletRow<int>('Coding', [codingEntry1, codingEntry2], true, RowType.Number, 'hours', 'Hours spent coding');
  static BulletRow workoutRow = BulletRow<String>('Work out', [workoutEntry1], true, RowType.Text, '', '');
}