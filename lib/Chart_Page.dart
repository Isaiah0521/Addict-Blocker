import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'visit_data.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final visitData = Provider.of<VisitData>(context);

    final websites = visitData.websiteVisits.keys.toList();
    final websiteVisits = visitData.websiteVisits.values.toList();

    final apps = visitData.appVisits.keys.toList();
    final appVisits = visitData.appVisits.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Visits Chart')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY:
                [
                  ...websiteVisits,
                  ...appVisits,
                ].fold<int>(0, (prev, e) => e > prev ? e : prev).toDouble() +
                2,
            barGroups: [
              for (int i = 0; i < websites.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: websiteVisits[i].toDouble(),
                      color: Colors.blue,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                  showingTooltipIndicators: [0],
                ),
              for (int i = 0; i < apps.length; i++)
                BarChartGroupData(
                  x: i + websites.length,
                  barRods: [
                    BarChartRodData(
                      toY: appVisits[i].toDouble(),
                      color: Colors.green,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                  showingTooltipIndicators: [0],
                ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    int idx = value.toInt();
                    if (idx < websites.length) {
                      return Text(
                        websites[idx],
                        style: const TextStyle(fontSize: 10),
                      );
                    } else if (idx - websites.length < apps.length) {
                      return Text(
                        apps[idx - websites.length],
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}
