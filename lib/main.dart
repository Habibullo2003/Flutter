import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Rang tanlash uchun kutubxona

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
          title: const Text('Qo‘lda chizish loyihasi'),
        ),
        body: const DrawScreen(),
      ),
    );
  }
}

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  List<Offset?> points = []; // Chizilgan nuqtalarni saqlash
  Color selectedColor = Colors.black; // Qalamning dastlabki rangi
  double strokeWidth = 4.0; // Qalamning dastlabki qalinligi
  bool isErasing = false; // O'chirg'ich rejimi

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                points.add(details.localPosition); // Chizish uchun nuqtalar qo'shiladi
              });
            },
            onPanEnd: (details) {
              setState(() {
                points.add(null); // Nuqtalar uzilib qolmasligi uchun null qo'shiladi
              });
            },
            child: CustomPaint(
              size: Size(double.infinity, double.infinity),
              painter: DrawPainter(points, selectedColor, strokeWidth, isErasing),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.brush),
                color: isErasing ? Colors.black : selectedColor, // Rang tanlash
                onPressed: () {
                  setState(() {
                    isErasing = false; // Qalam rejimiga o'tish
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: isErasing ? Colors.red : Colors.black, // O'chirg'ichni faollashtirish
                onPressed: () {
                  setState(() {
                    isErasing = true; // O'chirg'ich rejimiga o'tish
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.color_lens),
                onPressed: () {
                  _selectColor(context); // Rang tanlash
                },
              ),
              Slider(
                min: 1.0,
                max: 10.0,
                value: strokeWidth,
                onChanged: (value) {
                  setState(() {
                    strokeWidth = value; // Qalam qalinligini o'zgartirish
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Rang tanlash dialogi
  void _selectColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rang tanlang'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color; // Tanlangan rangni yangilash
                });
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Tanlash'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialogni yopish
              },
            ),
          ],
        );
      },
    );
  }
}

// Chizish uchun CustomPainter
class DrawPainter extends CustomPainter {
  final List<Offset?> points;
  final Color selectedColor;
  final double strokeWidth;
  final bool isErasing;

  DrawPainter(this.points, this.selectedColor, this.strokeWidth, this.isErasing);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isErasing ? Colors.white : selectedColor // O'chirg'ichda oq rang ishlatiladi
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint); // Qo'lda chizilgan nuqtalarni bog'lash
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Har safar qayta chizish kerak
  }
}
