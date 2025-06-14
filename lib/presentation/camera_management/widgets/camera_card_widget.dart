import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class CameraCardWidget extends StatelessWidget {
  final Map<String, dynamic> camera;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback onQuickSettings;
  final VoidCallback onRemove;
  final VoidCallback onViewLive;
  final VoidCallback onConfigure;
  final VoidCallback onTestConnection;

  const CameraCardWidget({
    super.key,
    required this.camera,
    required this.isSelected,
    required this.isMultiSelectMode,
    required this.onQuickSettings,
    required this.onRemove,
    required this.onViewLive,
    required this.onConfigure,
    required this.onTestConnection,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return AppTheme.successColor;
      case 'offline':
        return AppTheme.errorColor;
      case 'processing':
        return AppTheme.dataVisualizationColor;
      default:
        return AppTheme.neutralMedium;
    }
  }

  Widget _buildBatteryIndicator() {
    final batteryLevel = camera['batteryLevel'] as int?;
    if (batteryLevel == null) return const SizedBox.shrink();

    Color batteryColor;
    if (batteryLevel > 50) {
      batteryColor = AppTheme.successColor;
    } else if (batteryLevel > 20) {
      batteryColor = AppTheme.warningColor;
    } else {
      batteryColor = AppTheme.errorColor;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: batteryLevel > 20 ? 'battery_std' : 'battery_alert',
          color: batteryColor,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          '$batteryLevel%',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: batteryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(camera['id'] as String),
      direction: DismissDirection.horizontal,
      background: Container(
        decoration: BoxDecoration(
          color: AppTheme.successColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'visibility',
              color: AppTheme.successColor,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              'View Live',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.successColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.errorColor,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              'Remove',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.errorColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onViewLive();
          return false;
        } else {
          onRemove();
          return false;
        }
      },
      child: Card(
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(color: AppTheme.accentColor, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onQuickSettings,
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with selection indicator and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isMultiSelectMode)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppTheme.accentColor
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.accentColor
                                : AppTheme.neutralMedium,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 12,
                              )
                            : null,
                      )
                    else
                      const SizedBox(width: 20),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(camera['status'] as String)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getStatusColor(camera['status'] as String),
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            (camera['status'] as String).toUpperCase(),
                            style:
                                AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              color: _getStatusColor(camera['status'] as String),
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Camera thumbnail
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppTheme.neutralLight,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: camera['thumbnail'] as String,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Camera name
                Text(
                  camera['name'] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 1.h),

                // Battery and wireless indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBatteryIndicator(),
                    if (camera['isWireless'] as bool)
                      CustomIconWidget(
                        iconName: 'wifi',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                  ],
                ),

                SizedBox(height: 1.h),

                // Last activity
                Text(
                  'Last activity: ${camera['lastActivity']}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}