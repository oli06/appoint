import 'package:appoint/pages/chat.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotificationsPage extends StatelessWidget {
  static final routeNamed = "notifications";
  const NotificationsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildNavBar(context),
      body: SafeArea(
        child: _buildList(),
      ),
    );
  }

  final data = const [
    {
      "Name": "Steuerberater",
      "Text":
          "Sehr geehrter Herr X, \nBitte senden Sie uns noch die Unterlagen vom vergangenen Freitag zu"
    },
    {"Name": "Anwalt X", "Text": "Vielen Dank für Ihre Anfrage"},
    {
      "Name": "Zahnarzt Müller",
      "Text": "Ihre Zahnvorsorge steht bevor. Bitte bestätigen Sie den Termin"
    }
  ];

  Widget _buildList() {
    return ListView.separated(
      itemCount: 3,
      itemBuilder: (context, index) => ListTile(
        title: Text(
          data[index]["Name"],
          style: TextStyle(fontSize: 18),
        ),
        isThreeLine: false,
        subtitle: Text(
          data[index]['Text'],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => Navigator.pushNamed(context, ChatPage.namedRoute),
        trailing: IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () => Navigator.pushNamed(context, ChatPage.namedRoute),
        ),
      ),
      separatorBuilder: (context, index) => Divider(
        height: 1,
      ),
    );
  }

  NavBar _buildNavBar(BuildContext context) {
    return NavBar(
      "Benachrichtigungen",
      height: 57,
      leadingWidget: IconButton(
          icon: Icon(
            Icons.close,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      trailing: Container(
        height: 0,
        width: 0,
      ),
    );
  }
}

/*
class _ViewModel {

  _ViewModel({
  });

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      
    );
  }
}*/
