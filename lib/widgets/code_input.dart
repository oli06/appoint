import 'package:flutter/material.dart';
import 'package:appoint/widgets/character_input.dart';

class CodeInput extends StatefulWidget {
  final int length;
  final Function(String code) done;

  CodeInput({Key key, @required this.length, @required this.done})
      : super(key: key);

  @override
  _CodeInputState createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  List<FocusNode> nodes = [];

  @override
  initState() {
    super.initState();

    for (var i = 0; i < widget.length; i++) {
      nodes.add(FocusNode());
    }
  }

  dispose() {
    nodes.forEach((n) => n.dispose());
    super.dispose();
  }

  String code = "";
  void inputDone(int index, String value) {
    code += value;
    print("new code: $code");
    if (index == nodes.length - 1) {
      print("finished with: $code");
      widget.done(code);
    } else {
      FocusScope.of(context).requestFocus(nodes[index + 1]);
    }
  }

  void inputDeleted(int index) {
    if (index != 0){
      nodes[index].unfocus();
      code = code.substring(0, code.length - 1);
      FocusScope.of(context).requestFocus(nodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (nodes.length > code.length) {
      FocusScope.of(context).requestFocus(nodes[code.length]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ...[
          for (var i = 0; i < widget.length; i++)
            CharacterInput(
              focusNode: nodes[i],
              index: i,
              inputDeleted: inputDeleted,
              inputDone: inputDone,
            ),
        ],
      ],
    );
  }
}
