import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class OtherPage extends StatelessWidget {
  final List<Map<String, dynamic>> pastAlarms = List.generate(20, (index) {
    final DateTime date = DateTime(2024, 6, index + 1, (index % 24), 0);
    return {
      'time': '${date.hour.toString().padLeft(2, '0')}:00',
      'title': 'Alarm ${index + 1}',
      'description': 'Description for alarm ${index + 1}',
      'date': date,
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B2C57),
      appBar: AppBar(
        backgroundColor: Color(0xff1B2C57),
        title: Text('More',
            style: TextStyle(color: Color(0xff65D1BA), fontSize: 25.0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = '1 Jun';
                              break;
                            case 4:
                              text = '5 Jun';
                              break;
                            case 9:
                              text = '10 Jun';
                              break;
                            case 14:
                              text = '15 Jun';
                              break;
                            case 19:
                              text = '20 Jun';
                              break;
                            default:
                              text = '';
                              break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0,
                            child: Text(text, style: style),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: 19,
                  minY: 0,
                  maxY: 24,
                  lineBarsData: [
                    LineChartBarData(
                      spots: pastAlarms.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(),
                            entry.value['date'].hour.toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Color(0xff65D1BA),
                      barWidth: 4,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: pastAlarms.length,
                itemBuilder: (context, index) {
                  final alarm = pastAlarms[index];
                  return Card(
                    color: Color(0xff65D1BA),
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListTile(
                      title: Text(
                        alarm['title'],
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${alarm['time']} - ${alarm['description']}',
                        style: TextStyle(color: Colors.white),
                      ),
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
}
