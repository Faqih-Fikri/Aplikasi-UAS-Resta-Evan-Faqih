import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ClockPage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  Timer? _timer; // Timer variable

  @override
  void initState() {
    super.initState();
    // Start the timer to update every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          // Rebuild the widget to update the time
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer in dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B2C57),
      appBar: AppBar(
        backgroundColor: Color(0xff1B2C57),
        title: Text('Clock',
            style: TextStyle(color: Color(0xff65D1BA), fontSize: 25.0)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Time',
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            // Digital clock
            Text(
              _formatDateTime(DateTime.now()),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            // Analog clock
            SizedBox(
              width: 200.0,
              height: 200.0,
              child: CustomPaint(
                painter: ClockPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    // Draw circle
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, paint);

    // Draw hour hand
    var hour = DateTime.now().hour % 12 + DateTime.now().minute / 60;
    var hourAngle = (hour * 30) * (pi / 180);
    var hourHandX = centerX + radius * 0.4 * cos(hourAngle);
    var hourHandY = centerY + radius * 0.4 * sin(hourAngle);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), paint);

    // Draw minute hand
    var minute = DateTime.now().minute;
    var minuteAngle = minute * 6 * (pi / 180);
    var minuteHandX = centerX + radius * 0.6 * cos(minuteAngle);
    var minuteHandY = centerY + radius * 0.6 * sin(minuteAngle);
    paint.strokeWidth = 5.0;
    canvas.drawLine(center, Offset(minuteHandX, minuteHandY), paint);

    // Draw second hand
    var second = DateTime.now().second;
    var secondAngle = second * 6 * (pi / 180);
    var secondHandX = centerX + radius * 0.6 * cos(secondAngle);
    var secondHandY = centerY + radius * 0.6 * sin(secondAngle);
    paint.color = Colors.red;
    paint.strokeWidth = 2.0;
    canvas.drawLine(center, Offset(secondHandX, secondHandY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
