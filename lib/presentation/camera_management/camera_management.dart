import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_image_widget.dart';
import './widgets/add_camera_dialog.dart';
import './widgets/camera_card_widget.dart';
import './widgets/camera_settings_bottom_sheet.dart';
import 'widgets/add_camera_dialog.dart';
import 'widgets/camera_card_widget.dart';
import 'widgets/camera_settings_bottom_sheet.dart';

class CameraManagement extends StatefulWidget {
  const CameraManagement({super.key});

  @override
  State<CameraManagement> createState() => _CameraManagementState();
}

class _CameraManagementState extends State<CameraManagement>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _selectedCameras = [];
  bool _isMultiSelectMode = false;
  bool _isRefreshing = false;
  String _searchQuery = '';

  // Mock camera data
  final List<Map<String, dynamic>> _cameras = [
{ "id": "cam_001",
"name": "Front Entrance",
"status": "online",
"batteryLevel": 85,
"lastActivity": "2 minutes ago",
"isWireless": true,
"resolution": "1080p",
"frameRate": 30,
"nightVision": true,
"motionSensitivity": 0.7,
"thumbnail": "https://images.pexels.com/photos/2599244/pexels-photo-2599244.jpeg?auto=compress&cs=tinysrgb&w=400",
},
{ "id": "cam_002",
"name": "Office Main Hall",
"status": "online",
"batteryLevel": null,
"lastActivity": "5 minutes ago",
"isWireless": false,
"resolution": "4K",
"frameRate": 60,
"nightVision": false,
"motionSensitivity": 0.5,
"thumbnail": "https://images.pexels.com/photos/1181406/pexels-photo-1181406.jpeg?auto=compress&cs=tinysrgb&w=400",
},
{ "id": "cam_003",
"name": "Parking Area",
"status": "offline",
"batteryLevel": 23,
"lastActivity": "1 hour ago",
"isWireless": true,
"resolution": "720p",
"frameRate": 24,
"nightVision": true,
"motionSensitivity": 0.8,
"thumbnail": "https://images.pexels.com/photos/164634/pexels-photo-164634.jpeg?auto=compress&cs=tinysrgb&w=400",
},
{ "id": "cam_004",
"name": "Conference Room A",
"status": "online",
"batteryLevel": null,
"lastActivity": "Just now",
"isWireless": false,
"resolution": "1080p",
"frameRate": 30,
"nightVision": false,
"motionSensitivity": 0.6,
"thumbnail": "https://images.pexels.com/photos/416320/pexels-photo-416320.jpeg?auto=compress&cs=tinysrgb&w=400",
},
{ "id": "cam_005",
"name": "Storage Room",
"status": "processing",
"batteryLevel": 67,
"lastActivity": "15 minutes ago",
"isWireless": true,
"resolution": "1080p",
"frameRate": 24,
"nightVision": true,
"motionSensitivity": 0.9,
"thumbnail": "https://images.pexels.com/photos/1181263/pexels-photo-1181263.jpeg?auto=compress&cs=tinysrgb&w=400",
},
];

  List<Map<String, dynamic>> get _filteredCameras {
    if (_searchQuery.isEmpty) return _cameras;
    return _cameras
        .where((camera) => (camera['name'] as String)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshCameras() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network scan
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera scan completed'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleMultiSelect() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedCameras.clear();
      }
    });
  }

  void _toggleCameraSelection(String cameraId) {
    setState(() {
      if (_selectedCameras.contains(cameraId)) {
        _selectedCameras.remove(cameraId);
      } else {
        _selectedCameras.add(cameraId);
      }
    });
  }

  void _showAddCameraDialog() {
    showDialog(
      context: context,
      builder: (context) => AddCameraDialog(
        onCameraAdded: (cameraData) {
          setState(() {
            _cameras.add(cameraData);
          });
        },
      ),
    );
  }

  void _showCameraSettings(Map<String, dynamic> camera) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CameraSettingsBottomSheet(
        camera: camera,
        onSettingsChanged: (updatedCamera) {
          setState(() {
            final index = _cameras.indexWhere((c) => c['id'] == camera['id']);
            if (index != -1) {
              _cameras[index] = updatedCamera;
            }
          });
        },
      ),
    );
  }

  void _removeCamera(String cameraId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Camera'),
        content: const Text('Are you sure you want to remove this camera?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cameras.removeWhere((camera) => camera['id'] == cameraId);
              });
              Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _performBatchOperation(String operation) {
    switch (operation) {
      case 'configure':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Configuring ${_selectedCameras.length} cameras...'),
          ),
        );
        break;
      case 'test':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Testing ${_selectedCameras.length} cameras...'),
          ),
        );
        break;
      case 'remove':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove Cameras'),
            content: Text(
                'Are you sure you want to remove ${_selectedCameras.length} cameras?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _cameras.removeWhere(
                        (camera) => _selectedCameras.contains(camera['id']));
                    _selectedCameras.clear();
                    _isMultiSelectMode = false;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Remove'),
              ),
            ],
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _isMultiSelectMode
              ? '${_selectedCameras.length} Selected'
              : 'Camera Management',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () {
            if (_isMultiSelectMode) {
              _toggleMultiSelect();
            } else {
              Navigator.pop(context);
            }
          },
          icon: CustomIconWidget(
            iconName: _isMultiSelectMode ? 'close' : 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          if (_isMultiSelectMode) ...[
            PopupMenuButton<String>(
              onSelected: _performBatchOperation,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'configure',
                  child: Text('Configure All'),
                ),
                const PopupMenuItem(
                  value: 'test',
                  child: Text('Test All'),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Text('Remove All'),
                ),
              ],
              child: Padding(
                padding: EdgeInsets.all(2.w),
                child: CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: _toggleMultiSelect,
              icon: CustomIconWidget(
                iconName: 'checklist',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.all(4.w),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search cameras...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color:
                                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // Camera Grid
            Expanded(
              child: _filteredCameras.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _refreshCameras,
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 3.w,
                          mainAxisSpacing: 3.w,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: _filteredCameras.length,
                        itemBuilder: (context, index) {
                          final camera = _filteredCameras[index];
                          final isSelected =
                              _selectedCameras.contains(camera['id']);

                          return GestureDetector(
                            onTap: () {
                              if (_isMultiSelectMode) {
                                _toggleCameraSelection(camera['id'] as String);
                              } else {
                                Navigator.pushNamed(
                                    context, '/camera-management');
                              }
                            },
                            onLongPress: () {
                              if (!_isMultiSelectMode) {
                                _toggleMultiSelect();
                                _toggleCameraSelection(camera['id'] as String);
                              }
                            },
                            child: CameraCardWidget(
                              camera: camera,
                              isSelected: isSelected,
                              isMultiSelectMode: _isMultiSelectMode,
                              onQuickSettings: () => _showCameraSettings(camera),
                              onRemove: () =>
                                  _removeCamera(camera['id'] as String),
                              onViewLive: () {
                                Navigator.pushNamed(
                                    context, '/live-monitoring-dashboard');
                              },
                              onConfigure: () {
                                Navigator.pushNamed(
                                    context, '/ai-model-configuration');
                              },
                              onTestConnection: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Testing connection to ${camera['name']}...'),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton(
              onPressed: _showAddCameraDialog,
              backgroundColor: AppTheme.accentColor,
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(
              imageUrl:
                  "https://images.pexels.com/photos/2599244/pexels-photo-2599244.jpeg?auto=compress&cs=tinysrgb&w=400",
              width: 40.w,
              height: 30.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 4.h),
            Text(
              'No Cameras Found',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Add your first camera to start monitoring your workspace',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: _showAddCameraDialog,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
              label: const Text('Add Your First Camera'),
            ),
          ],
        ),
      ),
    );
  }
}