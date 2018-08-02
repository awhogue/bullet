// A BulletRow models the semantic data for a single row within a journal,
// e.g. 'Coffee' or 'Workout' or 'Sleep'.

import 'bullet_entry.dart';

// The most generic type of BulletRow, containing free text.
class BulletRow<T extends BulletEntry> {
  // The name of the row, e.g. "Coffee" or "Sleep"
  final String name;

  // When a second value gets added to this row in the same day, do we 
  // keep two separate entities, or accumulate them?
  final bool accumulate;

  // What units is this row measured in, if any?
  final String units;

  // A comment for the row.
  final String comment;

  BulletRow([this.name, this.accumulate, this.units = '', this.comment = '']);

  // Return a renderable value for a set of entries in this row. It is assumed
  // (but not validated) that all entries in the given list are from the same day.
  String valueForDay(List<T> entries) {
    if (entries.isEmpty) return '';
    if (this.accumulate) {
      return entries.fold(entries[0].startValue(), (value, element) => element.accumulateValues(value)).toString();
    } else {
      return BulletEntry.lastValue(entries).value();
    }
  }

  @override
  String toString() {
    return this.name + ' (' + units + ', ' + (accumulate ? 'acc' : 'sep') + ')';
  }

  Map<String, dynamic> toJson() => 
    { 
      'name': name,
      'accumulate': accumulate,
      'units': units,
      'comment': comment,
    };

  BulletRow.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      accumulate = json['accumulate'],
      units = json['units'],
      comment = json['comment'];

  static List<BulletRow> fromJsonList(List<dynamic> json) {
    return json.map<BulletRow>((entry) => BulletRow.fromJson(entry)).toList();
  }
}
