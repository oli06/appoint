import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DayButton extends StatefulWidget {
  final String text;
  final Function onTap;

  const DayButton({Key key, @required this.text, this.onTap}) : super(key: key);

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
          //decoration: BoxDecoration(border: Border.all(),borderRadius:BorderRadius.circular(5), color: isEnabled ? null : Colors.grey),
          child: Text(
            widget.text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      
    );
  }
}
