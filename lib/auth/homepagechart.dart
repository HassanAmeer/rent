import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeChart extends StatelessWidget {
  const HomeChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  List<String> labels = [
                    "Electrical Box",
                    "Violin",
                    "Type Writer",
                    "Bounce House",
                    "Kia Sole",
                    "Kayak",
                  ];
                  if (value.toInt() < labels.length) {
                    return Transform.rotate(
                      angle: -0.5,
                      child: Text(
                        labels[value.toInt()],
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          ),
          lineBarsData: [
            // My Bookings (yellow)
            LineChartBarData(
              spots: const [
                FlSpot(0, 2),
                FlSpot(1, 19),
                FlSpot(2, 2),
                FlSpot(3, 0),
                FlSpot(4, 1),
                FlSpot(5, 3),
              ],
              isCurved: false,
              color: Colors.orange,
              barWidth: 2,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.orange.withOpacity(0.2),
              ),
              dotData: FlDotData(show: true),
            ),
            // My Rentals (blue)
            LineChartBarData(
              spots: const [
                FlSpot(0, 1),
                FlSpot(1, 13),
                FlSpot(2, 0),
                FlSpot(3, 0),
                FlSpot(4, 0.5),
                FlSpot(5, 2),
              ],
              isCurved: false,
              color: Colors.blue,
              barWidth: 2,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.2),
              ),
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
