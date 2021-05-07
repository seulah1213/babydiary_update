class Cube {
  int id;
  String title;
  int cubecount;
  DateTime startDate;
  DateTime endDate;

  Cube({this.title, this.cubecount, this.startDate, this.endDate});
  Cube.withId(
      {this.id, this.title, this.cubecount, this.startDate, this.endDate});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['cubecount'] = cubecount;
    map['startDate'] = startDate.toIso8601String();
    map['endDate'] = endDate.toIso8601String();

    return map;
  }

  factory Cube.fromMap(Map<String, dynamic> map) {
    return Cube.withId(
        id: map['id'],
        title: map['title'],
        cubecount: map['cubecount'],
        startDate: DateTime.parse(map['startDate']),
        endDate: DateTime.parse(map['endDate']));
  }
}
