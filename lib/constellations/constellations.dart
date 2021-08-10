import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Constellations extends StatelessWidget {
  const Constellations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Constellations"),
        centerTitle: false,
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
  List<Particle> particles = [];
  late AnimationController _controller;
  double hue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(days: 365));
    _controller.addListener(() {
      setState(() {});

      if (hue == 360) {
        hue = 0;
      } else {
        hue++;
      }

      for (int i = 0; i < particles.length; i++) {
        if (particles[i].scale <= 0.3) {
          particles.removeAt(i);
          i--;
        }
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addparticles(PointerHoverEvent event) {
    particles.add(Particle(
      width: widget.width,
      height: widget.height,
      x: event.localPosition.dx,
      y: event.localPosition.dy,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _addparticles,
      child: Container(
        width: widget.width,
        height: widget.height,
        child: CustomPaint(
          painter: ConstellationsPainter(
            particles: particles,
            hue: hue,
          ),
        ),
      ),
    );
  }
}

class Particle {
  final double width;
  final double height;

  double x;
  double y;

  late int speedX;
  late int speedY;
  late double scale;

  Particle(
      {required this.width,
      required this.height,
      required this.x,
      required this.y}) {
    this.speedX = math.Random().nextInt(10) - 5;
    this.speedY = math.Random().nextInt(10) - 3;
    this.scale = math.Random().nextInt(30).toDouble();
  }

  void update() {
    this.x += this.speedX;
    this.y += this.speedY;
    this.scale -= 0.5;
  }

  void draw({required Paint paint, required Canvas canvas}) {
    canvas.drawCircle(Offset(this.x, this.y), this.scale, paint);
  }
}

class ConstellationsPainter extends CustomPainter {
  final List<Particle> particles;
  final double hue;

  ConstellationsPainter({required this.particles, required this.hue});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5;
    for (int i = 0; i < particles.length; i++) {
      particles[i].update();
      particles[i].draw(paint: paint, canvas: canvas);
      paint.color = HSLColor.fromAHSL(1, hue, .5, .5).toColor();

      for (int j = i; j < particles.length; j++) {
        final double dx = particles[i].x - particles[j].x;
        final double dy = particles[i].y - particles[j].y;
        final distance = math.sqrt((dx * dx) + (dy * dy));

        if (distance < 100) {
          canvas.drawLine(Offset(particles[i].x, particles[i].y),
              Offset(particles[j].x, particles[j].y), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(ConstellationsPainter oldDelegate) => true;
}
