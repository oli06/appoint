import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DayButton extends StatefulWidget {
  final String text;
  final Function onTap;
  final BoxDecoration decoration;

  const DayButton({Key key, @required this.text, this.onTap, this.decoration})
      : super(key: key);

  @override
  _DayButtonState createState() => _DayButtonState();
}

class _DayButtonState extends State<DayButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        constraints: BoxConstraints(minWidth: 50),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        decoration: widget.decoration != null ? widget.decoration : null,
        child: Text(
          widget.text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
