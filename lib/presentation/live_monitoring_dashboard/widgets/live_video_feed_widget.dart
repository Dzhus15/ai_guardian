import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LiveVideoFeedWidget extends StatefulWidget {
  final bool isConnected;
  final bool isRecording;
  final String selectedCamera;
  final VoidCallback onLongPress;

  const LiveVideoFeedWidget({
    super.key,
    required this.isConnected,
    required this.isRecording,
    required this.selectedCamera,
    required this.onLongPress,
  });

  @override
  State<LiveVideoFeedWidget> createState() => _LiveVideoFeedWidgetState();
}

class _LiveVideoFeedWidgetState extends State<LiveVideoFeedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _recordingAnimationController;
  late Animation<double> _recordingAnimation;

  @override
  void initState() {
    super.initState();
    _recordingAnimationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _recordingAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _recordingAnimationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isRecording) {
      _recordingAnimationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(LiveVideoFeedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _recordingAnimationController.repeat(reverse: true);
      } else {
        _recordingAnimationController.stop();
        _recordingAnimationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _recordingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress,
      onDoubleTap: () {
        // Double tap to zoom
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Double tap zoom activated'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.width * 9 / 16, // 16:9 aspect ratio
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isConnected
                ? AppTheme.successColor.withValues(alpha: 0.3)
                : AppTheme.errorColor.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              // Video Feed Placeholder
              widget.isConnected
                  ? _buildConnectedView()
                  : _buildDisconnectedView(),

              // Recording Indicator
              if (widget.isRecording)
                Positioned(
                  top: 12,
                  left: 12,
                  child: AnimatedBuilder(
                    animation: _recordingAnimation,
                    builder: (context, child) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor
                              .withValues(alpha: _recordingAnimation.value),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'REC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              // Camera Info
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.selectedCamera.split(' - ').first,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Timestamp
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getCurrentTimestamp(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),

              // Processing Indicator
              if (widget.isConnected)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.dataVisualizationColor
                          .withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectedView() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Simulated video feed with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[800]!,
                  Colors.grey[900]!,
                  Colors.black,
                ],
              ),
            ),
          ),

          // Simulated video content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'videocam',
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 48,
                ),
                SizedBox(height: 8),
                Text(
                  'Live Feed Active',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tap and hold for options',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisconnectedView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[900],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'videocam_off',
              color: AppTheme.errorColor,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'Camera Disconnected',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Pull down to refresh connection',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Retry connection
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
              ),
              child: Text('Retry Connection'),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentTimestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }
}
