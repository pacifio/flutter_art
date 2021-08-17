import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Forest extends StatelessWidget {
  const Forest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Constellations"),
        centerTitle: false,
        actions: [
          Center(
            child: Text("ESC to clear".toUpperCase()),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: LayoutBuilder(builder: (context, constrains) {
        return PainterBody(
            width: constrains.maxWidth, height: constrains.maxHeight);
      }),
    );
  }
}

class PainterBody extends StatefulWidget {
  final double width;
  final double height;

  PainterBody({Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  _PainterBodyState createState() => _PainterBodyState();
}

class _PainterBodyState extends State<PainterBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Root> roots = [];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(days: 365));
    _controller.addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addRoot(event) {
    roots.add(new Root(event.localPosition.dx, event.localPosition.dy));
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
            roots.clear();
          }
        }
      },
      child: GestureDetector(
        onPanDown: _addRoot,
        onPanUpdate: _addRoot,
        child: Container(
          color: Colors.white,
          width: widget.width,
          height: widget.height,
          child: CustomPaint(
            painter: ConstellationsPainter(roots),
          ),
        ),
      ),
    );
  }
}

class Root {
  late double x;
  late double y;
  late int speedX;
  late int speedY;
  late double size;
  late int maxSize;
  late double vs;
  late double lightness;

  late double angleX;
  late double vax;

  late double angleY;
  late double vay;
  List branches = [];
  List<Flower> flowers = [];

  Root(double x, double y) {
    this.x = x;
    this.y = y;
    this.speedX = Random().nextInt(4) - 2;
    this.speedY = Random().nextInt(4) - 2;
    this.size = Random().nextDouble() * 1 + 2;
    this.maxSize = Random().nextInt(7) + 5;
    this.vs = Random().nextDouble() * 0.2 + 0.05;
    this.lightness = .1;

    this.angleX = Random().nextDouble() * 6.2;
    this.vax = Random().nextDouble() * 0.6 - 0.3;
    this.angleY = Random().nextDouble() * 6.2;
    this.vay = Random().nextDouble() * 0.6 - 0.3;
  }

  update() {
    this.x += this.speedX + sin(this.angleX);
    this.y += this.speedY + sin(this.angleY);
    this.size += this.vs;
    this.angleX += this.vax;
    this.angleY += this.vay;

    if (this.lightness < .5) {
      this.lightness += 0.009;
    }

    if (this.size < this.maxSize) {
      branches.add({
        'x': this.x.toDouble(),
        'y': this.y.toDouble(),
        'size': this.size,
        'color':
            HSLColor.fromAHSL(1, 140, 1, this.lightness.clamp(0, 1)).toColor(),
      });
    }
  }

  draw(Canvas canvas, Paint paint) {
    double x = 0.0, y = 0.0;
    for (var i in branches) {
      paint.style = PaintingStyle.fill;
      paint.color = i['color'];
      canvas.drawCircle(
        Offset(i['x'], i['y']),
        i['size'],
        paint,
      );

      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = .15;
      paint.color = Colors.black;
      canvas.drawCircle(
        Offset(i['x'], i['y']),
        i['size'],
        paint,
      );
      x = i['x'];
      y = i['y'];
    }

    if (flowers.isEmpty) {
      flowers.add(Flower(x, y, this.size));
    }

    for (var j in flowers) {
      j.update();
      j.draw(canvas, paint);
    }
  }
}

class Flower {
  double x;
  double y;
  double rootSize;

  double speed = 1;

  late double angle;
  late Color color;
  late int base;
  late double size;
  late double maxSize;
  late double vs;

  List pedals = [];

  Flower(
    this.x,
    this.y,
    this.rootSize,
  ) {
    this.angle = Random().nextDouble() * 6.2;
    this.color = Colors.red;
    this.base = 0;
    this.size = 10;
    this.maxSize = 20;
    this.vs = Random().nextDouble() * 0.2 + 0.05;
  }

  update() {
    this.x += 2 * sin(this.angle) + this.rootSize / 2;
    this.y += 2 * cos(this.angle) + this.rootSize / 2;

    this.angle += this.speed;
    this.speed += 0.55;
    this.size += this.vs;

    if (this.size < this.maxSize) {
      pedals.add({'x': this.x, 'y': this.y, 'size': this.size});
    }
  }

  draw(Canvas canvas, Paint paint) {
    for (var i in pedals) {
      paint.style = PaintingStyle.fill;
      paint.color = this.color;
      canvas.drawCircle(Offset(i['x'], i['y']), i['size'], paint);

      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = .15;
      paint.color = Colors.black;
      canvas.drawCircle(
        Offset(i['x'], i['y']),
        i['size'],
        paint,
      );
    }
  }
}

class ConstellationsPainter extends CustomPainter {
  final List<Root> roots;
  ConstellationsPainter(this.roots);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..strokeWidth = 2;
    for (var i in roots) {
      i.update();
      i.draw(canvas, paint);
    }
  }

  @override
  bool shouldRepaint(ConstellationsPainter oldDelegate) => true;
}
