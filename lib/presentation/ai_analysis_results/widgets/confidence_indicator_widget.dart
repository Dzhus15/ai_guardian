import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ConfidenceIndicatorWidget extends StatelessWidget {
  final double confidence;
  final double size;
  final bool showPercentage;

  const ConfidenceIndicatorWidget({
    super.key,
    required this.confidence,
    this.size = 40,
    this.showPercentage = true,
  });

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 90) {
      return AppTheme.successColor;
    } else if (confidence >= 70) {
      return AppTheme.dataVisualizationColor;
    } else if (confidence >= 50) {
      return AppTheme.warningColor;
    } else {
      return AppTheme.errorColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getConfidenceColor(confidence);
    final progress = confidence / 100;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Background circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),

          // Progress circle
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              progress: progress,
              color: color,
              strokeWidth: 3,
            ),
          ),

          // Center content
          if (showPercentage)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${confidence.toInt()}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: color,
                          fontSize: size * 0.25,
                        ),
                  ),
                  Text(
                    '%',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: color,
                          fontSize: size * 0.15,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Progress angle
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _CircularProgressPainter ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
