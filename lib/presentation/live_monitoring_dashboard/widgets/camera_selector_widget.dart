import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CameraSelectorWidget extends StatelessWidget {
  final List<String> cameras;
  final String selectedCamera;
  final Function(String) onCameraChanged;

  const CameraSelectorWidget({
    super.key,
    required this.cameras,
    required this.selectedCamera,
    required this.onCameraChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCamera,
                  isExpanded: true,
                  icon: CustomIconWidget(
                    iconName: 'keyboard_arrow_down',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 20,
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  items: cameras.map((String camera) {
                    return DropdownMenuItem<String>(
                      value: camera,
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'videocam',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              camera,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      onCameraChanged(newValue);
                    }
                  },
                ),
              ),
            ),
          ),

          SizedBox(width: 12),

          // Camera Settings Button
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () {
                // Show camera settings
                _showCameraSettings(context);
              },
              icon: CustomIconWidget(
                iconName: 'tune',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCameraSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Camera Settings',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'hd',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Video Quality'),
              subtitle: Text('1080p HD'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'brightness_6',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Brightness'),
              subtitle: Text('Auto'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'mic',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Audio Recording'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
