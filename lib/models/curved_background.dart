import 'package:flutter/material.dart';

class CurvedBackground extends StatelessWidget {
  final double height;
  final Color color;

  const CurvedBackground({
    super.key,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, height),
      painter: CurvePainter(color),
    );
  }
}

class CurvePainter extends CustomPainter {
  final Color color;

  CurvePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.5, 
      size.height,
      size.width, 
      size.height * 0.3,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}