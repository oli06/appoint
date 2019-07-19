import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class CupertinoBottomPicker extends StatelessWidget {
  final double _kPickerSheetHeight = 216.0;

  final Widget picker;

  CupertinoBottomPicker({this.picker});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          onTap: () {
          },
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}
