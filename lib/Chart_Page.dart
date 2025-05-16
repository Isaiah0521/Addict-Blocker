import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartPage extends StatelessWidget {
  // Example data: website visit counts
  final Map<String, int> websiteVisits = {
    'google.com': 5,
    'youtube.com': 8,
    'facebook.com': 3,
    'twitter.com': 2,
    'reddit.com': 6,
  };

  ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final websites = websiteVisits.keys.toList();
    final visits = websiteVisits.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Relapse Chart')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: (visits.reduce((a, b) => a > b ? a : b) + 2).toDouble(),
            barTouchData: BarTouchData(enabled: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= websites.length) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        websites[idx],
                        style: const TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                  interval: 1,
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(websites.length, (i) {
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: visits[i].toDouble(),
                    color: Colors.blue,
                    width: 18,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
