import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/analysis_card_widget.dart';

class AiAnalysisResults extends StatefulWidget {
  const AiAnalysisResults({super.key});

  @override
  State<AiAnalysisResults> createState() => _AiAnalysisResultsState();
}

class _AiAnalysisResultsState extends State<AiAnalysisResults> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  final bool _isOffline = false;
  final String _selectedAnalysisId = '';

  // Mock analysis data
  final List<Map<String, dynamic>> _analysisData = [
    {
      "id": "analysis_001",
      "timestamp": "2024-01-15 14:30:25",
      "cameraLocation": "Main Entrance - Camera 01",
      "type": "intrusion_detection",
      "title": "Intrusion Detection",
      "confidence": 94.5,
      "status": "critical",
      "description": "Unauthorized person detected in restricted area",
      "thumbnailUrl":
          "https://images.pexels.com/photos/2899097/pexels-photo-2899097.jpeg?auto=compress&cs=tinysrgb&w=400",
      "detectedElements": [
        {
          "type": "person",
          "confidence": 94.5,
          "bbox": [120, 80, 200, 300]
        },
        {
          "type": "restricted_area",
          "confidence": 98.2,
          "bbox": [50, 50, 350, 400]
        }
      ],
      "details":
          "Person detected entering restricted zone at 14:30. No authorized access card detected. Security protocol activated.",
      "flagged": false,
      "reviewed": false,
      "notes": ""
    },
    {
      "id": "analysis_002",
      "timestamp": "2024-01-15 14:25:12",
      "cameraLocation": "Office Floor 2 - Camera 03",
      "type": "behavior_analysis",
      "title": "Behavior Analysis",
      "confidence": 87.3,
      "status": "warning",
      "description": "Unusual behavior pattern detected",
      "thumbnailUrl":
          "https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "detectedElements": [
        {
          "type": "person",
          "confidence": 87.3,
          "bbox": [100, 60, 180, 280]
        },
        {
          "type": "unusual_movement",
          "confidence": 82.1,
          "bbox": [90, 50, 190, 290]
        }
      ],
      "details":
          "Employee showing signs of distress or unusual movement patterns. Recommended for wellness check.",
      "flagged": true,
      "reviewed": false,
      "notes": "Flagged for HR review"
    },
    {
      "id": "analysis_003",
      "timestamp": "2024-01-15 14:20:45",
      "cameraLocation": "Conference Room A - Audio Monitor",
      "type": "audio_monitoring",
      "title": "Audio Analysis",
      "confidence": 76.8,
      "status": "warning",
      "description": "Inappropriate language detected",
      "thumbnailUrl":
          "https://images.pexels.com/photos/3184338/pexels-photo-3184338.jpeg?auto=compress&cs=tinysrgb&w=400",
      "detectedElements": [
        {
          "type": "inappropriate_language",
          "confidence": 76.8,
          "bbox": [0, 0, 0, 0]
        },
        {
          "type": "voice_stress",
          "confidence": 68.4,
          "bbox": [0, 0, 0, 0]
        }
      ],
      "details":
          "Audio analysis detected inappropriate language and elevated stress levels in conversation.",
      "flagged": false,
      "reviewed": true,
      "notes": ""
    },
    {
      "id": "analysis_004",
      "timestamp": "2024-01-15 14:15:30",
      "cameraLocation": "Parking Lot - Camera 05",
      "type": "object_recognition",
      "title": "Object Recognition",
      "confidence": 91.2,
      "status": "success",
      "description": "Vehicle license plate captured",
      "thumbnailUrl":
          "https://images.pexels.com/photos/1545743/pexels-photo-1545743.jpeg?auto=compress&cs=tinysrgb&w=400",
      "detectedElements": [
        {
          "type": "vehicle",
          "confidence": 95.7,
          "bbox": [80, 120, 320, 280]
        },
        {
          "type": "license_plate",
          "confidence": 91.2,
          "bbox": [180, 220, 220, 240]
        }
      ],
      "details":
          "Vehicle ABC-123 detected entering parking area. License plate successfully captured and logged.",
      "flagged": false,
      "reviewed": true,
      "notes": "Authorized vehicle"
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadAnalysisData();
  }

  Future<void> _loadAnalysisData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _shareReport() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Analysis report shared successfully'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _generateReport() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating comprehensive report...'),
        backgroundColor: AppTheme.dataVisualizationColor,
      ),
    );
  }

  void _markReviewed() {
    HapticFeedback.lightImpact();
    setState(() {
      for (var analysis in _analysisData) {
        analysis['reviewed'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All analyses marked as reviewed'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _createAlertRule() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, '/ai-model-configuration');
  }

  void _flagAnalysis(String analysisId) {
    HapticFeedback.lightImpact();
    setState(() {
      final analysis =
          _analysisData.firstWhere((item) => item['id'] == analysisId);
      analysis['flagged'] = !analysis['flagged'];
    });
  }

  void _addNote(String analysisId, String note) {
    setState(() {
      final analysis =
          _analysisData.firstWhere((item) => item['id'] == analysisId);
      analysis['notes'] = note;
    });
  }

  void _exportEvidence(String analysisId) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Evidence exported successfully'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _viewFullScreen(Map<String, dynamic> analysis) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenMediaView(analysis: analysis),
      ),
    );
  }

  void _showContextMenu(Map<String, dynamic> analysis) {
    HapticFeedback.heavyImpact();
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
                iconName: 'model_training',
                color: AppTheme.dataVisualizationColor,
                size: 24,
              ),
              title: Text('Train AI Model'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/ai-model-configuration');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report_problem',
                color: AppTheme.warningColor,
                size: 24,
              ),
              title: Text('Report False Positive'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('False positive reported for model improvement'),
                    backgroundColor: AppTheme.warningColor,
                  ),
                );
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: CustomIconWidget(
                          iconName: 'arrow_back',
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Analysis Results',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              'January 15, 2024 • 14:15 - 14:30',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (_isOffline)
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.warningColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'cloud_off',
                                color: AppTheme.warningColor,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Offline',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppTheme.warningColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: _shareReport,
                        child: CustomIconWidget(
                          iconName: 'share',
                          color: AppTheme.accentColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : RefreshIndicator(
                      onRefresh: _loadAnalysisData,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(16),
                        itemCount: _analysisData.length,
                        itemBuilder: (context, index) {
                          final analysis = _analysisData[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: AnalysisCardWidget(
                              analysis: analysis,
                              onTap: () => _viewFullScreen(analysis),
                              onLongPress: () => _showContextMenu(analysis),
                              onFlag: () => _flagAnalysis(analysis['id']),
                              onAddNote: (note) =>
                                  _addNote(analysis['id'], note),
                              onExport: () => _exportEvidence(analysis['id']),
                            ),
                          );
                        },
                      ),
                    ),
            ),

            // Bottom Toolbar
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _generateReport,
                      icon: CustomIconWidget(
                        iconName: 'description',
                        color: AppTheme.accentColor,
                        size: 20,
                      ),
                      label: Text('Generate Report'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _markReviewed,
                      icon: CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.successColor,
                        size: 20,
                      ),
                      label: Text('Mark Reviewed'),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _createAlertRule,
                    icon: CustomIconWidget(
                      iconName: 'add_alert',
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text('Alert Rule'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 150,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 12,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FullScreenMediaView extends StatelessWidget {
  final Map<String, dynamic> analysis;

  const _FullScreenMediaView({required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.8),
        foregroundColor: Colors.white,
        title: Text(analysis['title']),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Media exported successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'download',
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            CustomImageWidget(
              imageUrl: analysis['thumbnailUrl'],
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),
            // Bounding box overlays
            ...((analysis['detectedElements'] as List).map((element) {
              final bbox = element['bbox'] as List;
              if (bbox.every((coord) => coord == 0)) return SizedBox.shrink();

              return Positioned(
                left: bbox[0].toDouble(),
                top: bbox[1].toDouble(),
                width: (bbox[2] - bbox[0]).toDouble(),
                height: (bbox[3] - bbox[1]).toDouble(),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.accentColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        '${element['type']} ${element['confidence'].toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }
}
