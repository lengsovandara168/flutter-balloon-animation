import 'package:flutter/material.dart';

class AnimatedCrossFadeWidget extends StatefulWidget {
  const AnimatedCrossFadeWidget({Key? key}) : super(key: key);

  @override
  _AnimatedCrossFadeWidgetState createState() => _AnimatedCrossFadeWidgetState();
}

class _AnimatedCrossFadeWidgetState extends State<AnimatedCrossFadeWidget> {
  bool _crossFadeStateShowFirst = true;

  void _crossFade() {
    setState(() {
      _crossFadeStateShowFirst = !_crossFadeStateShowFirst;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 500),
          sizeCurve: Curves.bounceOut,
          crossFadeState: _crossFadeStateShowFirst
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Container(
            color: Colors.orange,
            height: 100.0,
            width: 100.0,
          ),
          secondChild: Container(
            color: Colors.cyan,
            height: 200.0,
            width: 200.0,
          ),
        ),
        ElevatedButton(
          child: const Text('Cross-Fade'),
          onPressed: _crossFade,
        ),
      ],
    );
  }
}
