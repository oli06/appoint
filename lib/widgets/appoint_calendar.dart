import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointCalendar extends StatefulWidget {
  const AppointCalendar({
    Key key,
    @required this.context,
    @required this.onDaySelected,
    @required this.visibleEvents,
    @required this.onVisibleDaysChanged,
  }) : super(key: key);

  final BuildContext context;
  final Function(DateTime day, List events) onDaySelected;
  final Function(DateTime first, DateTime last, CalendarFormat format)
      onVisibleDaysChanged;
  final Map<DateTime, List> visibleEvents;

  @override
  _AppointCalendarState createState() => _AppointCalendarState();
}

class _AppointCalendarState extends State<AppointCalendar> {

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      enableDay: (date) {
        return date.weekday != DateTime.sunday;
      },
      endDay: DateTime(2099, 12, 31),
      initialCalendarFormat: CalendarFormat.month,
      startDay: DateTime.now().subtract(Duration(days: 1)),
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        CalendarFormat.month: "1 Monat",
      },
      calendarStyle: CalendarStyle(
        selectedColor: Theme.of(context).accentColor,
        todayColor: Theme.of(context).primaryColor,
        weekdayStyle: const TextStyle(fontSize: 18),
        weekendStyle: const TextStyle(fontSize: 18, color: Colors.red),
        outsideStyle: const TextStyle(fontSize: 18, color: Colors.grey),
        outsideWeekendStyle: TextStyle(fontSize: 18, color: Colors.red[200]),
      ),
      onDaySelected: widget.onDaySelected,
      onVisibleDaysChanged: widget.onVisibleDaysChanged,
      events: widget.visibleEvents,
      onUnavailableDaySelected: () {
        return;
      },
      builders: CalendarBuilders(selectedDayBuilder: (context, day, _) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).accentColor),
          child: Center(
            child: Text(
              day.day.toString(),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      }, todayDayBuilder: (context, day, _) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor),
            child: Center(
              child: Text(
                day.day.toString(),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
      }, markersBuilder: (context, day, events, holiday) {
        final children = <Widget>[];

        if (events.isEmpty) {
          return children;
        }

        children.add(Positioned(
          right: 2,
          bottom: 2,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
                //border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(3),
                color: Colors.white),
            width: 16,
            height: 16,
            child: Center(
                child: Text(
              "${events.length}",
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w500),
            )),
          ),
        ));

        return children;
      }),
    );
  }
}
