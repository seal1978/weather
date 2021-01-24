import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;

class LoaderWidget extends StatefulWidget {
  @override
  _LoaderWidgetState createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Spacer(),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: vector.radians(
                  180 * _controller.value,
                ),
                child: child,
              );
            },
            child: Image.asset(
              'assets/loader.png',
              height: 40,
            ),
          ),
           Text("Loading..."),
          //  Spacer(),
        ],
      ),
     
      
    );
  }
}
