import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

class Dialog extends StatelessWidget {
  final String title;
  final String information;
  final Widget userActionWidget;
  const Dialog({Key key, this.title, this.information, this.userActionWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return material.Dialog(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(CupertinoIcons.clear),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              )
            ],
          ),
          Divider(
            height: 1,
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    information,
                  ),
                  userActionWidget
                ],
              )),
        ],
      ),
    );
  }
}
