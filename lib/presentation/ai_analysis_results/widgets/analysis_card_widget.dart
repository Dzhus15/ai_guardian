import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import './confidence_indicator_widget.dart';
import './detection_thumbnail_widget.dart';

class AnalysisCardWidget extends StatefulWidget {
  final Map<String, dynamic> analysis;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onFlag;
  final Function(String) onAddNote;
  final VoidCallback onExport;

  const AnalysisCardWidget({
    super.key,
    required this.analysis,
    required this.onTap,
    required this.onLongPress,
    required this.onFlag,
    required this.onAddNote,
    required this.onExport,
  });

  @override
  State<AnalysisCardWidget> createState() => _AnalysisCardWidgetState();
}

class _AnalysisCardWidgetState extends State<AnalysisCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _noteController.text = widget.analysis['notes'] ?? '';
  }

  @override
  void dispose() {
    _animationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
        return AppTheme.errorColor;
      case 'warning':
        return AppTheme.warningColor;
      case 'success':
        return AppTheme.successColor;
      default:
        return AppTheme.dataVisualizationColor;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'intrusion_detection':
        return Icons.security;
      case 'behavior_analysis':
        return Icons.psychology;
      case 'audio_monitoring':
        return Icons.hearing;
      case 'object_recognition':
        return Icons.visibility;
      default:
        return Icons.analytics;
    }
  }

  void _showQuickActions() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: widget.analysis['flagged'] ? 'flag' : 'outlined_flag',
                color: widget.analysis['flagged']
                    ? AppTheme.errorColor
                    : AppTheme.accentColor,
                size: 24,
              ),
              title: Text(widget.analysis['flagged']
                  ? 'Remove Flag'
                  : 'Flag as Important'),
              onTap: () {
                Navigator.pop(context);
                widget.onFlag();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'note_add',
                color: AppTheme.dataVisualizationColor,
                size: 24,
              ),
              title: Text('Add Note'),
              onTap: () {
                Navigator.pop(context);
                _showAddNoteDialog();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'file_download',
                color: AppTheme.successColor,
                size: 24,
              ),
              title: Text('Export Evidence'),
              onTap: () {
                Navigator.pop(context);
                widget.onExport();
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Note'),
        content: TextField(
          controller: _noteController,
          decoration: InputDecoration(
            hintText: 'Enter your note...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onAddNote(_noteController.text);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(widget.analysis['status']);
    final typeIcon = _getTypeIcon(widget.analysis['type']);
    final confidence = widget.analysis['confidence'] as double;

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Dismissible(
        key: Key(widget.analysis['id']),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: 'more_horiz',
            color: Colors.white,
            size: 24,
          ),
        ),
        confirmDismiss: (direction) async {
          _showQuickActions();
          return false;
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        DetectionThumbnailWidget(
                          imageUrl: widget.analysis['thumbnailUrl'],
                          detectedElements: widget.analysis['detectedElements'],
                          size: 60,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: typeIcon.codePoint.toString(),
                                    color: statusColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      widget.analysis['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (widget.analysis['flagged'])
                                    CustomIconWidget(
                                      iconName: 'flag',
                                      color: AppTheme.errorColor,
                                      size: 16,
                                    ),
                                  if (widget.analysis['reviewed'])
                                    Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: CustomIconWidget(
                                        iconName: 'check_circle',
                                        color: AppTheme.successColor,
                                        size: 16,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.analysis['cameraLocation'],
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.analysis['timestamp'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            ConfidenceIndicatorWidget(
                              confidence: confidence,
                              size: 40,
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: _toggleExpanded,
                              child: CustomIconWidget(
                                iconName:
                                    _isExpanded ? 'expand_less' : 'expand_more',
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Description
                    Text(
                      widget.analysis['description'],
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Status Badge
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.analysis['status'].toString().toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              // Expandable Details
              SizeTransition(
                sizeFactor: _expandAnimation,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.5),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 1),
                      SizedBox(height: 12),

                      Text(
                        'Detailed Analysis',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.analysis['details'],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      SizedBox(height: 12),

                      // Detected Elements
                      Text(
                        'Detected Elements',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 8),

                      ...((widget.analysis['detectedElements'] as List)
                          .map((element) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppTheme.accentColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${element['type']} (${element['confidence'].toStringAsFixed(1)}%)',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList()),

                      if (widget.analysis['notes']?.isNotEmpty == true) ...[
                        SizedBox(height: 12),
                        Text(
                          'Notes',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.dataVisualizationColor
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.analysis['notes'],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
