import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformSpecificSwitch extends StatelessWidget {
  final bool value;
  final Function(bool value) onChanged;

  PlatformSpecificSwitch({this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return isIos
        ? CupertinoSwitch(
            value: value,
            onChanged: onChanged,
          )
        : Switch(
            value: value,
            onChanged: onChanged, //TODO test if should be in setState
          );
  }
}
