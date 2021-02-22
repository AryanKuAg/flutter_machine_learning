import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clock View'),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: Transform.rotate(
            angle: -pi / 2,
            child: CustomPaint(
              painter: ClockPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //code starts
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);
    var fillBrush = Paint()..color = Color(0xFF444974);
    var outLineBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..strokeWidth = 20.0
      ..style = PaintingStyle.stroke;
    var centerFillBrush = Paint()..color = Color(0xFFEAECFF);

    //sec, min, hour brushes
    var secHandBrush = Paint()
      ..color = Colors.orange[300]
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..shader = RadialGradient(colors: [Colors.orange, Colors.redAccent])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 10;
    var minHandBrush = Paint()
      ..color = Colors.orange[300]
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..shader = RadialGradient(colors: [Colors.lightBlue, Colors.pink])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 16;
    var hourHandBrush = Paint()
      ..color = Colors.orange[300]
      ..strokeCap = StrokeCap.round
      ..shader = RadialGradient(colors: [Colors.lightBlue, Colors.pink])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16;

    canvas.drawCircle(center, radius - 20, fillBrush);
    canvas.drawCircle(center, radius - 20, outLineBrush);

    var dateTime = DateTime.now();
    // sec hand
    var secHandX = centerX + 80 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerY + 80 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);
    // min hand
    var minHandX = centerX + 80 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerY + 80 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);
    // hour hand
    var hourHandX = centerX +
        80 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerY +
        80 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    canvas.drawCircle(center, 15, centerFillBrush);

    var outerCircleRadius = radius;
    var innerCircleRadius = radius - 14;

    var dashBrush = Paint()..color = Colors.black87;
    for (double i = 0; i < 360; i += 12) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180) + 10;
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180) + 10;

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180) + 10;
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180) + 10;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }

    // outer circle
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
