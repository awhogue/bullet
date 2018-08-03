import 'bullet_entry.dart';

// A BulletRow models the semantic data for a single row within a journal,
// e.g. 'Coffee' or 'Workout' or 'Sleep'.
class BulletRow<V> {
  // The name of the row, e.g. "Coffee" or "Sleep"
  final String name;

  // When a second value gets added to this row in the same day, do we 
  // keep two separate entities, or accumulate them?
  final bool accumulate;
  // When accumulating a value in this row, what is the start value? E.g. for 
  // a row with numbers, start with 0.
  // TODO: Can we default this somehow and still use primitive types like String and int?
  final V startValue;

  // What units is this row measured in, if any?
  final String units;

  // A comment for the row.
  final String comment;

  // List of entries for this row. 
  // TODO: This obviously won't scale to a larger journal, will need a real database
  // instead of just a list.
  List<BulletEntry<V>> entries;

  BulletRow([this.name, this.entries, this.accumulate, this.startValue, this.units = '', this.comment = '']);

  // Return a renderable value for a set of entries in one day of this row.
  String valueForDay(DateTime day) {
    return _valueForEntries(entries.where(((e) => e.onDay(day))));
  }
  String _valueForEntries(List<BulletEntry<V>> entries) {
    if (entries.isEmpty) return '';
    if (this.accumulate) {
      return entries.fold(startValue, (value, element) => value + element).toString();
    } else {
      return BulletEntry.lastValue(entries).value();
    }
  }

  @override
  String toString() {
    return this.name + ' (' + units + ')';
  }

  Map<String, dynamic> toJson() => 
    { 
      'name': name,
      'entries': entries,
      'accumulate': accumulate,
      'startValue': startValue,
      'units': units,
      'comment': comment,
    };

  BulletRow.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      entries = BulletEntry.fromJsonList(json['entries']),
      accumulate = json['accumulate'],
      startValue = json['startValue'],
      units = json['units'],
      comment = json['comment'];

  static List<BulletRow> fromJsonList(List<dynamic> json) {
    return json.map<BulletRow>((entry) => BulletRow.fromJson(entry)).toList();
  }
}
