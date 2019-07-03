import 'package:appoint/widgets/day_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WeekdaysRow extends StatefulWidget {
  @override
  _WeekdaysRowState createState() => _WeekdaysRowState();
}

class _WeekdaysRowState extends State<WeekdaysRow> {
  final List<DayButtonData> items = [
    DayButtonData(text: "MO"),
    DayButtonData(text: "DI"),
    DayButtonData(text: "MI"),
    DayButtonData(text: "DO"),
    DayButtonData(text: "FR"),
    DayButtonData(text: "SA"),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
            .map(
              (x) => new DayButton(
                    text: x.text,
                    onTap: () {
                      setState(() {
                        x.toggleEnabled(items);
                      });
                    },
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.5, color: x.isEnabled ? Color(0xff09c199): Color(0xff6e7885)),
                        borderRadius: BorderRadius.circular(5),
                        color: x.isEnabled ? null : Color(0xff6e7885)),
                  ),
            )
            .toList());
  }
}

class DayButtonData {
  final String text;
  bool _isEnabled = true;
  bool get isEnabled => _isEnabled;

  DayButtonData({
    this.text,
  });

  toggleEnabled(List<DayButtonData> buttons) {
    if (_isEnabled) {
      if (canBeDisabled(buttons)) _isEnabled = !_isEnabled;
    } else {
      _isEnabled = !_isEnabled;
    }
  }

  static bool canBeDisabled(List<DayButtonData> buttons) {
    return buttons.where((x) => !x._isEnabled).length != buttons.length - 1;
  }
}
