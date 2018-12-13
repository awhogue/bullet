import 'package:test/test.dart';
import 'test_data.dart';

void main() {
  test('BulletRow.valueForDay', () {
    expect(TestData.codingRow.valueForDay(new DateTime(2018, 7, 1)), equals('4'));
    expect(TestData.workoutRow.valueForDay(new DateTime(2018, 8, 2)), equals('Weights, Cardio'));
    expect(TestData.energyRow.valueForDay(new DateTime(2018, 12, 12)), equals('7.5'));
  });
}