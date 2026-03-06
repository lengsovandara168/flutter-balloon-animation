import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBalloonWidget extends StatefulWidget {
  final double initialX;
  final Duration duration;

  const AnimatedBalloonWidget({
    super.key,
    this.initialX = 0.0,
    this.duration = const Duration(seconds: 10),
  });

  @override
  _AnimatedBalloonWidgetState createState() => _AnimatedBalloonWidgetState();
}

class _AnimatedBalloonWidgetState extends State<AnimatedBalloonWidget> with TickerProviderStateMixin {
  late AnimationController _controllerFloat;
  late AnimationController _controllerPulse;
  late Animation<double> _animationFloatUp;
  late Animation<double> _animationRotate;
  late Animation<double> _animationPulse;
  late Animation<double> _animationDrift;

  double _dragOffset = 0.0;
  bool _isBurst = false;

  @override
  void initState() {
    super.initState();

    // Controller for floating up and drifting
    _controllerFloat = AnimationController(duration: widget.duration, vsync: this);

    // Controller for pulsating effect
    _controllerPulse = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Easing and Curve Improvement: Using Curves.easeInOutSine for natural floating
    _animationFloatUp = Tween(begin: 1.0, end: -0.2).animate(
      CurvedAnimation(parent: _controllerFloat, curve: Curves.easeInOutSine),
    );

    // Rotation Animation: Slight rotation as it moves up
    _animationRotate = Tween(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controllerFloat, curve: Curves.easeInOutQuad),
    );

    // Horizontal Drift Animation
    _animationDrift = Tween(begin: -20.0, end: 20.0).animate(
      CurvedAnimation(parent: _controllerFloat, curve: Curves.easeInOutSine),
    );

    // Pulse Animation: Subtle size change
    _animationPulse = Tween(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controllerPulse, curve: Curves.easeInOut),
    );

    // Sequential Animations: Listen for completion
    _controllerFloat.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          // You could trigger a 'burst' or 'float away' here
          // For now, let's just reverse or reset
          // _controllerFloat.reverse();
        });
      }
    });

    _controllerFloat.forward();
  }

  @override
  void dispose() {
    _controllerFloat.dispose();
    _controllerPulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: Listenable.merge([_controllerFloat, _controllerPulse]),
      builder: (context, child) {
        if (_isBurst) return const SizedBox.shrink();

        return Positioned(
          bottom: screenHeight * _animationFloatUp.value,
          left: (screenWidth / 2) - 50 + widget.initialX + _animationDrift.value + _dragOffset,
          child: GestureDetector(
            // Interaction: Drag to move
            onPanUpdate: (details) {
              setState(() {
                _dragOffset += details.delta.dx;
              });
            },
            onDoubleTap: () {
              setState(() {
                _isBurst = true; // Sequential: Burst on double tap
              });
              // Sound Effects: Placeholder for sound logic
              // print("Pop sound!");
            },
            child: Transform.rotate(
              angle: _animationRotate.value,
              child: Transform.scale(
                scale: _animationPulse.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Balloon Shadow: Subtle shadow for realistic feel
                    Container(
                      height: 120,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(10, 20),
                          ),
                        ],
                      ),
                    ),
                    // Balloon Texture: Applying a gradient texture using ShaderMask
                    ShaderMask(
                      shaderCallback: (rect) {
                        return const RadialGradient(
                          center: Alignment(-0.3, -0.3),
                          radius: 0.8,
                          colors: [Colors.white70, Colors.transparent],
                          stops: [0.0, 1.0],
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.srcOver,
                      child: Image.asset(
                        'assets/images/BeginningGoogleFlutter-Balloon.png',
                        height: 150,
                        width: 100,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.location_on,
                          size: 100,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
