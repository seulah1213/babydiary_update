class Cube {
  int id;
  String title;
  DateTime date;
  String priority;
  int cubecount; // 0 - Incomplete, 1 - Complete

  Cube({this.title, this.date, this.priority, this.cubecount});
  Cube.withId({this.id, this.title, this.date, this.priority, this.cubecount});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['date'] = date.toIso8601String();
    map['priority'] = priority;
    map['cubecount'] = cubecount;
    return map;
  }

  factory Cube.fromMap(Map<String, dynamic> map) {
    return Cube.withId(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      priority: map['priority'],
      cubecount: map['cubecount'],
    );
  }
}
