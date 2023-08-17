import 'dart:math';
import 'package:flutter/material.dart';

class RotatingAnimation extends StatefulWidget {
  const RotatingAnimation({Key? key}) : super(key: key);

  @override
  State<RotatingAnimation> createState() => _RotatingAnimationState();
}

class _RotatingAnimationState extends State<RotatingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    );
    animation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(animationController);

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Rotating Animation'),
      ),
      body: Center(
        ///
        /// using animated builder to hold the animated widget
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            ///
            /// transform widget to transform the rotation
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(animation.value),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
