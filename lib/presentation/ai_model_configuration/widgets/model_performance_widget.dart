import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ModelPerformanceWidget extends StatefulWidget {
  final List<Map<String, dynamic>> categories;

  const ModelPerformanceWidget({
    super.key,
    required this.categories,
  });

  @override
  State<ModelPerformanceWidget> createState() => _ModelPerformanceWidgetState();
}

class _ModelPerformanceWidgetState extends State<ModelPerformanceWidget> {
  String _selectedMetric = 'accuracy';
  String _selectedTimeRange = '24h';

  final List<Map<String, dynamic>> _performanceData = [
    {"time": "00:00", "accuracy": 94.5, "speed": 87.2, "usage": 65.8},
    {"time": "04:00", "accuracy": 93.8, "speed": 89.1, "usage": 62.4},
    {"time": "08:00", "accuracy": 95.2, "speed": 85.7, "usage": 68.9},
    {"time": "12:00", "accuracy": 94.1, "speed": 88.3, "usage": 71.2},
    {"time": "16:00", "accuracy": 96.0, "speed": 84.5, "usage": 69.7},
    {"time": "20:00", "accuracy": 94.7, "speed": 86.8, "usage": 67.3},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMetricSelector(),
        SizedBox(height: 16),
        _buildTimeRangeSelector(),
        SizedBox(height: 24),
        _buildPerformanceChart(),
        SizedBox(height: 24),
        _buildSystemHealthIndicators(),
        SizedBox(height: 24),
        _buildActiveModelsOverview(),
      ],
    );
  }

  Widget _buildMetricSelector() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metric',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricChip('Accuracy', 'accuracy'),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildMetricChip('Speed', 'speed'),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildMetricChip('Usage', 'usage'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(String label, String value) {
    final isSelected = _selectedMetric == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedMetric = value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentColor
              : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Range',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            Row(
              children: ['1h', '6h', '24h', '7d']
                  .map(
                    (range) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: range != '7d' ? 8 : 0),
                        child: _buildTimeRangeChip(range),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeChip(String range) {
    final isSelected = _selectedTimeRange == range;
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeRange = range),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentColor
              : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          range,
          textAlign: TextAlign.center,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Trend',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}%',
                          style: AppTheme.lightTheme.textTheme.labelSmall,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < _performanceData.length) {
                            return Text(
                              _performanceData[value.toInt()]["time"],
                              style: AppTheme.lightTheme.textTheme.labelSmall,
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _performanceData.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value[_selectedMetric] as double,
                        );
                      }).toList(),
                      isCurved: true,
                      color: _getMetricColor(_selectedMetric),
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: _getMetricColor(_selectedMetric),
                          strokeWidth: 2,
                          strokeColor: AppTheme.lightTheme.colorScheme.surface,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: _getMetricColor(_selectedMetric)
                            .withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemHealthIndicators() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Health',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildHealthIndicator(
                    'CPU Usage',
                    68.5,
                    AppTheme.warningColor,
                    'processor',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildHealthIndicator(
                    'Memory',
                    45.2,
                    AppTheme.successColor,
                    'memory',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildHealthIndicator(
                    'Storage',
                    78.9,
                    AppTheme.errorColor,
                    'storage',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthIndicator(
      String label, double value, Color color, String iconName) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            '${value.toInt()}%',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveModelsOverview() {
    final activeModels = <Map<String, dynamic>>[];
    for (var category in widget.categories) {
      final models = category["models"] as List;
      activeModels.addAll(models
          .where((model) => model["isEnabled"] as bool)
          .cast<Map<String, dynamic>>());
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Models',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${activeModels.length} Active',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...activeModels.take(3).map((model) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.successColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          model["name"],
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        '${(model["accuracy"] as double).toInt()}%',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )),
            if (activeModels.length > 3) ...[
              SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                child: Text('View All ${activeModels.length} Models'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getMetricColor(String metric) {
    switch (metric) {
      case 'accuracy':
        return AppTheme.successColor;
      case 'speed':
        return AppTheme.dataVisualizationColor;
      case 'usage':
        return AppTheme.warningColor;
      default:
        return AppTheme.accentColor;
    }
  }
}
