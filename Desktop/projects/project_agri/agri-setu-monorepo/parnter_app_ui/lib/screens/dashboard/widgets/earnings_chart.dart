import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import '../../../data/mock_data.dart';

class EarningsChart extends StatelessWidget {
  final bool isTablet;

  const EarningsChart({super.key, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10000,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => ProviderColors.primary,
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '₹${rod.toY.round()}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: ProviderColors.textMuted,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                );
                String text = '';
                if (value.toInt() < MockDataRepository.earningsHistory.length) {
                  text =
                      MockDataRepository.earningsHistory[value.toInt()]['day']
                          as String;
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(text, style: style),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: MockDataRepository.earningsHistory.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: (e.value['amount'] as int).toDouble(),
                gradient: const LinearGradient(
                  colors: [ProviderColors.primaryLight, ProviderColors.primary],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: isTablet ? 24 : 20,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
