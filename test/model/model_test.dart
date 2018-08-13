import 'package:flutter_test/flutter_test.dart';
import 'test_data.dart';

void main() {
  test('BulletRow.startValue', () {
    expect(TestData.codingRow.startValue(), equals(0));
    expect(TestData.workoutRow.startValue(), equals(''));
  });

  test('BulletRow.valueForDay', () {
    expect(TestData.codingRow.valueForDay(new DateTime(2018, 7, 1)), equals('4'));
    expect(TestData.workoutRow.valueForDay(new DateTime(2018, 8, 2)), equals('X'));
  });
}