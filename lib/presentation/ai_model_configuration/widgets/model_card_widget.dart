import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class ModelCardWidget extends StatelessWidget {
  final Map<String, dynamic> model;
  final String categoryId;
  final Function(String, String, bool) onToggleModel;
  final Function(String, String, String, dynamic) onUpdateParameter;
  final VoidCallback onShowDetails;

  const ModelCardWidget({
    super.key,
    required this.model,
    required this.categoryId,
    required this.onToggleModel,
    required this.onUpdateParameter,
    required this.onShowDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = model["isEnabled"] as bool;
    final accuracy = model["accuracy"] as double;
    final processingSpeed = model["processingSpeed"] as double;
    final resourceUsage = model["resourceUsage"] as double;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isEnabled
              ? AppTheme.accentColor.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(12),
        color: isEnabled
            ? AppTheme.accentColor.withValues(alpha: 0.05)
            : AppTheme.lightTheme.colorScheme.surface,
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isEnabled
                    ? AppTheme.accentColor.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: _getModelIcon(model["id"]),
                color: isEnabled
                    ? AppTheme.accentColor
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            title: Text(
              model["name"],
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: isEnabled ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            subtitle: Text(
              model["description"],
              style: AppTheme.lightTheme.textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Switch(
              value: isEnabled,
              onChanged: (value) =>
                  onToggleModel(categoryId, model["id"], value),
            ),
            onTap: onShowDetails,
            onLongPress: () => _showContextMenu(context),
          ),
          if (isEnabled) ...[
            Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricIndicator(
                          'Accuracy',
                          accuracy,
                          AppTheme.successColor,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricIndicator(
                          'Speed',
                          processingSpeed,
                          AppTheme.dataVisualizationColor,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricIndicator(
                          'Usage',
                          resourceUsage,
                          AppTheme.warningColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildSensitivitySlider(context),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricIndicator(String label, double value, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: value / 100,
                strokeWidth: 4,
                backgroundColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              '${value.toInt()}%',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildSensitivitySlider(BuildContext context) {
    final confidenceThreshold = model["confidenceThreshold"] as double;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sensitivity',
              style: AppTheme.lightTheme.textTheme.labelMedium,
            ),
            Text(
              '${(confidenceThreshold * 100).toInt()}%',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: confidenceThreshold,
            min: 0.5,
            max: 1.0,
            divisions: 10,
            onChanged: (value) => onUpdateParameter(
              categoryId,
              model["id"],
              "confidenceThreshold",
              value,
            ),
          ),
        ),
      ],
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'restore',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Reset to Default'),
              onTap: () {
                Navigator.pop(context);
                // Reset model to default
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'file_download',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Export Configuration'),
              onTap: () {
                Navigator.pop(context);
                // Export configuration
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'dataset',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('View Training Data'),
              onTap: () {
                Navigator.pop(context);
                // View training data
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getModelIcon(String modelId) {
    switch (modelId) {
      case 'intrusion_detection':
        return 'security';
      case 'object_recognition':
        return 'category';
      case 'face_detection':
        return 'face';
      case 'inappropriate_language':
        return 'record_voice_over';
      case 'sound_classification':
        return 'graphic_eq';
      case 'activity_recognition':
        return 'directions_walk';
      case 'anomaly_detection':
        return 'warning';
      case 'custom_safety_model':
        return 'health_and_safety';
      default:
        return 'smart_toy';
    }
  }
}