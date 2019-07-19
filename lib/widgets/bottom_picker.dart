import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

const double _kPickerSheetHeight = 216.0;

class BottomPicker extends StatelessWidget {
  final Widget picker;

  BottomPicker({@required this.picker});

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
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}
