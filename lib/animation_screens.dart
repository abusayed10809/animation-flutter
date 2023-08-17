import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tesla_animated_app/screens/home_screen.dart';
import 'package:tesla_animated_app/van_animation/animated_prompt_screen.dart';
import 'package:tesla_animated_app/van_animation/box_rotation_animation.dart';
import 'package:tesla_animated_app/van_animation/color_changing_animation.dart';
import 'package:tesla_animated_app/van_animation/custom_face_drawing.dart';
import 'package:tesla_animated_app/van_animation/drawer_animation.dart';
import 'package:tesla_animated_app/van_animation/hero_emoji_animation.dart';
import 'package:tesla_animated_app/van_animation/implicit_zoom_animation.dart';
import 'package:tesla_animated_app/van_animation/page_transition_animation.dart';
import 'package:tesla_animated_app/van_animation/rotate_flip_animation.dart';
import 'package:tesla_animated_app/van_animation/rotating_animation.dart';
import 'package:tesla_animated_app/van_animation/rotating_polygon_animation.dart';
import 'package:tesla_animated_app/van_animation/shoe_color_filter.dart';

/*
* ------------------------------------------------
* main animation screen
* ------------------------------------------------
* */
class AnimationScreens extends StatelessWidget {
  const AnimationScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ///
            /// floating particles in the background
            FloatingParticleWidget(),

            ///
            /// the entire list
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    CommonButton(
                      title: 'Car App Animation',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomeScreen()));
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonButton(
                      title: 'Rotating Animation',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => RotatingAnimation()));
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonButton(
                      title: 'Rotate Flip Animation',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => RotateFlipAnimation()));
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonButton(
                      title: '3D Box Rotation',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => BoxRotationAnimation()));
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonButton(
                      title: 'Hero Emoji Animation',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => HeroEmojiAnimation()));
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonButton(
                      title: 'Implicit Zoom Animation',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ImplicitZoomAnimation()));
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonButton(
                      title: 'Color Changing Animation',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ColorChangingAnimation()));
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonButton(
                      title: 'Hero Clip Animation',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => PageTransitionAnimation()));
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonButton(
                      title: 'Image Color Filter',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShoeColorFilter()));
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonButton(
                      title: 'Rotating Polygon Animation',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => RotatingPolygonAnimation()));
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonButton(
                      title: 'Custom Face Drawing',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => CustomFaceDrawing()));
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonButton(
                      title: 'Drawer Animation',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => AnimatedDrawer(),
                        ));
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    CommonButton(
                      title: 'Animated Prompt',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => AnimatedPromptScreen(),
                        ));
                      },
                    ),
                    SizedBox(
                      height: 50,
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

/*
* ------------------------------------------------
* common button widget
* ------------------------------------------------
* */
class CommonButton extends StatefulWidget {
  final VoidCallback onTap;
  final String title;
  const CommonButton({Key? key, required this.onTap, required this.title}) : super(key: key);

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: 200,
        height: 50,
        color: Colors.blue,
        child: FittedBox(
          child: Text(
            widget.title,
          ),
        ),
      ),
    );
  }
}

/*
* ------------------------------------------------
* floating particle background widget
* ------------------------------------------------
* */
class FloatingParticleWidget extends StatefulWidget {
  const FloatingParticleWidget({Key? key}) : super(key: key);

  @override
  State<FloatingParticleWidget> createState() => _FloatingParticleWidgetState();
}

class _FloatingParticleWidgetState extends State<FloatingParticleWidget> {
  late Timer timer;
  late List<Particle> floatingParticles = List<Particle>.generate(400, (index) => Particle());

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(milliseconds: 1000 ~/ 60), (timer) async {
      final List<Particle> newFloatingParticles = calculateParticlePosition(floatingParticles);
      setState(() {
        floatingParticles = newFloatingParticles;
      });
    });
  }

  ///
  /// function for calculating the position of all the particles
  static List<Particle> calculateParticlePosition(List<Particle> particleList) {
    particleList.forEach((singleParticle) {
      ///
      /// when x axis position goes out of screen bound, change direction of particle which is dx
      if (singleParticle.position.dx > 380 || singleParticle.position.dx < 0) {
        singleParticle.dx = singleParticle.dx * (-1);
      }

      ///
      /// when y axis position goes out of screen bound, change direction of particle which is dy
      if (singleParticle.position.dy > 700 || singleParticle.position.dy < 0) {
        singleParticle.dy = singleParticle.dy * (-1);
      }

      ///
      /// update the position value of the particle
      singleParticle.position += Offset(singleParticle.dx, singleParticle.dy);
    });

    return particleList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: FloatingParticleAnimation(floatingParticles),
      ),
    );
  }
}

/*
* ------------------------------------------------
* floating particle animation
* ------------------------------------------------
* */
class FloatingParticleAnimation extends CustomPainter {
  List<Particle> floatingParticle;

  FloatingParticleAnimation(this.floatingParticle);

  @override
  void paint(Canvas canvas, Size size) {
    ///
    /// drawing the center red circle
    final c = Offset(size.width / 2, size.height / 2);
    final radius = 100.0;
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(c, radius, paint);

    ///
    /// drawing the particles
    this.floatingParticle.forEach((singleParticle) {
      canvas.drawCircle(
        singleParticle.position,
        singleParticle.radius,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white,
      );
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/*
* ------------------------------------------------
* particle class
* ------------------------------------------------
* */
class Particle {
  late double radius;
  late Color color;
  late Offset position;
  late double dx;
  late double dy;

  ///
  /// constructor
  /// radius ->>> in range of 3 to 10
  /// position is the initial spawn position, x range ->>> 0 to 400, y range ->>> 0 to 700
  Particle() {
    this.radius = Utils.Range(3, 10);
    this.color = Colors.black26;
    this.position = Offset(Utils.Range(0, 400), Utils.Range(0, 700));

    ///
    /// dx and dy indicates the direction of flow of the particle along the x and y axis
    /// also determines the movement speed of each particle randomly tweaking dx and dy value
    this.dx = Utils.Range(-1, 1);
    this.dy = Utils.Range(-1, 1);
  }
}

/*
* ------------------------------------------------
* determine the random range
* ------------------------------------------------
* */
final range = Random();

class Utils {
  static double Range(double min, double max) {
    ///
    /// range.nextdouble Value is >= 0.0 and < 1.0.
    return range.nextDouble() * (max - min) + min;
  }
}
