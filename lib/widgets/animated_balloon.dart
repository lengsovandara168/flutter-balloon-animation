import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'balloon_component.dart';

class AnimatedBalloonWidget extends StatefulWidget {
  final double initialX;
  final Duration duration;
  final Color color;

  const AnimatedBalloonWidget({
    super.key,
    this.initialX = 0.0,
    this.duration = const Duration(seconds: 10),
    this.color = Colors.red,
  });

  @override
  State<AnimatedBalloonWidget> createState() => _AnimatedBalloonWidgetState();
}

class _AnimatedBalloonWidgetState extends State<AnimatedBalloonWidget> with TickerProviderStateMixin {
  late AnimationController controllerFloat;
  late AnimationController controllerPulse;
  late Animation<double> animationFloatUp;
  late Animation<double> animationRotate;
  late Animation<double> animationPulse;
  late Animation<double> animationDrift;

  final AudioPlayer audioPlayer = AudioPlayer();

  // State for interaction
  Offset _dragOffset = Offset.zero;
  double _scaleFactor = 1.0;
  double _baseScale = 1.0;
  bool isBurst = false;

  @override
  void initState() {
    super.initState();

    controllerFloat = AnimationController(duration: widget.duration, vsync: this);
    controllerPulse = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    animationFloatUp = Tween(begin: 1.1, end: -0.3).animate(
      CurvedAnimation(parent: controllerFloat, curve: Curves.easeInOutBack),
    );

    animationRotate = Tween(begin: -0.15, end: 0.15).animate(
      CurvedAnimation(parent: controllerFloat, curve: Curves.easeInOutSine),
    );

    animationDrift = Tween(begin: -40.0, end: 40.0).animate(
      CurvedAnimation(parent: controllerFloat, curve: Curves.easeInOutSine),
    );

    animationPulse = Tween(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: controllerPulse, curve: Curves.easeInOut),
    );

    controllerFloat.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted && !isBurst) {
          controllerFloat.forward(from: 0.0);
        }
      }
    });

    controllerFloat.forward();
    _preloadSound();
  }

  Future<void> _preloadSound() async {
    try {
      await audioPlayer.setSource(AssetSource('sounds/pop.mp3'));
    } catch (e) {
      debugPrint("Preload error: $e");
    }
  }

  @override
  void dispose() {
    controllerFloat.dispose();
    controllerPulse.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPopSound() async {
    try {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource('sounds/pop.mp3'));
    } catch (e) {
      debugPrint("Sound error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: Listenable.merge([controllerFloat, controllerPulse]),
      builder: (context, child) {
        if (isBurst) return const SizedBox.shrink();

        return Positioned(
          // Vertical movement combines floating animation and drag
          bottom: (screenHeight * animationFloatUp.value) - _dragOffset.dy,
          // Horizontal movement combines initial offset, drift animation, and drag
          left: (screenWidth / 2) - 50 + widget.initialX + animationDrift.value + _dragOffset.dx,
          child: GestureDetector(
            onScaleStart: (details) {
              _baseScale = _scaleFactor;
            },
            onScaleUpdate: (details) {
              setState(() {
                // Handle dragging (moving the focal point)
                _dragOffset += details.focalPointDelta;

                // Handle pinching (scaling)
                // details.scale is 1.0 if not pinching
                if (details.scale != 1.0) {
                  _scaleFactor = (_baseScale * details.scale).clamp(0.5, 5.0);
                }
              });
            },
            onDoubleTap: () {
              setState(() {
                isBurst = true;
              });
              _playPopSound();
            },
            child: Transform.rotate(
              angle: animationRotate.value,
              child: Transform.scale(
                scale: animationPulse.value * _scaleFactor,
                child: Balloon(
                  color: widget.color,
                  width: 100,
                  height: 150,
                  shadowIntensity: (1 - animationFloatUp.value).clamp(0, 1) * 15,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
