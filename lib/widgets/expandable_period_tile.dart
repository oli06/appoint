import 'package:appoint/models/period.dart';
import 'package:appoint/widgets/period_tile.dart';
import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class ExpandablePeriodTile extends StatefulWidget {
  final Widget trailing;
  final List<Widget> children;
  final Period period;
  final Function onTap;

  ExpandablePeriodTile({
    Key key,
    this.trailing,
    this.children,
    @required this.period,
    @required this.onTap,
  }) : super(key: key);

  _ExpandablePeriodTileState createState() => _ExpandablePeriodTileState();
}

class _ExpandablePeriodTileState extends State<ExpandablePeriodTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  AnimationController _controller;
  Animation<double> _heightFactor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    //conflict exists

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PeriodTile(
            period: widget.period,
            onTap: handleTap,
            trailing: widget.trailing,
            //trailingOnTap: _handleTap,
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    //no conflict
    if (widget.trailing == null) {
      return PeriodTile(
        period: widget.period,
        onTap: widget.onTap,
      );
    }

    //else
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}
