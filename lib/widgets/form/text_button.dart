import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final Color textColor;

  const TextButton(
      {Key key, @required this.text, @required this.onTap, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0, left: 8.0, bottom: 8),
        child: Text(
          text,
          style: TextStyle(
              color: textColor != null ? textColor : Colors.black,
              fontSize: 17),
        ),
      ),
      onTap: onTap,
    );
  }
}
