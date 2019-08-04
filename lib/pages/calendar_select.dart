import 'package:appoint/utils/calendar.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:device_calendar/device_calendar.dart' as pubdev;

class CalendarSelectPage extends StatefulWidget {
  static final routeNamed = "/calendar_select_page";

  const CalendarSelectPage({Key key}) : super(key: key);

  @override
  _CalendarSelectPageState createState() => _CalendarSelectPageState();
}

class _CalendarSelectPageState extends State<CalendarSelectPage> {
  @override
  Widget build(BuildContext context) {
    final String calendarId = ModalRoute.of(context).settings.arguments;
    id = calendarId ?? "";

    return Scaffold(
      appBar: _buildNavBar(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Wähle einen deiner Kalender aus, mit dem Termine abgeglichen werden sollen",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  String id;

  Widget _buildBody() {
    return FutureBuilder(
        future: Calendar().retrieveCalendars(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            final List<pubdev.Calendar> writeAccessCalendars =
                snapshot.data.where((c) => !c.isReadOnly).toList();
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 1),
              itemCount: writeAccessCalendars.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(writeAccessCalendars[index].name),
                trailing: id == writeAccessCalendars[index].id
                    ? Icon(
                        CupertinoIcons.check_mark,
                        size: 42,
                        color: Theme.of(context).accentColor,
                      )
                    : null,
                onTap: () => setState(() {
                  id = writeAccessCalendars[index].id;
                  Navigator.pop(context, writeAccessCalendars[index]);
                }),
              ),
            );
          }

          return Center(
            child: Column(
              children: <Widget>[
                CupertinoActivityIndicator(),
                Text(
                  "Kalender werden geladen",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        });
  }

  NavBar _buildNavBar() {
    return NavBar(
      "Kalendar auswählen",
      height: 59,
      leadingWidget: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context)),
      secondHeader: "für Terminabgleich",

    );
  }
}
