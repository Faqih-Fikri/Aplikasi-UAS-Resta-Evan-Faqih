import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_alarm_app/add_alarm.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> alarms = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _loadAlarms();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    String? alarmsString = prefs.getString('alarms');
    if (alarmsString != null) {
      List<dynamic> alarmsList = json.decode(alarmsString);
      alarms = alarmsList.map((map) => convertMapToAlarm(map)).toList();
      setState(() {});
    }
  }

  Map<String, dynamic> convertAlarmToMap(Map<String, dynamic> alarm) {
    return {
      'time': {
        'hour': alarm['time'].hour,
        'minute': alarm['time'].minute,
      },
      'title': alarm['title'],
      'description': alarm['description'],
      'enabled': alarm['enabled'],
      'days': alarm['days'],
    };
  }

  Map<String, dynamic> convertMapToAlarm(Map<String, dynamic> map) {
    return {
      'time':
          TimeOfDay(hour: map['time']['hour'], minute: map['time']['minute']),
      'title': map['title'],
      'description': map['description'],
      'enabled': map['enabled'],
      'days': List<bool>.from(map['days']),
    };
  }

  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> alarmsList =
        alarms.map((alarm) => convertAlarmToMap(alarm)).toList();
    prefs.setString('alarms', json.encode(alarmsList));
  }

  void _addOrEditAlarm([Map<String, dynamic>? alarmData, int? index]) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddAlarm(alarmData: alarmData),
    ));
    if (result != null) {
      setState(() {
        TimeOfDay selectedTime = result['time'] is TimeOfDay
            ? result['time']
            : TimeOfDay(
                hour: result['time'].hour, minute: result['time'].minute);

        if (index != null) {
          alarms[index] = {
            'time': selectedTime,
            'title': result['title'],
            'description': result['description'],
            'enabled': result['enabled'],
            'days': result['days'],
          };
        } else {
          alarms.add({
            'time': selectedTime,
            'title': result['title'],
            'description': result['description'],
            'enabled': result['enabled'],
            'days': result['days'],
          });
        }
        _saveAlarms();
        _scheduleAlarm(alarms[index ?? alarms.length - 1]);
      });
    }
  }

  Future<void> _scheduleAlarm(Map<String, dynamic> alarm) async {
    final time = alarm['time'] as TimeOfDay;
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif_channel_id', // ID channel notifikasi
      'Alarm Notifications', // Nama channel notifikasi
      channelDescription:
          'Channel for Alarm notifications', // Deskripsi channel
      sound: RawResourceAndroidNotificationSound(
          'nada_dering'), // Nama file suara dari res/raw/
      playSound: true, // Aktifkan pemutaran suara
      importance: Importance.max, // Tingkat pentingnya notifikasi
      priority: Priority.high, // Prioritas notifikasi
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);
    print('Alarm scheduled for: $scheduledDate');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      alarm['title'],
      alarm['description'],
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }
    return scheduledDate;
  }

  void _deleteAlarm(int index) {
    setState(() {
      alarms.removeAt(index);
      _saveAlarms();
    });
  }

  String _formatNextAlarmTime(Map<String, dynamic> alarm) {
    final time = alarm['time'] as TimeOfDay;
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);
    Duration timeUntilNextAlarm =
        scheduledDate.difference(tz.TZDateTime.now(tz.local));

    int hours = timeUntilNextAlarm.inHours;
    int minutes = timeUntilNextAlarm.inMinutes.remainder(60);

    String formattedTimeUntilNextAlarm = '${hours}h ${minutes}m';
    return formattedTimeUntilNextAlarm;
  }

  @override
  Widget build(BuildContext context) {
    int activeAlarmsCount = alarms.where((alarm) => alarm['enabled']).length;

    return Scaffold(
      backgroundColor: Color(0xff1B2C57),
      appBar: AppBar(
        backgroundColor: Color(0xff1B2C57),
        title: Text('Alarms',
            style: TextStyle(color: Color(0xff65D1BA), fontSize: 25.0)),
      ),
      body: Column(
        children: [
          Card(
            color: Color(0xff65D1BA),
            margin: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ListTile(
              title: Text(
                'Active Alarms: $activeAlarmsCount',
                style: TextStyle(color: Color(0xff1B2C57), fontSize: 20.0),
              ),
              trailing: Icon(Icons.alarm, color: Color(0xff1B2C57)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                final alarm = alarms[index];
                return Dismissible(
                  key: Key(alarm['time'].toString()),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    _deleteAlarm(index);
                  },
                  child: Card(
                    color: Color(0xff65D1BA),
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListTile(
                      title: Text(
                        alarm['title'],
                        style: TextStyle(color: Color(0xff1B2C57)),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${alarm['time'].format(context)} - ${alarm['description']}',
                            style: TextStyle(color: Color(0xff1B2C57)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Next Alarm: ${_formatNextAlarmTime(alarm)}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Switch(
                        value: alarm['enabled'],
                        onChanged: (bool value) {
                          setState(() {
                            alarm['enabled'] = value;
                            _saveAlarms();
                            if (value) {
                              _scheduleAlarm(alarm);
                            }
                          });
                        },
                      ),
                      onTap: () => _addOrEditAlarm(alarm, index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff65D1BA),
        onPressed: () => _addOrEditAlarm(),
        child: Icon(Icons.add, color: Color(0xff1B2C57)),
      ),
    );
  }
}
