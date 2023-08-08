import 'package:flutter/material.dart';

class CustomFaceDrawing extends StatefulWidget {
  const CustomFaceDrawing({Key? key}) : super(key: key);

  @override
  State<CustomFaceDrawing> createState() => _CustomFaceDrawingState();
}

class _CustomFaceDrawingState extends State<CustomFaceDrawing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Face Drawing'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Container(
          color: Colors.yellow,
          child: CustomPaint(
            painter: FaceOutlinePainter(),
          ),
        ),
      ),
    );
  }
}

class FaceOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.indigo;

    ///
    /// left eye
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 40, 100, 100),
        Radius.circular(20),
      ),
      paint,
    );

    ///
    /// Right eye
    canvas.drawOval(
      Rect.fromLTWH(size.width - 120, 40, 100, 100),
      paint,
    );

    ///
    /// Mouth
    final mouth = Path();
    mouth.moveTo(size.width * 0.8, size.height * 0.6);
    mouth.arcToPoint(
      Offset(size.width * 0.2, size.height * 0.6),
      radius: Radius.circular(150),
    );
    mouth.arcToPoint(
      Offset(size.width * 0.8, size.height * 0.6),
      radius: Radius.circular(100),
      clockwise: false,
    );

    canvas.drawPath(mouth, paint);
  }

  @override
  bool shouldRepaint(FaceOutlinePainter oldDelegate) => false;
}
