// Utilities for the Bullet app.
class BulletUtil {
  // Return the number of days before today's date for the given date.
  static int daysBeforeToday(DateTime date, { DateTime today } ) {
    DateTime now = DateTime.now();
    if (null == today) {
      today = DateTime(now.year, now.month, now.day);
    } else {
      // Be sure to clear the time parameters before comparing.
      today = DateTime(today.year, today.month, today.day);
    }
    // Also zero out the incoming date so we get an accurate difference.
    date = DateTime(date.year, date.month, date.day);
    return today.difference(date).inDays;
  }

  // Return true if the two dates are on the same day (ignoring hours, minutes, etc).
  static bool sameDay(DateTime a, DateTime b) {
    return (
      a.year == b.year &&
      a.month == b.month &&
      a.day == b.day
    );
  }
}