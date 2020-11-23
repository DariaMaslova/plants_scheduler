import 'dart:ui';
import 'package:flutter/widgets.dart';

class LeafTopClipper extends CustomClipper<Path> {
  final double _middlePoint;
  final double _startPoint;
  final double _highPoint;
  final double _lowPoint;

  const LeafTopClipper(
      {double middlePoint = 40.0,
      double startPoint = 72.0,
      double highPoint = 40,
      double lowPoint = 40})
      : _middlePoint = middlePoint,
        _startPoint = startPoint,
        _highPoint = highPoint,
        _lowPoint = lowPoint;

  @override
  Path getClip(Size size) {
    return _createLeafTopPath(0, 0, size.width, size.height, _highPoint,
        _middlePoint, _lowPoint, _startPoint);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LeafBottomClipper extends CustomClipper<Path> {
  final double _middlePoint;
  final double _endtPoint;
  final double _highPoint;
  final double _lowPoint;

  const LeafBottomClipper(
      {double middlePoint = 32.0,
        double endPoint = 72.0,
        double highPoint = 32,
        double lowPoint = 32})
      : _middlePoint = middlePoint,
        _endtPoint = endPoint,
        _highPoint = highPoint,
        _lowPoint = lowPoint;

  @override
  Path getClip(Size size) {
    return _createLeafBottomPath(0, 0, size.width, size.height, _highPoint,
        _middlePoint, _lowPoint, _endtPoint);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LeafBottomShapeBorder extends ShapeBorder {
  final double lowPoint;
  final double highPoint;
  final double middlePoint;
  final double endPoint;

  const LeafBottomShapeBorder(
      {this.lowPoint = 16.0,
      this.highPoint = 24.0,
      this.middlePoint = 20.0,
      this.endPoint = 48.0});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: middlePoint);

  Path _createPath(Rect rect) {
    return _createLeafBottomPath(rect.left, rect.top, rect.right, rect.bottom,
        highPoint, middlePoint, lowPoint, endPoint);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return _createPath(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return _createPath(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return this;
  }

  @override
  ShapeBorder lerpTo(ShapeBorder b, double t) {
    return b;
  }

  @override
  ShapeBorder lerpFrom(ShapeBorder a, double t) {
    return this;
  }
}

Path _createLeafTopPath(double left, double top, double right, double bottom,
    double highPoint, double middlePoint, double lowPoint, double startPoint) {
  final width = right - left;
  Path path = Path();
  path.moveTo(left, bottom);
  path.lineTo(left, startPoint);
  path.quadraticBezierTo(
      left + width / 8, top + highPoint,
      left + width / 2, top + middlePoint
  );
  path.quadraticBezierTo(
      left + 7 / 8 * width, lowPoint,
      right, top
  );
  path.lineTo(right, bottom);

  return path;
}

Path _createLeafBottomPath(double left, double top, double right, double bottom,
    double highPoint, double middlePoint, double lowPoint, double endPoint) {
  final width = right - left;
  Path path = Path();
  path.lineTo(top, bottom);
  path.quadraticBezierTo(
      left + width / 8, bottom - highPoint,
      left + width / 2, bottom - middlePoint
  );
  path.quadraticBezierTo(
      left + 7 / 8 * width, bottom - lowPoint,
      right, bottom - endPoint
  );
  path.lineTo(right, top);
  return path;
}
