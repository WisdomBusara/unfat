import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/weight_entry.dart';
import '../theme/app_theme.dart';

/// Line chart of weight over time — trend data is more useful than any
/// single reading, per the app's own "don't over-interpret one scale
/// reading" philosophy.
class WeightTrendChart extends StatelessWidget {
  final List<WeightEntry> entries; // any order

  const WeightTrendChart({Key? key, required this.entries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entries.length < 2) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Text(
            'Log at least 2 weights to see a trend',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    final sorted = [...entries]..sort((a, b) => a.date.compareTo(b.date));
    final spots = sorted
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.weight))
        .toList();

    final minY = sorted.map((e) => e.weight).reduce((a, b) => a < b ? a : b);
    final maxY = sorted.map((e) => e.weight).reduce((a, b) => a > b ? a : b);
    final padding = ((maxY - minY) * 0.2).clamp(0.5, 10.0);

    return SizedBox(
      height: 160,
      child: LineChart(
        LineChartData(
          minY: minY - padding,
          maxY: maxY + padding,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: ((maxY - minY) / 3).clamp(0.5, double.infinity),
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots.map((s) {
                final entry = sorted[s.x.toInt()];
                return LineTooltipItem(
                  '${entry.weight.toStringAsFixed(1)} kg',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.25,
              color: AppTheme.accent,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.accent.withOpacity(0.25),
                    AppTheme.accent.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
