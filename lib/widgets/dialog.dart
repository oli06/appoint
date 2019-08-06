import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

class Dialog extends StatelessWidget {
  final String title;
  final String information;
  final double informationTextSize;
  final Widget userActionWidget;
  final bool canClose;
  const Dialog({
    Key key,
    this.title,
    this.information,
    this.userActionWidget,
    this.informationTextSize,
    this.canClose = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: material.Dialog(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (canClose)
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.clear,
                        size: 32,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                    ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  )
                ],
              ),
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
                      style: TextStyle(
                          fontSize: informationTextSize != null
                              ? informationTextSize
                              : 14),
                    ),
                    if (userActionWidget != null) userActionWidget,
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
