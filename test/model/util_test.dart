import 'package:flutter_test/flutter_test.dart';
import 'package:bullet/util.dart';

void main() {
  test('BulletUtil.daysBeforeToday', () {
    // Inject a stable date into the function.
    DateTime today = DateTime(2018, 8, 13, 16, 37, 18);

    // Same day.
    expect(BulletUtil.daysBeforeToday(
      today, 
      today: today), 
      equals(0)
    );
    // Same day, zeroed out times.
    expect(BulletUtil.daysBeforeToday(
      DateTime(2018, 8, 13, 0, 0, 0), 
      today: today), 
      equals(0)
    );
    // Day before, but later hour.
    expect(BulletUtil.daysBeforeToday(
      DateTime(2018, 8, 12, 20, 0, 0), 
      today: today), 
      equals(1)
    );
    // Day before, but earlier hour.
    expect(BulletUtil.daysBeforeToday(
      DateTime(2018, 8, 12, 10, 0, 0), 
      today: today), 
      equals(1)
    );
    // Day after.
    expect(BulletUtil.daysBeforeToday(
      DateTime(2018, 8, 14, 10, 0, 0), 
      today: today), 
      equals(-1)
    );
  });
}