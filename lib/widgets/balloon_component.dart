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
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 0.8,
        colors: [
          Colors.white.withOpacity(0.4),
          color,
          color.withOpacity(0.8),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.8));

    // Draw the main balloon body (oval)
    final bodyPath = Path();
    bodyPath.addOval(Rect.fromLTWH(0, 0, size.width, size.height * 0.8));

    // Draw subtle shadow for the balloon body
    canvas.drawShadow(bodyPath, Colors.black, 10, true);
    canvas.drawPath(bodyPath, paint);

    // Draw the knot at the bottom
    final knotPaint = Paint()..color = color.withOpacity(0.9);
    final knotPath = Path();
    knotPath.moveTo(size.width * 0.45, size.height * 0.8);
    knotPath.lineTo(size.width * 0.55, size.height * 0.8);
    knotPath.lineTo(size.width * 0.6, size.height * 0.85);
    knotPath.lineTo(size.width * 0.4, size.height * 0.85);
    knotPath.close();
    canvas.drawPath(knotPath, knotPaint);

    // Draw the string
    final stringPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final stringPath = Path();
    stringPath.moveTo(size.width / 2, size.height * 0.85);
    stringPath.quadraticBezierTo(
      size.width / 2 + 10, size.height * 0.92,
      size.width / 2 - 5, size.height,
    );
    canvas.drawPath(stringPath, stringPaint);

    // Highlight/Glare
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.15, size.width * 0.2, size.height * 0.1),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
