import 'package:flutter/material.dart';
import '../widgets/animated_balloon.dart';
import '../widgets/background_elements.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Balloon Park'),
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
            CloudWidget(top: 50, duration: Duration(seconds: 40)),
            BirdWidget(top: 100),
            CloudWidget(top: 180, duration: Duration(seconds: 30)),
            BirdWidget(top: 300),
            CloudWidget(top: 280, duration: Duration(seconds: 50)),

            // Spreading out balloons so they don't overlap
            AnimatedBalloonWidget(initialX: -140, duration: Duration(seconds: 30), color: Colors.red),
            AnimatedBalloonWidget(initialX: -70, duration: Duration(seconds: 25), color: Colors.yellow),
            AnimatedBalloonWidget(initialX: 0, duration: Duration(seconds: 35), color: Colors.green),
            AnimatedBalloonWidget(initialX: 70, duration: Duration(seconds: 45), color: Colors.purple),
            AnimatedBalloonWidget(initialX: 140, duration: Duration(seconds: 55), color: Colors.orange),

            // Interaction hint
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      ' Drag to move |  Pinch to resize',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Double tap to burst!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
