import 'package:flutter/material.dart';
import '../widgets/animated_balloon.dart';
import '../widgets/background_elements.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Balloon Animation'),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlueAccent, Colors.blue],
          ),
        ),
        child: const Stack(
          children: <Widget>[
            // Background Animation: Moving clouds and birds
            CloudWidget(top: 50, duration: Duration(seconds: 20)),
            BirdWidget(top: 100),
            CloudWidget(top: 180, duration: Duration(seconds: 15)),
            BirdWidget(top: 300),
            CloudWidget(top: 280, duration: Duration(seconds: 25)),

            // Multiple Balloons with slightly varied animations
            AnimatedBalloonWidget(initialX: -120, duration: Duration(seconds: 12), color: Colors.red),
            AnimatedBalloonWidget(initialX: -40, duration: Duration(seconds: 10), color: Colors.yellow),
            AnimatedBalloonWidget(initialX: 40, duration: Duration(seconds: 14), color: Colors.green),
            AnimatedBalloonWidget(initialX: 120, duration: Duration(seconds: 8), color: Colors.purple),

            // Interaction hint
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Drag to move, Pinch to resize, Double tap to burst!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
