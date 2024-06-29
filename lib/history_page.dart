import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> executedAlarms;

  HistoryPage({required this.executedAlarms});

  @override
  Widget build(BuildContext context) {
    // Logic to calculate statistics
    int totalExecuted = executedAlarms.length;
    int executedToday = executedAlarms
        .where((alarm) => _isToday(DateTime.parse(alarm['timestamp'])))
        .length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm History'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statistics',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Total Executed: $totalExecuted',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Executed Today: $executedToday',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: executedAlarms.length,
              itemBuilder: (context, index) {
                final alarm = executedAlarms[index];
                return Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ListTile(
                    title: Text(
                      alarm['title'],
                      style: TextStyle(color: Colors.blue, fontSize: 18.0),
                    ),
                    subtitle: Text(
                      alarm['description'],
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Icon(Icons.history),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }
}
