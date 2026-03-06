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
            child: Icon(Icons.cloud, size: 80, color: Colors.white),
          ),
        );
      },
    );
  }
}
