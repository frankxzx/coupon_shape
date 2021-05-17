import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CouponView extends StatelessWidget {
  const CouponView(
      {Key key,
      @required this.avatarBase64,
      @required this.title,
      @required this.subTitle,
      @required this.description,
      @required this.notes})
      : super(key: key);

  final String avatarBase64;
  final String title;
  final String subTitle;
  final String description;

  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      couponView(),
      _buildHeader(),
      _buildDashLine(),
      _buildFooter(),
    ]));
  }

  Widget _buildHeader() {
    return Container();
  }

  Widget _buildDashLine() {
    return Container();
  }

  Widget _buildFooter() {
    return Container();
  }

  Widget couponView() {
    return Expanded(
        child: ClipPath(
            clipper: CouponClipper(),
            child: Container(
                color: Color(0xFFFA871E),
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 100, bottom: 100),
                      child: DashSeparator(color: Color(0xFFD6D8DA))),
                ]))));
  }
}

class CouponClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, 0.0);
    double controlPoint = size.width * 0.07;

    double gap = 6;
    int count = 8;
    double betweenPadding = 6;
    double increment =
        (size.height - (betweenPadding * 2) - (gap * (count - 1))) / count;

    double p = betweenPadding;

    path.lineTo(0, p);
    while (p < size.height - betweenPadding) {
      path.quadraticBezierTo(controlPoint, p + increment / 2, 0, p + increment);
      p += increment;
      p += gap;
      path.lineTo(0, p);
    }

    p = size.height - betweenPadding;
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, p);
    while (p > 0) {
      path.quadraticBezierTo(size.width - controlPoint, p - increment / 2,
          size.width, p - increment);
      p -= increment;
      p -= gap;
      path.lineTo(size.width, p);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}

class DashSeparator extends StatelessWidget {
  final double height;
  final Color color;
  final Axis direction;

  const DashSeparator(
      {this.height = 1,
      this.color = Colors.black26,
      this.direction = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    return Container(
        child:
            direction == Axis.horizontal ? buildHorizontal() : buildVertical());
  }

  buildHorizontal() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final boxWidth = constraints.constrainWidth();
      final dashWidth = 4.0;
      final dashHeight = height;
      final dashCount = (boxWidth / (2 * dashWidth)).floor();
      return Flex(
        children: List.generate(dashCount, (_) {
          return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(decoration: BoxDecoration(color: color)));
        }),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
      );
    });
  }

  buildVertical() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final boxHeight = constraints.constrainHeight();
      final dashWidth = 4.0;
      final dashCount = (boxHeight / (2 * dashWidth)).floor();
      return Column(
        children: List.generate(dashCount, (_) {
          return SizedBox(
              width: 1,
              height: dashWidth,
              child: DecoratedBox(decoration: BoxDecoration(color: color)));
        }),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // direction: Axis.horizontal,
      );
    });
  }
}
