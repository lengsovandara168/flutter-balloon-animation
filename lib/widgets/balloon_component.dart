import 'package:flutter/material.dart';

class Balloon extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const Balloon({
    super.key,
    this.color = Colors.red,
    this.width = 100,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: BalloonPainter(color: color),
    );
  }
}

class BalloonPainter extends CustomPainter {
  final Color color;

  BalloonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Define dimensions
    final double bodyHeight = size.height * 0.8;
    final Rect bodyRect = Rect.fromLTWH(0, 0, size.width, bodyHeight);

    // 2. Setup the Paint for the balloon body (with a simple Radial Gradient)
    final Paint bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 0.7,
        colors: [Colors.white.withOpacity(0.3), color],
      ).createShader(bodyRect);

    // 3. Draw the Balloon Body (Oval) and Shadow
    final Path bodyPath = Path()..addOval(bodyRect);
    canvas.drawShadow(bodyPath, Colors.black54, 8, true);
    canvas.drawPath(bodyPath, bodyPaint);

    // 4. Draw the Knot (Small Triangle at the bottom)
    final Paint knotPaint = Paint()..color = color;
    final Path knotPath = Path();
    knotPath.moveTo(size.width * 0.45, bodyHeight);
    knotPath.lineTo(size.width * 0.55, bodyHeight);
    knotPath.lineTo(size.width * 0.5, bodyHeight + 10);
    knotPath.close();
    canvas.drawPath(knotPath, knotPaint);

    // 5. Draw the String (Simple curved line)
    final Paint stringPaint = Paint()
      ..color = Colors.black38
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Path stringPath = Path();
    stringPath.moveTo(size.width * 0.5, bodyHeight + 10);
    stringPath.quadraticBezierTo(
      size.width * 0.6, bodyHeight + 30,
      size.width * 0.5, size.height,
    );
    canvas.drawPath(stringPath, stringPaint);

    // 6. Draw a Highlight (Glossy effect)
    final Paint highlightPaint = Paint()..color = Colors.white.withOpacity(0.3);
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.1, size.width * 0.2, size.height * 0.1),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
