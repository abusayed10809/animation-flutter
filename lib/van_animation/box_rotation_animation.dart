import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class BoxRotationAnimation extends StatefulWidget {
  const BoxRotationAnimation({Key? key}) : super(key: key);

  @override
  State<BoxRotationAnimation> createState() => _BoxRotationAnimationState();
}

const double widthAndHeight = 100;

class _BoxRotationAnimationState extends State<BoxRotationAnimation>
    with TickerProviderStateMixin {
  late AnimationController xAxisAnimationController;
  late AnimationController yAxisAnimationController;
  late AnimationController zAxisAnimationController;

  late Tween<double> animation;

  @override
  void initState() {
    super.initState();

    xAxisAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    yAxisAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    zAxisAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    animation = Tween<double>(
      begin: 0,
      end: pi * 2,
    );

    xAxisAnimationController
      ..reset()
      ..repeat();
    yAxisAnimationController
      ..reset()
      ..repeat();
    zAxisAnimationController
      ..reset()
      ..repeat();
  }

  @override
  void dispose() {
    xAxisAnimationController.dispose();
    yAxisAnimationController.dispose();
    zAxisAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Box Rotate Animation'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
            ),
            AnimatedBuilder(
              animation: Listenable.merge([
                xAxisAnimationController,
                yAxisAnimationController,
                zAxisAnimationController,
              ]),
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateX(animation.evaluate(xAxisAnimationController))
                    ..rotateY(animation.evaluate(yAxisAnimationController))
                    ..rotateZ(animation.evaluate(zAxisAnimationController)),
                  child: Stack(
                    children: [
                      ///
                      /// front
                      Container(
                        width: widthAndHeight,
                        height: widthAndHeight,
                        color: Colors.green,
                      ),

                      ///
                      /// left
                      Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()..rotateY(pi / 2),
                        child: Container(
                          width: widthAndHeight,
                          height: widthAndHeight,
                          color: Colors.red,
                        ),
                      ),

                      ///
                      /// right
                      Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()..rotateY(-pi / 2),
                        child: Container(
                          width: widthAndHeight,
                          height: widthAndHeight,
                          color: Colors.blue,
                        ),
                      ),

                      ///
                      /// back
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(Vector3(0, 0, -widthAndHeight)),
                        child: Container(
                          width: widthAndHeight,
                          height: widthAndHeight,
                          color: Colors.purple,
                        ),
                      ),

                      ///
                      /// top
                      Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.identity()..rotateX(-pi / 2),
                        child: Container(
                          width: widthAndHeight,
                          height: widthAndHeight,
                          color: Colors.yellow,
                        ),
                      ),

                      ///
                      /// bottom
                      Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.identity()..rotateX(pi / 2),
                        child: Container(
                          width: widthAndHeight,
                          height: widthAndHeight,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
