// Represents a single row in the journal, e.g. "Hours slept" or "Coffee consumed".

enum BulletType { string, integer }
class BulletRow {
  BulletRow(this.bulletType, this.name);
  BulletType bulletType;
  String name;
}