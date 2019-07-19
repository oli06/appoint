import 'package:flutter/material.dart';
import 'dart:math' as math;

class IconCircleGradient extends StatefulWidget {
  final double height;
  final double width;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final Icon icon;
  final double borderWidth;
  final double percentage;
  IconCircleGradient({
    Key key,
    @required this.icon,
    @required this.gradientEndColor,
    @required this.gradientStartColor,
    @required this.percentage,
    @required this.height,
    @required this.width,
    @required this.borderWidth,
  }) : super(key: key);

  static IconCircleGradient periodIndicator(double percentage) {
    return IconCircleGradient(
      icon: Icon(Icons.access_time,),
      borderWidth: 4,
      gradientStartColor: Color(0xff6dd7c7),
      gradientEndColor: Color(0xff188e9b),
      height: 38,
      width: 38,
      percentage: percentage,
    );
  }

  _IconCircleGradientState createState() => _IconCircleGradientState();
}

class _IconCircleGradientState extends State<IconCircleGradient>
    with TickerProviderStateMixin {
  double percentage = 0.0;
  double progress = 0.0;
  int hourCount = 0;
  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: CustomPaint(
          painter: GradientArcPainter(
            startColor: widget.gradientStartColor,
            endColor: widget.gradientEndColor,
            width: widget.borderWidth,
            progress: progress,
          ),
          child: _buildChild(),
        ),
      ),
    );
  }

  Widget _buildChild() {
    if (hourCount > 0) {
      return Center(
        child: Text("+$hourCount"),
      );
    }

    return widget.icon;
  }

  @override
  initState() {
    super.initState();

    percentage = widget.percentage;
    _calculateHours();

    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    animation = Tween(begin: 0.0, end: percentage).animate(animationController)
      ..addListener(() {
        setState(() {
          progress = animation.value;
        });
      });

    animationController.forward();
  }

  void _calculateHours() {
    if (percentage > 1) {
      while (percentage > 1) {
        hourCount++;
        percentage -= 1;
      }
    }
  }
}

class GradientArcPainter extends CustomPainter {
  const GradientArcPainter({
    @required this.progress,
    @required this.startColor,
    @required this.endColor,
    @required this.width,
  })  : assert(progress != null),
        assert(startColor != null),
        assert(endColor != null),
        assert(width != null),
        super();

  final double progress;
  final Color startColor;
  final Color endColor;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final gradient = new SweepGradient(
      startAngle: 3 * math.pi / 2,
      endAngle: 7 * math.pi / 2,
      tileMode: TileMode.repeated,
      colors: [startColor, endColor],
    );

    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.butt // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (width / 2);
    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(GradientArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
