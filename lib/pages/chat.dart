import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/widgets/icon_circle_gradient.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatPage extends StatefulWidget {
  static final namedRoute = "chat";
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    //final Company company = ModalRoute.of(context).settings.arguments;
    final Company company = Company(name: "Steuerberater 1");
    final List<MessageObject> messages = [
      MessageObject(
          isYours: false,
          type: MessageType.message,
          value: "Hallo Herr Maier, wir danken Ihnen für Ihre Terminanfrage."),
      MessageObject(
          isYours: false,
          type: MessageType.message,
          value:
              "Bitte teilen Sie uns ein paar Informationen über Sie mit: Sind sie Angestellter oder Selbständig?"),
      MessageObject(
          isYours: true,
          type: MessageType.message,
          value:
              "Hallo Firma XYZ,\nich bin Angestellter bei ABC, bräuchte aber trotzdem Hilfe bei steuerlichen Angelegenheiten"),
      MessageObject(
          isYours: false,
          type: MessageType.appointRequest,
          value: Appoint(
              title: "Steuerrechtliche Angelegenheiten klären",
              period: Period(
                  start: DateTime.now(), duration: Duration(minutes: 60)),
              company: company)),
      MessageObject(
          isYours: false,
          type: MessageType.info,
          value: "Termin am 30.07.2019 bestätigt"),
      MessageObject(
          isYours: false,
          type: MessageType.message,
          value:
              "Danke für die Bestätigung des Termins. Falls Sie in der Zwischenzeit weitere Fragen haben, können Sie sich jederzeit bei uns melden"),
              MessageObject(
          isYours: true,
          type: MessageType.message,
          value:
              "Bis dann, ciao!"),
    ];

    return Scaffold(
      appBar: _buildNavBar(context, company.name),
      body: SafeArea(
        child: _buildBody(messages),
      ),
    );
  }

  Widget _buildBody(List<MessageObject> messages) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];

              if (message.type == MessageType.info) {
                return _buildInfoMessage(message.value);
              }

              return _messageTile(message, context);
            },
          ),
        ),
        _buildTextInput()
      ],
    );
  }

  Widget _buildTextInput() {
    return Container(
      color: Colors.grey[100],
      height: 50,
      child: Column(
        children: <Widget>[
          Divider(height: 1),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CupertinoTextField(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    maxLines: 1,
                    placeholder: "Nachricht",
                  ),
                ),
              ),
              IconButton(
                icon: Icon(CupertinoIcons.getIconData(0xf2f6)),
                onPressed: () {
                  print("send");
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _messageTile(MessageObject message, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            message.isYours ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 280,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: message.isYours
                    ? Theme.of(context).accentColor
                    : Colors.grey[300]),
            child: message.type == MessageType.message
                ? _buildTextMessage(message.value)
                : _buildAppointRequest(message.value),
          ),
          if (message.type == MessageType.appointRequest)
            _buildAppointRequestActionButtons(),
        ],
      ),
    );
  }

  Widget _buildInfoMessage(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color(0xffc5d0de),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            //mainAxisAlignment: MainAxisAlignment.center,
            alignment: WrapAlignment.center,

            children: <Widget>[
              Text(
                value,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointRequestActionButtons() {
    return Container(
      width: 280,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Icon(CupertinoIcons.getIconData(0xf417)),
                  ),
                  Text("Anpassen"),
                ],
              ),
              onPressed: () {},
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Icon(
                      CupertinoIcons.check_mark,
                      size: 38,
                    ),
                  ),
                  Text("Annehmen"),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointRequest(Appoint appoint) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Container(
        child: Column(
          children: <Widget>[
            Text(
              appoint.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Align(
              child: Text(
                Parse.dateWithWeekday.format(appoint.period.start),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
              alignment: Alignment.centerLeft,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  IconCircleGradient.periodIndicator(
                      appoint.period.duration.inMinutes / 60),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${Parse.hoursWithMinutes.format(appoint.period.start)} - ${Parse.hoursWithMinutes.format(appoint.period.getPeriodEnd())}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _buildTextMessage(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  NavBar _buildNavBar(BuildContext context, String title) {
    return NavBar(
      title,
      height: 59,
      secondHeader: "Chat",
      leadingWidget: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
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

class MessageObject {
  final bool isYours;
  final dynamic value;
  final MessageType type;

  const MessageObject({
    @required this.isYours,
    @required this.value,
    @required this.type,
  });
}

enum MessageType {
  message,
  appointRequest,
  info,
}
