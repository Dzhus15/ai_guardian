import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/ai_analysis_card_widget.dart';
import './widgets/ai_insights_bottom_sheet.dart';
import './widgets/camera_selector_widget.dart';
import './widgets/live_video_feed_widget.dart';
import './widgets/status_bar_widget.dart';

class LiveMonitoringDashboard extends StatefulWidget {
  const LiveMonitoringDashboard({super.key});

  @override
  State<LiveMonitoringDashboard> createState() =>
      _LiveMonitoringDashboardState();
}

class _LiveMonitoringDashboardState extends State<LiveMonitoringDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRecording = false;
  bool _isConnected = true;
  String _selectedCamera = 'Camera 1';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Mock data for AI analysis
  final List<Map<String, dynamic>> _aiAnalysisData = [
    {
      "id": 1,
      "type": "Person Detection",
      "confidence": 0.95,
      "severity": "low",
      "timestamp": "2024-01-15 14:30:25",
      "description": "Person detected in authorized area",
      "location": "Main Entrance",
      "color": "success"
    },
    {
      "id": 2,
      "type": "Motion Alert",
      "confidence": 0.87,
      "severity": "medium",
      "timestamp": "2024-01-15 14:28:15",
      "description": "Unusual movement pattern detected",
      "location": "Parking Lot",
      "color": "warning"
    },
    {
      "id": 3,
      "type": "Intrusion Detection",
      "confidence": 0.92,
      "severity": "high",
      "timestamp": "2024-01-15 14:25:10",
      "description": "Unauthorized access attempt",
      "location": "Restricted Zone",
      "color": "error"
    },
    {
      "id": 4,
      "type": "Audio Analysis",
      "confidence": 0.78,
      "severity": "medium",
      "timestamp": "2024-01-15 14:22:45",
      "description": "Elevated noise levels detected",
      "location": "Office Area",
      "color": "warning"
    }
  ];

  final List<String> _cameras = [
    'Camera 1 - Main Entrance',
    'Camera 2 - Parking Lot',
    'Camera 3 - Office Area',
    'Camera 4 - Restricted Zone'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAIInsights() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AIInsightsBottomSheet(
        analysisData: _aiAnalysisData,
      ),
    );
  }

  void _capturePhoto() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Photo captured successfully'),
        backgroundColor: AppTheme.successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showVideoContextMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'videocam',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              onTap: () {
                setState(() {
                  _isRecording = !_isRecording;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Take Snapshot'),
              onTap: () {
                Navigator.pop(context);
                _capturePhoto();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'switch_camera',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Switch Camera'),
              onTap: () {
                Navigator.pop(context);
                // Switch camera logic
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'fullscreen',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Full Screen'),
              onTap: () {
                Navigator.pop(context);
                // Full screen logic
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshConnection() async {
    setState(() {
      _isConnected = false;
    });

    // Simulate reconnection
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isConnected = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Camera connection refreshed'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('AI Guardian'),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Emergency alert sent!'),
                  backgroundColor: AppTheme.errorColor,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'emergency',
              color: AppTheme.errorColor,
              size: 24,
            ),
          ),
          SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'monitor',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              text: 'Monitor',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
              text: 'History',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
              text: 'Alerts',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
              text: 'Settings',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMonitorTab(),
          _buildHistoryTab(),
          _buildAlertsTab(),
          _buildSettingsTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _capturePhoto,
              backgroundColor: AppTheme.accentColor,
              child: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            )
          : null,
    );
  }

  Widget _buildMonitorTab() {
    return RefreshIndicator(
      onRefresh: _refreshConnection,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Status Bar
            StatusBarWidget(
              isConnected: _isConnected,
              activeCameraCount: 4,
              connectionQuality: 'Excellent',
            ),

            // Camera Selector
            CameraSelectorWidget(
              cameras: _cameras,
              selectedCamera: _selectedCamera,
              onCameraChanged: (camera) {
                setState(() {
                  _selectedCamera = camera;
                });
              },
            ),

            // Live Video Feed
            Padding(
              padding: EdgeInsets.all(16),
              child: LiveVideoFeedWidget(
                isConnected: _isConnected,
                isRecording: _isRecording,
                selectedCamera: _selectedCamera,
                onLongPress: _showVideoContextMenu,
              ),
            ),

            // AI Analysis Cards
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: _aiAnalysisData.length,
                itemBuilder: (context, index) {
                  final analysis = _aiAnalysisData[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: AIAnalysisCardWidget(
                      type: analysis['type'] as String,
                      confidence: analysis['confidence'] as double,
                      severity: analysis['severity'] as String,
                      timestamp: analysis['timestamp'] as String,
                      description: analysis['description'] as String,
                      location: analysis['location'] as String,
                      onTap: _showAIInsights,
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.5),
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'History View',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 8),
          Text(
            'View recorded footage and past events',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/alert-history');
            },
            child: Text('View Alert History'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'warning',
            color: AppTheme.warningColor,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'Active Alerts',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 8),
          Text(
            'Monitor real-time security alerts',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/ai-analysis-results');
            },
            child: Text('View Analysis Results'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.5),
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'Settings',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 8),
          Text(
            'Configure cameras and AI models',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 24),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/camera-management');
                },
                child: Text('Camera Management'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ai-model-configuration');
                },
                child: Text('AI Model Configuration'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
