import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class AddCameraDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onCameraAdded;

  const AddCameraDialog({
    super.key,
    required this.onCameraAdded,
  });

  @override
  State<AddCameraDialog> createState() => _AddCameraDialogState();
}

class _AddCameraDialogState extends State<AddCameraDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isScanning = false;
  bool _isConnecting = false;
  String _selectedCameraType = 'IP Camera';

  final List<String> _cameraTypes = [
    'IP Camera',
    'USB Camera',
    'Wireless Camera',
    'PTZ Camera',
  ];

  final List<Map<String, dynamic>> _discoveredCameras = [
{ "name": "Camera_192.168.1.100",
"ip": "192.168.1.100",
"type": "IP Camera",
"manufacturer": "Generic",
},
{ "name": "Camera_192.168.1.101",
"ip": "192.168.1.101",
"type": "Wireless Camera",
"manufacturer": "Generic",
},
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _portController.text = '80';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _scanForCameras() async {
    setState(() {
      _isScanning = true;
    });

    // Simulate network scanning
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isScanning = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Found ${_discoveredCameras.length} cameras'),
        ),
      );
    }
  }

  Future<void> _addCamera({Map<String, dynamic>? discoveredCamera}) async {
    setState(() {
      _isConnecting = true;
    });

    // Simulate connection test
    await Future.delayed(const Duration(seconds: 2));

    final newCamera = {
      "id": "cam_${DateTime.now().millisecondsSinceEpoch}",
      "name": discoveredCamera?['name'] ?? _nameController.text,
      "status": "online",
      "batteryLevel": _selectedCameraType == 'Wireless Camera' ? 100 : null,
      "lastActivity": "Just now",
      "isWireless": _selectedCameraType == 'Wireless Camera',
      "resolution": "1080p",
      "frameRate": 30,
      "nightVision": true,
      "motionSensitivity": 0.7,
      "thumbnail":
          "https://images.pexels.com/photos/2599244/pexels-photo-2599244.jpeg?auto=compress&cs=tinysrgb&w=400",
    };

    widget.onCameraAdded(newCamera);

    setState(() {
      _isConnecting = false;
    });

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera added successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 90.w,
        height: 80.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Camera',
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

            SizedBox(height: 2.h),

            // Tab bar
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Auto Discover'),
                Tab(text: 'Manual Setup'),
              ],
            ),

            SizedBox(height: 2.h),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAutoDiscoverTab(),
                  _buildManualSetupTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoDiscoverTab() {
    return Column(
      children: [
        // Scan button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isScanning ? null : _scanForCameras,
            icon: _isScanning
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
            label: Text(_isScanning ? 'Scanning...' : 'Scan Network'),
          ),
        ),

        SizedBox(height: 3.h),

        // Discovered cameras list
        Expanded(
          child: _discoveredCameras.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'videocam_off',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No cameras discovered',
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Tap scan to search for cameras on your network',
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _discoveredCameras.length,
                  itemBuilder: (context, index) {
                    final camera = _discoveredCameras[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: ListTile(
                        leading: CustomIconWidget(
                          iconName: 'videocam',
                          color: AppTheme.accentColor,
                          size: 24,
                        ),
                        title: Text(camera['name'] as String),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('IP: ${camera['ip']}'),
                            Text('Type: ${camera['type']}'),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: _isConnecting
                              ? null
                              : () => _addCamera(discoveredCamera: camera),
                          child: _isConnecting
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                    ),
                                  ),
                                )
                              : const Text('Add'),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildManualSetupTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Camera type dropdown
          Text(
            'Camera Type',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          DropdownButtonFormField<String>(
            value: _selectedCameraType,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: _cameraTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCameraType = value;
                });
              }
            },
          ),

          SizedBox(height: 3.h),

          // Camera name
          Text(
            'Camera Name',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter camera name',
            ),
          ),

          SizedBox(height: 3.h),

          // IP Address
          Text(
            'IP Address',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _ipController,
            decoration: const InputDecoration(
              hintText: '192.168.1.100',
            ),
            keyboardType: TextInputType.number,
          ),

          SizedBox(height: 3.h),

          // Port
          Text(
            'Port',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _portController,
            decoration: const InputDecoration(
              hintText: '80',
            ),
            keyboardType: TextInputType.number,
          ),

          SizedBox(height: 3.h),

          // Username
          Text(
            'Username (Optional)',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              hintText: 'Enter username',
            ),
          ),

          SizedBox(height: 3.h),

          // Password
          Text(
            'Password (Optional)',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              hintText: 'Enter password',
            ),
            obscureText: true,
          ),

          SizedBox(height: 4.h),

          // Add button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isConnecting ||
                      _nameController.text.isEmpty ||
                      _ipController.text.isEmpty
                  ? null
                  : () => _addCamera(),
              child: _isConnecting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        const Text('Connecting...'),
                      ],
                    )
                  : const Text('Add Camera'),
            ),
          ),
        ],
      ),
    );
  }
}