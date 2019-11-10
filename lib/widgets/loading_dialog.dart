import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingDialog extends StatelessWidget {
  final String title;
  const LoadingDialog({
    Key key,
    @required this.title,
  })  : assert(title != null, "title must not be null"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: <Widget>[
          CupertinoActivityIndicator(),
          Text(title),
        ],
      ),
    );
  }
}
