import 'package:flutter/material.dart';

class Balloon extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final double shadowIntensity;

  const Balloon({
    super.key,
    this.color = Colors.red,
    this.width = 100,
    this.height = 150,
    this.shadowIntensity = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: BalloonPainter(color: color, shadowIntensity: shadowIntensity),
    );
  }
}

class BalloonPainter extends CustomPainter {
  final Color color;
  final double shadowIntensity;

  BalloonPainter({required this.color, required this.shadowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final double bodyHeight = size.height * 0.8;
    
    // Create a Teardrop Shape Path
    final Path bodyPath = Path();
    bodyPath.moveTo(size.width * 0.5, bodyHeight);
    // Left side
    bodyPath.cubicTo(
      -size.width * 0.1, bodyHeight * 0.6, 
      0, 0, 
      size.width * 0.5, 0,
    );
    // Right side
    bodyPath.cubicTo(
      size.width, 0, 
      size.width * 1.1, bodyHeight * 0.6, 
      size.width * 0.5, bodyHeight,
    );

    // 2. Balloon Shadow (Requirement: Realistic Shadow)
    canvas.drawShadow(bodyPath, Colors.black, shadowIntensity, true);

    // 6. Balloon Texture (Requirement: Gradient/Texture)
    final Paint bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 0.8,
        colors: [
          Colors.white.withOpacity(0.5),
          color,
          color.withOpacity(0.8),
          Colors.black.withOpacity(0.1),
        ],
        stops: const [0.0, 0.3, 0.8, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, bodyHeight));

    canvas.drawPath(bodyPath, bodyPaint);

    // 4. Knot (Small triangle)
    final Paint knotPaint = Paint()..color = color.withOpacity(0.9);
    final Path knotPath = Path();
    knotPath.moveTo(size.width * 0.45, bodyHeight);
    knotPath.lineTo(size.width * 0.55, bodyHeight);
    knotPath.lineTo(size.width * 0.5, bodyHeight + 8);
    knotPath.close();
    canvas.drawPath(knotPath, knotPaint);

    // 5. String (Wavy line)
    final Paint stringPaint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final Path stringPath = Path();
    stringPath.moveTo(size.width * 0.5, bodyHeight + 8);
    stringPath.cubicTo(
      size.width * 0.6, bodyHeight + 20, 
      size.width * 0.4, bodyHeight + 35, 
      size.width * 0.5, size.height,
    );
    canvas.drawPath(stringPath, stringPaint);

    // Highlights (Glossy reflections)
    final Paint highlightPaint = Paint()..color = Colors.white.withOpacity(0.4);
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.25, size.height * 0.1, size.width * 0.15, size.height * 0.1),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
