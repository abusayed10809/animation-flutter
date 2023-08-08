import 'package:flutter/material.dart';
import 'package:tesla_animated_app/animation_screens.dart';
import 'package:tesla_animated_app/screens/home_screen.dart';
import 'package:tesla_animated_app/van_animation/rotating_animation.dart';
import 'package:tesla_animated_app/van_animation/box_rotation_animation.dart';
import 'package:tesla_animated_app/van_animation/rotate_flip_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tesla Animated App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      // home: HomeScreen(),
      home: AnimationScreens(),
    );
  }
}
