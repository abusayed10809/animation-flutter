import 'dart:math';

import 'package:flutter/material.dart';

enum CircleSide { left, right }

/*
*  --------------------------------------------------
*  path -> custom clipper -> clip path
*/
class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({
    required this.side,
  });

  @override
  Path getClip(Size size) {
    final Path path = Path();

    late Offset offset;
    late bool clockWise;

    ///
    /// selecting points for the path of the circle sides
    switch (side) {
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

    ///
    /// drawing the arc for a half circle
    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockWise,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

/*
* --------------------------------------------------
* rotate flip animation widget
* */
class RotateFlipAnimation extends StatefulWidget {
  const RotateFlipAnimation({Key? key}) : super(key: key);

  @override
  State<RotateFlipAnimation> createState() => _RotateFlipAnimationState();
}

class _RotateFlipAnimationState extends State<RotateFlipAnimation> with TickerProviderStateMixin {
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
        ///
        /// set the initial flip animation value to the current flip animation position value
        /// set the end value by adding a 180 degree flip to the current value
        flipAnimation = Tween<double>(
          begin: flipAnimation.value,
          end: flipAnimation.value + pi,
        ).animate(CurvedAnimation(
          parent: flipAnimationController,
          curve: Curves.bounceOut,
        ));

        ///
        /// reset the controller and set it forward with the new values
        flipAnimationController
          ..reset()
          ..forward();
      }
    });

    ///
    /// continue rotation animation after flip animation
    flipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ///
        /// set the rotation controller initial value to current rotation value
        /// end value is initial value + 90 degrees
        counterClockWiseRotationAnimation = Tween<double>(
          begin: counterClockWiseRotationAnimation.value,
          end: counterClockWiseRotationAnimation.value + (-pi / 2),
        ).animate(CurvedAnimation(
          parent: counterClockWiseRotationController,
          curve: Curves.bounceOut,
        ));

        ///
        /// reset the animation controller and animate again
        counterClockWiseRotationController
          ..reset()
          ..forward();
      }
    });

    Future.delayed(
      Duration(seconds: 1),
      () {
        counterClockWiseRotationController
          ..reset()
          ..forward();
      },
    );
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
        ///
        /// animated builder for animations
        child: AnimatedBuilder(
          animation: counterClockWiseRotationController,
          builder: (context, child) {
            ///
            /// rotation animation transform
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(
                  counterClockWiseRotationAnimation.value,
                ),

              ///
              /// row of items
              /// rotation will take place for the entire row
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///
                  /// flip animation for left half circle
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
                          clipper: const HalfCircleClipper(side: CircleSide.left),
                          child: Container(
                            color: Colors.blue,
                            width: 180,
                            height: 180,
                          ),
                        ),
                      );
                    },
                  ),

                  ///
                  /// flip animation for right half circle
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
                          clipper: const HalfCircleClipper(side: CircleSide.right),
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

/*
* ----------------------------------------
* extensions on voidcallbacks
* */
extension on VoidCallback {
  ///
  /// name of the extension is delayed
  /// takes in a duration
  /// returns a function
  /// the function which is called is """this"""
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

/*
* --------------------------------------------------
* extension on circle side which is an enum
* circle side can be either ->>> left or right as declared in the enum
*/
extension on CircleSide {
  ///
  /// toPath is the extension
  Path toPath(Size size) {
    final Path path = Path();

    late Offset offset;
    late bool clockWise;

    ///
    /// selecting points for the path of the circle sides
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

    ///
    /// drawing the arc for a half circle
    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockWise,
    );

    path.close();

    return path;
  }
}
