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
            // Background Animation: Moving clouds
            CloudWidget(top: 50, duration: Duration(seconds: 20)),
            CloudWidget(top: 150, duration: Duration(seconds: 15)),
            CloudWidget(top: 250, duration: Duration(seconds: 25)),

            // Multiple Balloons with different start positions and durations
            AnimatedBalloonWidget(initialX: -80, duration: Duration(seconds: 12)),
            AnimatedBalloonWidget(initialX: 20, duration: Duration(seconds: 10)),
            AnimatedBalloonWidget(initialX: 90, duration: Duration(seconds: 14)),

            // Interaction hint
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Drag balloons or double tap to burst!',
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
