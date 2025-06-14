import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class StatusBarWidget extends StatelessWidget {
  final bool isConnected;
  final int activeCameraCount;
  final String connectionQuality;

  const StatusBarWidget({
    super.key,
    required this.isConnected,
    required this.activeCameraCount,
    required this.connectionQuality,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Connection Status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isConnected
                  ? AppTheme.successColor.withValues(alpha: 0.1)
                  : AppTheme.errorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isConnected
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  isConnected ? 'Connected' : 'Disconnected',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: isConnected
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Spacer(),

          // Active Cameras
          Row(
            children: [
              CustomIconWidget(
                iconName: 'videocam',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                '\$activeCameraCount Active',
                style: AppTheme.lightTheme.textTheme.labelMedium,
              ),
            ],
          ),

          SizedBox(width: 16),

          // Connection Quality
          Row(
            children: [
              CustomIconWidget(
                iconName: 'signal_cellular_4_bar',
                color: _getQualityColor(connectionQuality),
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                connectionQuality,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: _getQualityColor(connectionQuality),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getQualityColor(String quality) {
    switch (quality.toLowerCase()) {
      case 'excellent':
        return AppTheme.successColor;
      case 'good':
        return AppTheme.dataVisualizationColor;
      case 'fair':
        return AppTheme.warningColor;
      case 'poor':
        return AppTheme.errorColor;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface;
    }
  }
}
