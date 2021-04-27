class Food {
  int id;
  String name;
  DateTime fromDate;
  DateTime toDate;
  int background;
  String step;
  int eventCount;

  Food({
    this.name,
    this.fromDate,
    this.toDate,
    this.background,
    this.step,
    this.eventCount,
  });
  Food.withId({
    this.id,
    this.name,
    this.fromDate,
    this.toDate,
    this.background,
    this.step,
    this.eventCount,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['fromDate'] = fromDate.toIso8601String();
    map['toDate'] = toDate.toIso8601String();
    map['background'] = background;
    map['step'] = step;
    map['eventCount'] = eventCount;
    return map;
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food.withId(
      id: map['id'],
      name: map['name'],
      fromDate: DateTime.parse(map['fromDate']),
      toDate: DateTime.parse(map['toDate']),
      background: map['background'],
      step: map['step'],
      eventCount: map['eventCount'],
    );
  }
}
