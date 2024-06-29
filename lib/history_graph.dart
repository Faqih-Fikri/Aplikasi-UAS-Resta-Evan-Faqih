import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryGraph extends StatelessWidget {
  final List<Map<String, dynamic>> executedAlarms;

  HistoryGraph({required this.executedAlarms});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: executedAlarms.map((alarm) {
              // Konversi data alarms yang telah dilaksanakan ke titik data untuk grafik
              return FlSpot(
                executedAlarms.indexOf(alarm).toDouble(),
                alarm['value'].toDouble(), // Contoh: nilai dari data alarm
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
