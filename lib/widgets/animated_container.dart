import 'package:flutter/material.dart';

class AnimatedContainerWidget extends StatefulWidget {
  const AnimatedContainerWidget({Key? key}) : super(key: key);

  @override
  _AnimatedContainerWidgetState createState() => _AnimatedContainerWidgetState();
}

class _AnimatedContainerWidgetState extends State<AnimatedContainerWidget> {
  bool _isTapped = false;

  void _toggleContainer() {
    setState(() {
      _isTapped = !_isTapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
            color: _isTapped ? Colors.lightBlueAccent : Colors.redAccent,
            borderRadius: BorderRadius.circular(_isTapped ? 20 : 0),
          ),
          width: _isTapped ? 200 : 100,
          height: _isTapped ? 100 : 200,
        ),
        ElevatedButton(
          child: const Text('Animate Container'),
          onPressed: _toggleContainer,
        ),
      ],
    );
  }
}
