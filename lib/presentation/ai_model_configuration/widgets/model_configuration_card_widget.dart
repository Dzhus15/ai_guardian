import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ModelConfigurationCard extends StatefulWidget {
  final Map<String, dynamic> model;
  final Function(String, dynamic) onUpdateParameter;

  const ModelConfigurationCard({
    super.key,
    required this.model,
    required this.onUpdateParameter,
  });

  @override
  State<ModelConfigurationCard> createState() => _ModelConfigurationCardState();
}

class _ModelConfigurationCardState extends State<ModelConfigurationCard> {
  late double _confidenceThreshold;
  late int _processingInterval;
  late List<String> _selectedZones;

  @override
  void initState() {
    super.initState();
    _confidenceThreshold = widget.model["confidenceThreshold"] as double;
    _processingInterval = widget.model["processingInterval"] as int;
    _selectedZones = List<String>.from(widget.model["detectionZones"] as List);
  }

  final List<String> _availableZones = [
    "Zone A",
    "Zone B",
    "Zone C",
    "Entry Points",
    "Production Floor",
    "Safety Zones",
    "All Zones",
    "Workspace Areas"
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 90.w,
        height: 80.h,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildModelInfo(),
                    SizedBox(height: 24),
                    _buildConfidenceThresholdSection(),
                    SizedBox(height: 24),
                    _buildProcessingIntervalSection(),
                    SizedBox(height: 24),
                    _buildDetectionZonesSection(),
                    SizedBox(height: 24),
                    _buildAdvancedParametersSection(),
                  ],
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _getModelIcon(widget.model["id"]),
            color: AppTheme.accentColor,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.model["name"],
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                Text(
                  'Model Configuration',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
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
    );
  }

  Widget _buildModelInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Model Information',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            SizedBox(height: 12),
            Text(
              widget.model["description"],
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Accuracy',
                    '${(widget.model["accuracy"] as double).toInt()}%',
                    AppTheme.successColor,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Speed',
                    '${(widget.model["processingSpeed"] as double).toInt()}%',
                    AppTheme.dataVisualizationColor,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Usage',
                    '${(widget.model["resourceUsage"] as double).toInt()}%',
                    AppTheme.warningColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildConfidenceThresholdSection() {
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
                  'Confidence Threshold',
                  style: AppTheme.lightTheme.textTheme.titleSmall,
                ),
                Text(
                  '${(_confidenceThreshold * 100).toInt()}%',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Minimum confidence level required for detection alerts',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            SizedBox(height: 16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
              ),
              child: Slider(
                value: _confidenceThreshold,
                min: 0.5,
                max: 1.0,
                divisions: 10,
                onChanged: (value) {
                  setState(() => _confidenceThreshold = value);
                  widget.onUpdateParameter("confidenceThreshold", value);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('50%', style: AppTheme.lightTheme.textTheme.labelSmall),
                Text('100%', style: AppTheme.lightTheme.textTheme.labelSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingIntervalSection() {
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
                  'Processing Interval',
                  style: AppTheme.lightTheme.textTheme.titleSmall,
                ),
                Text(
                  '${_processingInterval}ms',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Time interval between processing frames',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            SizedBox(height: 16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
              ),
              child: Slider(
                value: _processingInterval.toDouble(),
                min: 100,
                max: 2000,
                divisions: 19,
                onChanged: (value) {
                  setState(() => _processingInterval = value.toInt());
                  widget.onUpdateParameter("processingInterval", value.toInt());
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('100ms', style: AppTheme.lightTheme.textTheme.labelSmall),
                Text('2000ms', style: AppTheme.lightTheme.textTheme.labelSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetectionZonesSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detection Zones',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            SizedBox(height: 8),
            Text(
              'Select areas where this model should be active',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _availableZones.map((zone) => _buildZoneChip(zone)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneChip(String zone) {
    final isSelected = _selectedZones.contains(zone);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedZones.remove(zone);
          } else {
            _selectedZones.add(zone);
          }
        });
        widget.onUpdateParameter("detectionZones", _selectedZones);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentColor
              : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentColor
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          zone,
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

  Widget _buildAdvancedParametersSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Parameters',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            SizedBox(height: 16),
            _buildParameterRow('Model Version', '2.1.4'),
            _buildParameterRow('Training Data', 'Updated 2 days ago'),
            _buildParameterRow('Optimization', 'GPU Accelerated'),
            _buildParameterRow('Memory Usage', '256 MB'),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Configuration saved successfully'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
              child: Text('Save Changes'),
            ),
          ),
        ],
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
