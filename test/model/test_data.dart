import 'package:bullet/model/bullet_entry.dart';
import 'package:bullet/model/bullet_row.dart';

class TestData {
  static BulletEntry codingEntry1 = 
    BulletEntry<int>(
      3,
      new DateTime(2018, 7, 1, 13, 29, 0),
      'Worked on journal app'
    );
  static BulletEntry codingEntry2 = 
    BulletEntry<int>(
      1,
      new DateTime(2018, 7, 1, 19, 15, 0),
      'Worked on journal app'
    );
  
  static BulletEntry workoutEntry1 = 
    BulletEntry<String>(
      'Weights',
      new DateTime(2018, 8, 2, 6, 45, 0),
      'Legs'
    );
  static BulletEntry workoutEntry2 = 
    BulletEntry<String>(
      'Cardio',
      new DateTime(2018, 8, 2, 6, 45, 0),
      '2 mile run'
    );
  
  static BulletEntry energyEntry1 =
    BulletEntry<int>(
      8,
      new DateTime(2018, 12, 12, 10, 10, 0),
    );
  static BulletEntry energyEntry2 =
    BulletEntry<int>(
      7,
      new DateTime(2018, 12, 12, 16, 23, 0),
    );

  static BulletRow codingRow = 
    BulletRow<int>(
      'Coding',  
      [codingEntry1, codingEntry2],
      MultiEntryHandling.Sum,
      RowType.Number,
      defaultValue: 1,
      units: 'hours',
      comment: 'Hours spent coding'
    );

  static BulletRow workoutRow = 
    BulletRow<String>(
      'Work out', 
      [workoutEntry1, workoutEntry2], 
      MultiEntryHandling.Separate,
      RowType.Text,
    );

  static BulletRow energyRow = 
    BulletRow<int>(
      'Energy', 
      [energyEntry1, energyEntry2], 
      MultiEntryHandling.Average,
      RowType.Number,
      minValue: 0,
      maxValue: 10,
    );
}