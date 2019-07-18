import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  const FormButton({
    Key key,
    this.onPressed,
    @required this.text,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    return RaisedButton(
      textColor: Color(0xff333f52),
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.zero,
      child: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
      onPressed: onPressed,
    );
  }
}