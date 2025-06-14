import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlertCardWidget extends StatelessWidget {
  final Map<String, dynamic> alert;
  final bool isMultiSelectMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Function(String) onSwipeRight;
  final Function(String) onSwipeLeft;

  const AlertCardWidget({
    super.key,
    required this.alert,
    required this.isMultiSelectMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  });

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppTheme.errorColor;
      case 'high':
        return AppTheme.warningColor;
      case 'medium':
        return AppTheme.dataVisualizationColor;
      case 'low':
        return AppTheme.successColor;
      default:
        return AppTheme.neutralMedium;
    }
  }

  IconData _getAlertTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'intrusion detection':
        return Icons.security;
      case 'inappropriate behavior':
        return Icons.warning;
      case 'security breach':
        return Icons.shield;
      case 'motion detection':
        return Icons.motion_photos_on;
      case 'equipment tampering':
        return Icons.build;
      default:
        return Icons.notification_important;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final severity = alert['severity'] as String;
    final severityColor = _getSeverityColor(severity);
    final alertType = alert['type'] as String;
    final typeIcon = _getAlertTypeIcon(alertType);
    final timestamp = alert['timestamp'] as DateTime;
    final description = alert['description'] as String;
    final location = alert['location'] as String;
    final thumbnail = alert['thumbnail'] as String;
    final status = alert['status'] as String;
    final aiConfidence = alert['aiConfidence'] as double;
    final resolved = alert['resolved'] as bool;

    return Dismissible(
      key: Key(alert['id'] as String),
      background: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppTheme.successColor,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 4.h),
            Text(
              'Resolve',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppTheme.neutralMedium,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'archive',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 4.h),
            Text(
              'Archive',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onSwipeRight(alert['id'] as String);
        } else {
          onSwipeLeft(alert['id'] as String);
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.accentColor.withValues(alpha: 0.1)
                : AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: AppTheme.accentColor, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: thumbnail,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          // Alert type icon
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: severityColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              typeIcon,
                              color: severityColor,
                              size: 16,
                            ),
                          ),
                          SizedBox(width: 8.w),

                          // Alert type
                          Expanded(
                            child: Text(
                              alertType,
                              style: TextStyle(
                                color: AppTheme.textHighEmphasisLight,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Timestamp
                          Text(
                            _formatTimestamp(timestamp),
                            style: TextStyle(
                              color: AppTheme.textMediumEmphasisLight,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Description
                      Text(
                        description,
                        style: TextStyle(
                          color: AppTheme.textHighEmphasisLight,
                          fontSize: 13.sp,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),

                      // Location and status row
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: AppTheme.textMediumEmphasisLight,
                            size: 14,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                color: AppTheme.textMediumEmphasisLight,
                                fontSize: 12.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Status badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: resolved
                                  ? AppTheme.successColor.withValues(alpha: 0.1)
                                  : severityColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: resolved
                                    ? AppTheme.successColor
                                    : severityColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // AI confidence and severity
                      Row(
                        children: [
                          // AI confidence
                          CustomIconWidget(
                            iconName: 'psychology',
                            color: AppTheme.dataVisualizationColor,
                            size: 14,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'AI: ${(aiConfidence * 100).toInt()}%',
                            style: TextStyle(
                              color: AppTheme.dataVisualizationColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const Spacer(),

                          // Severity indicator
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: severityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            severity,
                            style: TextStyle(
                              color: severityColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Multi-select checkbox
                if (isMultiSelectMode)
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (_) => onTap(),
                      activeColor: AppTheme.accentColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
