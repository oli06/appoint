import 'package:appoint/utils/parse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter/widgets.dart';

class AnimatedListHeader extends StatelessWidget {
  final DateTime start;
  final SliverStickyHeaderState state;
  final Function onTap;

  const AnimatedListHeader({
    Key key,
    this.start,
    this.onTap,
    this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 35,
        color: (state.isPinned ? Colors.grey[300] : Colors.white)
            .withOpacity(1.0 - state.scrollPercentage),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(Parse.dateWithWeekday.format(start.toUtc())),
        ),
      ),
    );
  }
}
