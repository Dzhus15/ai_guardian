import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class CameraSettingsBottomSheet extends StatefulWidget {
  final Map<String, dynamic> camera;
  final Function(Map<String, dynamic>) onSettingsChanged;

  const CameraSettingsBottomSheet({
    super.key,
    required this.camera,
    required this.onSettingsChanged,
  });

  @override
  State<CameraSettingsBottomSheet> createState() =>
      _CameraSettingsBottomSheetState();
}

class _CameraSettingsBottomSheetState extends State<CameraSettingsBottomSheet> {
  late Map<String, dynamic> _cameraSettings;
  late double _motionSensitivity;
  late bool _nightVision;

  @override
  void initState() {
    super.initState();
    _cameraSettings = Map.from(widget.camera);
    _motionSensitivity = (_cameraSettings['motionSensitivity'] as double);
    _nightVision = _cameraSettings['nightVision'] as bool;
  }

  void _saveSettings() {
    _cameraSettings['motionSensitivity'] = _motionSensitivity;
    _cameraSettings['nightVision'] = _nightVision;
    widget.onSettingsChanged(_cameraSettings);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.neutralMedium,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quick Settings',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Camera info
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomImageWidget(
                              imageUrl: _cameraSettings['thumbnail'] as String,
                              width: 15.w,
                              height: 15.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _cameraSettings['name'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'ID: ${_cameraSettings['id']}',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Resolution setting
                  _buildSettingSection(
                    title: 'Resolution',
                    child: DropdownButtonFormField<String>(
                      value: _cameraSettings['resolution'] as String,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: ['720p', '1080p', '4K'].map((resolution) {
                        return DropdownMenuItem(
                          value: resolution,
                          child: Text(resolution),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _cameraSettings['resolution'] = value;
                          });
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Frame rate setting
                  _buildSettingSection(
                    title: 'Frame Rate',
                    child: DropdownButtonFormField<int>(
                      value: _cameraSettings['frameRate'] as int,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: [24, 30, 60].map((frameRate) {
                        return DropdownMenuItem(
                          value: frameRate,
                          child: Text('$frameRate fps'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _cameraSettings['frameRate'] = value;
                          });
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Night vision toggle
                  _buildSettingSection(
                    title: 'Night Vision',
                    child: SwitchListTile(
                      value: _nightVision,
                      onChanged: (value) {
                        setState(() {
                          _nightVision = value;
                        });
                      },
                      title: Text(
                        _nightVision ? 'Enabled' : 'Disabled',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Motion sensitivity slider
                  _buildSettingSection(
                    title: 'Motion Sensitivity',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Low',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                            Text(
                              'High',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Slider(
                          value: _motionSensitivity,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          label: '${(_motionSensitivity * 100).round()}%',
                          onChanged: (value) {
                            setState(() {
                              _motionSensitivity = value;
                            });
                          },
                        ),
                        Center(
                          child: Text(
                            '${(_motionSensitivity * 100).round()}%',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveSettings,
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        child,
      ],
    );
  }
}