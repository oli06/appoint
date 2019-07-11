import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CharacterInput extends StatefulWidget {
  final FocusNode focusNode;
  final int index;

  final Function(int index, String value) inputDone;
  final Function(int index) inputDeleted;

  const CharacterInput(
      {Key key, this.focusNode, this.index, this.inputDeleted, this.inputDone})
      : super(key: key);

  @override
  _CharacterInputState createState() => _CharacterInputState();
}

class _CharacterInputState extends State<CharacterInput> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        if (userValue) {
          setState(() {
            userValue = false;
          });

          _controller.text = '´';
        }
      }
    });
  }

  bool userValue = false;

  @override
  Widget build(BuildContext context) {
    if (!userValue) {
      _controller.text = '´';
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: 55,
        width: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            focusNode: widget.focusNode,
            onChanged: (value) {
              if (value.contains('´')) {
                if (value.startsWith('´')) {
                  _controller.text = _controller.text[1];
                } else {
                  _controller.text = _controller.text[0];
                }

                widget.focusNode.unfocus();

                widget.inputDone(widget.index, _controller.text);
                setState(() {
                  userValue = true;
                });
              } else if (value.isEmpty) {
                widget.inputDeleted(widget.index);
                setState(() {
                  userValue = false;
                });
              }
            },
            enabled: false,
            buildCounter: (
              context, {
              int currentLength,
              int maxLength,
              bool isFocused,
            }) =>
                Text(""),
            keyboardType: TextInputType.number,
            maxLength: 2,
            style: TextStyle(
                fontSize: 30,
                color: !userValue ? Colors.transparent : Colors.black),
            decoration: null,
          ),
        ),
      ),
    );
  }
}
