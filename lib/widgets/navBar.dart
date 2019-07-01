import 'package:appoint/pages/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final String _header;
  final String secondHeader;
  final Widget tabBar;
  final Widget leadingWidget;
  final Widget endingWidget;

  NavBar(this._header, this.leadingWidget,
      {this.secondHeader = "", this.endingWidget, this.tabBar});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            leadingWidget,
            _headerText(),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: endingWidget != null
                      ? endingWidget
                      : _endingWidget(context),
                ),
              ),
            ),
          ],
        ),
        tabBar == null ? Container(width: 0, height: 0,) : tabBar,
        tabBar == null ? Divider() : Divider(height: 1,), //divider line finishes with tabBar if tabBar exists
      ],
    );
  }

  Widget _headerText() {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _header,
            style: TextStyle(
              fontSize: 26,
              fontWeight:
                  secondHeader != "" ? FontWeight.w200 : FontWeight.w700,
            ),
          ),
          secondHeader != ""
              ? Text(
                  secondHeader,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : Container(
                  height: 0,
                ),
        ],
      ),
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
