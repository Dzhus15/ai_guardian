import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/model_category_section_widget.dart';
import './widgets/model_configuration_card_widget.dart';
import './widgets/model_performance_widget.dart';

class AiModelConfiguration extends StatefulWidget {
  const AiModelConfiguration({super.key});

  @override
  State<AiModelConfiguration> createState() => _AiModelConfigurationState();
}

class _AiModelConfigurationState extends State<AiModelConfiguration>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String _loadingMessage = '';

  // Mock data for AI models
  final List<Map<String, dynamic>> _modelCategories = [
    {
      "id": "computer_vision",
      "name": "Computer Vision",
      "description": "Object detection and image analysis models",
      "isExpanded": true,
      "models": [
        {
          "id": "intrusion_detection",
          "name": "Intrusion Detection",
          "description": "Detects unauthorized personnel in restricted areas",
          "isEnabled": true,
          "accuracy": 94.5,
          "processingSpeed": 87.2,
          "resourceUsage": 65.8,
          "confidenceThreshold": 0.85,
          "detectionZones": ["Zone A", "Zone B", "Zone C"],
          "processingInterval": 500,
        },
        {
          "id": "object_recognition",
          "name": "Object Recognition",
          "description": "Identifies and classifies objects in video streams",
          "isEnabled": true,
          "accuracy": 91.3,
          "processingSpeed": 92.1,
          "resourceUsage": 58.4,
          "confidenceThreshold": 0.80,
          "detectionZones": ["All Zones"],
          "processingInterval": 300,
        },
        {
          "id": "face_detection",
          "name": "Face Detection",
          "description": "Detects and tracks human faces in real-time",
          "isEnabled": false,
          "accuracy": 96.7,
          "processingSpeed": 78.9,
          "resourceUsage": 72.3,
          "confidenceThreshold": 0.90,
          "detectionZones": ["Entry Points"],
          "processingInterval": 200,
        },
      ]
    },
    {
      "id": "audio_analysis",
      "name": "Audio Analysis",
      "description": "Sound pattern recognition and audio processing",
      "isExpanded": false,
      "models": [
        {
          "id": "inappropriate_language",
          "name": "Inappropriate Language Detection",
          "description":
              "Identifies offensive or inappropriate speech patterns",
          "isEnabled": true,
          "accuracy": 88.9,
          "processingSpeed": 95.4,
          "resourceUsage": 42.1,
          "confidenceThreshold": 0.75,
          "detectionZones": ["All Areas"],
          "processingInterval": 1000,
        },
        {
          "id": "sound_classification",
          "name": "Sound Classification",
          "description": "Classifies environmental sounds and alerts",
          "isEnabled": true,
          "accuracy": 85.6,
          "processingSpeed": 89.7,
          "resourceUsage": 38.9,
          "confidenceThreshold": 0.70,
          "detectionZones": ["Production Floor"],
          "processingInterval": 800,
        },
      ]
    },
    {
      "id": "behavioral_detection",
      "name": "Behavioral Detection",
      "description": "Human behavior analysis and pattern recognition",
      "isExpanded": false,
      "models": [
        {
          "id": "activity_recognition",
          "name": "Activity Recognition",
          "description": "Monitors and classifies human activities",
          "isEnabled": true,
          "accuracy": 89.2,
          "processingSpeed": 83.5,
          "resourceUsage": 69.7,
          "confidenceThreshold": 0.82,
          "detectionZones": ["Workspace Areas"],
          "processingInterval": 600,
        },
        {
          "id": "anomaly_detection",
          "name": "Anomaly Detection",
          "description": "Identifies unusual behavior patterns",
          "isEnabled": false,
          "accuracy": 92.8,
          "processingSpeed": 76.3,
          "resourceUsage": 74.2,
          "confidenceThreshold": 0.88,
          "detectionZones": ["All Zones"],
          "processingInterval": 400,
        },
      ]
    },
    {
      "id": "custom_models",
      "name": "Custom Models",
      "description": "User-uploaded and custom-trained AI models",
      "isExpanded": false,
      "models": [
        {
          "id": "custom_safety_model",
          "name": "Safety Compliance Model",
          "description": "Custom model for safety equipment detection",
          "isEnabled": true,
          "accuracy": 87.4,
          "processingSpeed": 81.2,
          "resourceUsage": 56.8,
          "confidenceThreshold": 0.78,
          "detectionZones": ["Safety Zones"],
          "processingInterval": 700,
        },
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAdvancedOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAdvancedOptionsBottomSheet(),
    );
  }

  void _showModelTestDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildModelTestDialog(),
    );
  }

  void _showWarningDialog(
      String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _toggleModel(String categoryId, String modelId, bool value) {
    setState(() {
      final category =
          _modelCategories.firstWhere((cat) => cat["id"] == categoryId);
      final model = (category["models"] as List)
          .firstWhere((mod) => mod["id"] == modelId);
      model["isEnabled"] = value;
    });

    if (value) {
      _showWarningDialog(
        'Enable AI Model',
        'Enabling this model may affect system performance. Continue?',
        () {
          // Model enabled
        },
      );
    }
  }

  void _updateModelParameter(
      String categoryId, String modelId, String parameter, dynamic value) {
    setState(() {
      final category =
          _modelCategories.firstWhere((cat) => cat["id"] == categoryId);
      final model = (category["models"] as List)
          .firstWhere((mod) => mod["id"] == modelId);
      model[parameter] = value;
    });
  }

  void _expandCategory(String categoryId) {
    setState(() {
      final category =
          _modelCategories.firstWhere((cat) => cat["id"] == categoryId);
      category["isExpanded"] = !category["isExpanded"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'AI Model Configuration',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showAdvancedOptions,
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Models'),
            Tab(text: 'Performance'),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildModelsTab(),
                _buildPerformanceTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showModelTestDialog,
        backgroundColor: AppTheme.accentColor,
        child: CustomIconWidget(
          iconName: 'play_arrow',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.accentColor,
          ),
          SizedBox(height: 16),
          Text(
            _loadingMessage.isEmpty
                ? 'Initializing AI Models...'
                : _loadingMessage,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Estimated completion: 2-3 minutes',
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildModelsTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configure AI detection algorithms and processing parameters',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24),
            ..._modelCategories.map((category) => ModelCategorySectionWidget(
                  category: category,
                  onToggleExpansion: () => _expandCategory(category["id"]),
                  onToggleModel: _toggleModel,
                  onUpdateParameter: _updateModelParameter,
                  onShowModelDetails: _showModelDetails,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monitor AI model performance and resource usage',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24),
            ModelPerformanceWidget(
              categories: _modelCategories,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedOptionsBottomSheet() {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Advanced Options',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
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
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildAdvancedOptionTile(
                  'Model Training Data Upload',
                  'Upload custom training datasets',
                  'cloud_upload',
                  () {},
                ),
                _buildAdvancedOptionTile(
                  'Custom Algorithm Integration',
                  'Integrate third-party AI algorithms',
                  'integration_instructions',
                  () {},
                ),
                _buildAdvancedOptionTile(
                  'Performance Optimization',
                  'Optimize models for device performance',
                  'tune',
                  () {},
                ),
                _buildAdvancedOptionTile(
                  'Backup Configuration',
                  'Create backup of current settings',
                  'backup',
                  () {},
                ),
                _buildAdvancedOptionTile(
                  'Reset All Models',
                  'Reset all models to default settings',
                  'restore',
                  () => _showWarningDialog(
                    'Reset All Models',
                    'This will reset all AI models to their default configurations. This action cannot be undone.',
                    () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedOptionTile(
      String title, String subtitle, String iconName, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CustomIconWidget(
          iconName: iconName,
          color: AppTheme.accentColor,
          size: 24,
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildModelTestDialog() {
    return AlertDialog(
      title: Text('Test AI Models'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Upload sample media to test AI model performance'),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _startModelTest('image');
                },
                icon: CustomIconWidget(
                  iconName: 'image',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text('Image'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _startModelTest('video');
                },
                icon: CustomIconWidget(
                  iconName: 'videocam',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text('Video'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );
  }

  void _startModelTest(String mediaType) {
    setState(() {
      _isLoading = true;
      _loadingMessage = 'Processing $mediaType with AI models...';
    });

    // Simulate model testing
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
        _loadingMessage = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Model test completed successfully'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    });
  }

  void _showModelDetails(Map<String, dynamic> model) {
    showDialog(
      context: context,
      builder: (context) => ModelConfigurationCard(
        model: model,
        onUpdateParameter: (parameter, value) {
          // Find the category and update the model
          for (var category in _modelCategories) {
            final models = category["models"] as List;
            final modelIndex = models.indexWhere((m) => m["id"] == model["id"]);
            if (modelIndex != -1) {
              _updateModelParameter(
                  category["id"], model["id"], parameter, value);
              break;
            }
          }
        },
      ),
    );
  }
}
