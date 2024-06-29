import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  bool _isRunning = false;
  Duration _elapsedTime = Duration.zero;
  late Stopwatch _stopwatch;
  List<Duration> _lapTimes = [];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  void _startStopwatch() {
    setState(() {
      _isRunning = true;
      _stopwatch.start();
      _updateStopwatch();
    });
  }

  void _stopStopwatch() {
    setState(() {
      _isRunning = false;
      _stopwatch.stop();
    });
  }

  void _resetStopwatch() {
    setState(() {
      _isRunning = false;
      _stopwatch.reset();
      _elapsedTime = Duration.zero;
      _lapTimes.clear(); // Bersihkan daftar waktu putaran
    });
  }

  void _updateStopwatch() {
    if (_isRunning) {
      Future.delayed(Duration(seconds: 1), () {
        if (_isRunning) {
          setState(() {
            _elapsedTime = _stopwatch.elapsed;
            _updateStopwatch();
          });
        }
      });
    }
  }

  void _recordLapTime() {
    setState(() {
      _lapTimes.insert(
          0, _elapsedTime); // Tambahkan waktu putaran ke awal daftar
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatTime(_elapsedTime);
    return Scaffold(
      backgroundColor: Color(0xff1B2C57),
      appBar: AppBar(
        backgroundColor: Color(0xff1B2C57),
        title: Text('Stopwatch',
            style: TextStyle(color: Color(0xff65D1BA), fontSize: 25.0)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Elapsed Time',
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            Text(
              formattedTime,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.play_arrow, color: Colors.white, size: 36.0),
                  onPressed: _isRunning ? null : _startStopwatch,
                ),
                SizedBox(width: 20.0),
                IconButton(
                  icon: Icon(Icons.stop, color: Colors.white, size: 36.0),
                  onPressed: _isRunning ? _stopStopwatch : null,
                ),
                SizedBox(width: 20.0),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white, size: 36.0),
                  onPressed: _resetStopwatch,
                ),
                SizedBox(width: 20.0),
                IconButton(
                  icon:
                      Icon(Icons.rotate_left, color: Colors.white, size: 36.0),
                  onPressed: _isRunning
                      ? _recordLapTime
                      : null, // Tombol untuk menambah putaran
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Expanded(
              child: ListView.builder(
                itemCount: _lapTimes.length,
                itemBuilder: (context, index) {
                  final lap = _lapTimes[index];
                  return ListTile(
                    title: Text(
                      'Lap ${index + 1}: ${_formatTime(lap)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds =
        twoDigits(duration.inMilliseconds.remainder(1000) ~/ 10);
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds";
  }
}
