import 'package:appoint/models/period.dart';
import 'package:flutter/widgets.dart';

class PeriodBar extends StatelessWidget {
  final Period period;
  const PeriodBar({Key key, this.period}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xff188e9b), Color(0xff6dd7c7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      height: (period.duration.inMinutes / 1.5),
      width: 5,
    );
  }
}
