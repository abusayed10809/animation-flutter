import 'dart:math';

import 'package:flutter/material.dart';

class RotateFlipAnimation extends StatefulWidget {
  const RotateFlipAnimation({Key? key}) : super(key: key);

  @override
  State<RotateFlipAnimation> createState() => _RotateFlipAnimationState();
}

enum CircleSide { left, right }

extension on VoidCallback {
  ///
  /// name of the extension is delayed
  /// takes in a duration
  /// returns a function
  /// the function which is called is """this"""
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

///
/// extension to path
extension ToPath on CircleSide {
  Path toPath(Size size) {
    final Path path = Path();

    late Offset offset;
    late bool clockWise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockWise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockWise = true;
        break;
    }

    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockWise,
    );

    path.close();

    return path;
  }
}

///
/// path -> custom clipper -> clip path
class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({
    required this.side,
  });

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class _RotateFlipAnimationState extends State<RotateFlipAnimation>
    with TickerProviderStateMixin {
  late AnimationController counterClockWiseRotationController;
  late Animation<double> counterClockWiseRotationAnimation;

  late AnimationController flipAnimationController;
  late Animation flipAnimation;

  @override
  void initState() {
    super.initState();

    ///
    /// rotation animation
    counterClockWiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    counterClockWiseRotationAnimation = Tween<double>(
      begin: 0,
      end: (-pi / 2),
    ).animate(
      CurvedAnimation(
        parent: counterClockWiseRotationController,
        curve: Curves.bounceOut,
      ),
    );

    ///
    /// flip animation
    flipAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(
      parent: flipAnimationController,
      curve: Curves.bounceOut,
    ));

    ///
    /// establishing status listeners
    counterClockWiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        flipAnimation = Tween<double>(
          begin: flipAnimation.value,
          end: flipAnimation.value + pi,
        ).animate(CurvedAnimation(
          parent: flipAnimationController,
          curve: Curves.bounceOut,
        ));

        flipAnimationController
          ..reset()
          ..forward();
      }
    });

    ///
    /// continue rotation animation after flip animation
    flipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        counterClockWiseRotationAnimation = Tween<double>(
          begin: counterClockWiseRotationAnimation.value,
          end: counterClockWiseRotationAnimation.value + (-pi / 2),
        ).animate(CurvedAnimation(
          parent: counterClockWiseRotationController,
          curve: Curves.bounceOut,
        ));

        counterClockWiseRotationController
          ..reset()
          ..forward();
      }
    });

    counterClockWiseRotationController
      ..reset()
      ..forward.delayed(Duration(seconds: 1));
  }

  @override
  void dispose() {
    counterClockWiseRotationController.dispose();
    flipAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotate Flip Animation'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: counterClockWiseRotationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(counterClockWiseRotationAnimation.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: flipAnimationController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()
                          ..rotateY(
                            flipAnimation.value,
                          ),
                        child: ClipPath(
                          clipper:
                              const HalfCircleClipper(side: CircleSide.left),
                          child: Container(
                            color: Colors.blue,
                            width: 180,
                            height: 180,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: flipAnimationController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()
                          ..rotateY(
                            flipAnimation.value,
                          ),
                        child: ClipPath(
                          clipper:
                              const HalfCircleClipper(side: CircleSide.right),
                          child: Container(
                            color: Colors.yellow,
                            width: 180,
                            height: 180,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
