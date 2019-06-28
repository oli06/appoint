import 'package:appoint/pages/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final String _header;
  final Widget leadingWidget;
  final Widget endingWidget;

  NavBar(this._header, this.leadingWidget, {this.endingWidget});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            leadingWidget,
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  _header,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            endingWidget != null ? endingWidget : _endingWidget(context),
          ],
        ),
        Divider(),
      ],
    );
  }

  Widget _endingWidget(context) {
    return IconButton(
      icon: Icon(CupertinoIcons.profile_circled),
      alignment: Alignment.centerRight,
      onPressed: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => ProfilePage(),
        );
      },
    );
  }
}
