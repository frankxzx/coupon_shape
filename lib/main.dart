import 'dart:convert';
import 'dart:math';

import 'package:coupon_shape/Logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:typed_data';

class CouponShapeBorder extends ShapeBorder {
  final int holeCount;
  final double lineRate;
  final bool dash;
  final Color dashLineColor;

  CouponShapeBorder(
      {this.holeCount = 1,
      this.lineRate = 0.718,
      this.dash = true,
      this.dashLineColor = Colors.white});

  @override
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    var path = Path();
    var w = rect.width;
    var h = rect.height;
    var d = h * 0.1;

    path.addRect(rect);

    _formHoldLeft(path, rect, d);
    _formHoldRight(path, rect, w, d);

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  _formHoldLeft(Path path, Rect rect, double d) {
    for (int i = 0; i < holeCount; i++) {
      var left = -d / 2;
      var top = (rect.height - d) * 0.6;
      var right = left + d;
      var bottom = top + d;
      path.addArc(Rect.fromLTRB(left, top, right, bottom), -pi / 2, pi);
    }
  }

  _formHoldRight(Path path, Rect rect, double w, double d) {
    for (int i = 0; i < holeCount; i++) {
      var left = -d / 2 + w;
      // var top = 0.0 + d + 2 * d * (i);
      var top = (rect.height - d) * 0.6;
      var right = left + d;
      var bottom = top + d;
      path.addArc(Rect.fromLTRB(left, top, right, bottom), pi / 2, pi);
    }
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    var paint = Paint()
      ..color = dashLineColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    if (dash) {
      //dotted line
      _drawDashLine(canvas, Offset(30, rect.height * 0.6), rect.width / 16,
          rect.width - 30 * 2, paint);
    }
  }

  _drawDashLine(
      Canvas canvas, Offset start, double count, double length, Paint paint) {
    var step = length / count / 2;
    for (int i = 0; i < count; i++) {
      var offset = start + Offset(2 * step * i, 0);
      canvas.drawLine(offset + Offset(step, 0), offset, paint);
    }
  }

  @override
  ShapeBorder scale(double t) {
    return null;
  }
}

class RoundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final r = 10.0;
    final path = Path();
    path.lineTo(0.0, size.height - r);
    path.quadraticBezierTo(0.0, size.height, r, size.height);
    path.lineTo(size.width - r, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - r);
    path.lineTo(size.width, r);
    path.quadraticBezierTo(size.width, 0.0, size.width - r, 0.0);
    path.lineTo(r, 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, r);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('demo'),
      ),
      body: Container(
        color: Color(0xFFF7F7F8),
        child: Center(
          child: ClipPath(
            clipper: RoundClipper(),
            child: Container(
              color: Colors.white,
              child: Material(
                color: Color(0xFFFFFFFF),
                elevation: 1,
                shape: CouponShapeBorder(dashLineColor: Colors.black12),
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 340,
                  width: 380,
                  child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Expanded(
                            flex: 2,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            right: 12, bottom: 12),
                                        width: 60,
                                        height: 60,
                                        child: Image.memory(
                                            base64Decode(LogoBase64))),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Startbucks',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          Text('10-15% off',
                                              style: TextStyle(fontSize: 17)),
                                        ])
                                  ]),
                                  Text(
                                      'Enjoy up Enjoy up Enjoy up Enjoy up Enjoy up Enjoy up Enjoy up Enjoy up Enjoy up Enjoy up',
                                      maxLines: 5,
                                      style:
                                          TextStyle(fontSize: 17, height: 1.5)),
                                ])),
                        Expanded(
                            flex: 1,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Note',
                                      style:
                                          TextStyle(fontSize: 17, height: 1.5)),
                                  ...[
                                    '·Red and sliver card',
                                    '·Red and sliver card',
                                  ]
                                      .map((e) => Text(e,
                                          style: TextStyle(
                                              fontSize: 16, height: 1.5)))
                                      .toList()
                                ])),
                      ])),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}
