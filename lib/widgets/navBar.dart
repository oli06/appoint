import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  final String _header;
  final String secondHeader;
  final Widget tabBar;
  final Widget leadingWidget;
  final Widget trailing;

  NavBar(this._header,
      {this.leadingWidget,
      this.secondHeader = "",
      this.trailing,
      this.tabBar,
      @required this.height});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                leadingWidget,
                _headerText(),
                if (trailing != null)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          padding: EdgeInsets.only(right: 10.0),
                          child: trailing),
                    ),
                  ),
              ],
            ),
            if (tabBar == null) ...[
              Container(
                width: 0,
                height: 0,
              ),
              SizedBox(
                height: 8,
              ),
              Divider(
                height: 1,
              ),
            ] else ...[
              tabBar,
              Divider(
                height: 1,
              )
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);

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
                    color: Color(0xff1991eb),
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
}
