import 'package:flutter/material.dart';

class CloudWidget extends StatefulWidget {
  final double top;
  final Duration duration;
  const CloudWidget({super.key, required this.top, required this.duration});

  @override
  _CloudWidgetState createState() => _CloudWidgetState();
}

class _CloudWidgetState extends State<CloudWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)..repeat();
    _animation = Tween(begin: -150.0, end: 500.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: widget.top,
          left: _animation.value,
          child: Opacity(
            opacity: 0.6,
            child: const Icon(Icons.cloud, size: 80, color: Colors.white),
          ),
        );
      },
    );
  }
}

class BirdWidget extends StatefulWidget {
  final double top;
  const BirdWidget({super.key, required this.top});

  @override
  _BirdWidgetState createState() => _BirdWidgetState();
}

class _BirdWidgetState extends State<BirdWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Decreased speed by increasing duration to 10 seconds
    _controller = AnimationController(duration: const Duration(seconds: 10), vsync: this)..repeat();
    _animation = Tween(begin: 500.0, end: -100.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: widget.top,
          left: _animation.value,
          child: const Icon(Icons.flutter_dash, size: 30, color: Colors.white70),
        );
      },
    );
  }
}
