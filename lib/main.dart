import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Paint Example'),
        ),
        body: Center(
          child: CustomPaint(
            size: const Size(300, 300), // Chizish joyi hajmi
            painter: ShapePainter(),
          ),
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // To'g'ri chiziq chizish
    final paintLine = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4;
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paintLine);

    // Doira chizish
    final paintCircle = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paintCircle);

    // To'rtburchak chizish
    final paintRect = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.2, 100, 100),
      paintRect,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
