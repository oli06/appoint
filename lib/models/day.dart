class Day<T> {
  List<T> events = [];
  DateTime date;

  Day({
    this.events,
    this.date,
  });

  @override
  int get hashCode => events.hashCode ^ date.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Day &&
          runtimeType == other.runtimeType &&
          events == other.events &&
          date == other.date;
}
