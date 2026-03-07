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
  double dragOffset = 0.0;
  double scaleFactor = 1.0;
  bool isBurst = false;

  @override
  void initState() {
    super.initState();

    controllerFloat = AnimationController(duration: widget.duration, vsync: this);
    controllerPulse = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Easing and Curve Improvement
    animationFloatUp = Tween(begin: 1.1, end: -0.3).animate(
      CurvedAnimation(parent: controllerFloat, curve: Curves.easeInOutSine),
    );

    // Rotation Animation
    animationRotate = Tween(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: controllerFloat, curve: Curves.easeInOutQuad),
    );

    animationDrift = Tween(begin: -20.0, end: 20.0).animate(
      CurvedAnimation(parent: controllerFloat, curve: Curves.easeInOutSine),
    );

    // Pulse Animation
    animationPulse = Tween(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: controllerPulse, curve: Curves.easeInOut),
    );

    controllerFloat.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) controllerFloat.forward(from: 0.0);
        });
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
      debugPrint("Attempting to play sound: sounds/pop.mp3");
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource('sounds/pop.mp3'));
      debugPrint("Sound play command sent");
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
          bottom: screenHeight * animationFloatUp.value,
          left: (screenWidth / 2) - 50 + widget.initialX + animationDrift.value + dragOffset,
          child: GestureDetector(
            // Interaction: Drag and Pinch
            onScaleUpdate: (details) {
              setState(() {
                dragOffset += details.focalPointDelta.dx;
                scaleFactor = details.scale.clamp(0.5, 2.0);
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
                scale: animationPulse.value * scaleFactor,
                child: Balloon(
                  color: widget.color,
                  width: 100,
                  height: 150,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
