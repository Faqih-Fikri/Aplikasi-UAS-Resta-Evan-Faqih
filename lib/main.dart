import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_alarm_app/clock_page.dart';
import 'package:flutter_alarm_app/home.dart';
import 'package:flutter_alarm_app/other_page.dart';
import 'package:flutter_alarm_app/stopwatch_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Initialize time zones
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta')); // Set to Jakarta time

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Alarm App',
      theme: ThemeData(
        primaryColor: Color(0xff1B2C57),
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ClockPage(),
    HomePage(),
    StopwatchPage(),
    OtherPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer after selecting an item
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Alarm App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff1B2C57),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Clock', style: TextStyle(color: Color(0xff1B2C57))),
              onTap: () {
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Alarm', style: TextStyle(color: Color(0xff1B2C57))),
              onTap: () {
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.timer),
              title:
                  Text('Stopwatch', style: TextStyle(color: Color(0xff1B2C57))),
              onTap: () {
                _onItemTapped(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.more_horiz),
              title: Text('More', style: TextStyle(color: Color(0xff1B2C57))),
              onTap: () {
                _onItemTapped(3);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
