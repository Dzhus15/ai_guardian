import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_filter_bottom_sheet.dart';
import './widgets/alert_card_widget.dart';
import './widgets/filter_chip_widget.dart';

class AlertHistory extends StatefulWidget {
  const AlertHistory({super.key});

  @override
  State<AlertHistory> createState() => _AlertHistoryState();
}

class _AlertHistoryState extends State<AlertHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  bool _isLoading = false;
  bool _isMultiSelectMode = false;
  String _selectedFilter = 'All';
  final List<String> _selectedAlerts = [];

  final List<String> _filterOptions = [
    'All',
    'Today',
    'This Week',
    'High Priority',
    'Unresolved'
  ];

  // Mock alert data
  final List<Map<String, dynamic>> _alertData = [
    {
      "id": "alert_001",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "type": "Intrusion Detection",
      "severity": "High",
      "description": "Unauthorized person detected in restricted area",
      "location": "Camera 3 - Main Entrance",
      "thumbnail":
          "https://images.pexels.com/photos/2899097/pexels-photo-2899097.jpeg?auto=compress&cs=tinysrgb&w=400",
      "status": "Unresolved",
      "aiConfidence": 0.94,
      "resolved": false
    },
    {
      "id": "alert_002",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "type": "Inappropriate Behavior",
      "severity": "Medium",
      "description": "Inappropriate language detected in workplace",
      "location": "Camera 1 - Office Floor",
      "thumbnail":
          "https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "status": "Under Review",
      "aiConfidence": 0.87,
      "resolved": false
    },
    {
      "id": "alert_003",
      "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
      "type": "Security Breach",
      "severity": "Critical",
      "description": "Multiple failed access attempts detected",
      "location": "Camera 2 - Server Room",
      "thumbnail":
          "https://images.pexels.com/photos/325229/pexels-photo-325229.jpeg?auto=compress&cs=tinysrgb&w=400",
      "status": "Resolved",
      "aiConfidence": 0.98,
      "resolved": true
    },
    {
      "id": "alert_004",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "type": "Motion Detection",
      "severity": "Low",
      "description": "Unusual movement pattern after hours",
      "location": "Camera 4 - Parking Lot",
      "thumbnail":
          "https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&w=400",
      "status": "Resolved",
      "aiConfidence": 0.76,
      "resolved": true
    },
    {
      "id": "alert_005",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "type": "Equipment Tampering",
      "severity": "High",
      "description": "Camera obstruction detected",
      "location": "Camera 5 - Warehouse",
      "thumbnail":
          "https://images.pexels.com/photos/2899097/pexels-photo-2899097.jpeg?auto=compress&cs=tinysrgb&w=400",
      "status": "Under Investigation",
      "aiConfidence": 0.91,
      "resolved": false
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 2);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreAlerts();
    }
  }

  void _loadMoreAlerts() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdvancedFilterBottomSheet(
        onApplyFilters: (filters) {
          // Apply advanced filters
          Navigator.pop(context);
        },
      ),
    );
  }

  void _toggleMultiSelect() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedAlerts.clear();
      }
    });
  }

  void _selectAlert(String alertId) {
    setState(() {
      if (_selectedAlerts.contains(alertId)) {
        _selectedAlerts.remove(alertId);
      } else {
        _selectedAlerts.add(alertId);
      }
    });
  }

  void _performBulkAction(String action) {
    // Perform bulk action on selected alerts
    setState(() {
      _selectedAlerts.clear();
      _isMultiSelectMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action applied to selected alerts'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredAlerts() {
    List<Map<String, dynamic>> filtered = List.from(_alertData);

    if (_selectedFilter != 'All') {
      switch (_selectedFilter) {
        case 'Today':
          filtered = filtered.where((alert) {
            final alertDate = alert['timestamp'] as DateTime;
            final today = DateTime.now();
            return alertDate.day == today.day &&
                alertDate.month == today.month &&
                alertDate.year == today.year;
          }).toList();
          break;
        case 'This Week':
          filtered = filtered.where((alert) {
            final alertDate = alert['timestamp'] as DateTime;
            final weekAgo = DateTime.now().subtract(const Duration(days: 7));
            return alertDate.isAfter(weekAgo);
          }).toList();
          break;
        case 'High Priority':
          filtered = filtered
              .where((alert) =>
                  alert['severity'] == 'High' ||
                  alert['severity'] == 'Critical')
              .toList();
          break;
        case 'Unresolved':
          filtered =
              filtered.where((alert) => !(alert['resolved'] as bool)).toList();
          break;
      }
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((alert) =>
              (alert['description'] as String).toLowerCase().contains(query) ||
              (alert['location'] as String).toLowerCase().contains(query) ||
              (alert['type'] as String).toLowerCase().contains(query))
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredAlerts = _getFilteredAlerts();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search alerts...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: AppTheme.textMediumEmphasisLight,
                    fontSize: 16.sp,
                  ),
                ),
                style: TextStyle(
                  color: AppTheme.textHighEmphasisLight,
                  fontSize: 16.sp,
                ),
                onChanged: (value) => setState(() {}),
              )
            : Text(
                'Alert History',
                style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
              ),
        actions: [
          if (_isMultiSelectMode) ...[
            TextButton(
              onPressed: () => _performBulkAction('Archive'),
              child: Text(
                'Archive',
                style: TextStyle(
                  color: AppTheme.accentColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _performBulkAction('Resolve'),
              child: Text(
                'Resolve',
                style: TextStyle(
                  color: AppTheme.successColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: _toggleSearch,
              icon: CustomIconWidget(
                iconName: _isSearching ? 'close' : 'search',
                color: AppTheme.textHighEmphasisLight,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: _showAdvancedFilters,
              icon: CustomIconWidget(
                iconName: 'filter_list',
                color: AppTheme.textHighEmphasisLight,
                size: 24,
              ),
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Monitor'),
            Tab(text: 'History'),
            Tab(text: 'Alerts'),
            Tab(text: 'Settings'),
          ],
          onTap: (index) {
            if (index != 2) {
              // Navigate to other tabs
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/live-monitoring-dashboard');
                  break;
                case 1:
                  // Stay on current screen
                  break;
                case 3:
                  Navigator.pushNamed(context, '/ai-model-configuration');
                  break;
              }
            }
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
        },
        child: Column(
          children: [
            // Filter chips
            Container(
              height: 60,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _filterOptions.length,
                itemBuilder: (context, index) {
                  final filter = _filterOptions[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: FilterChipWidget(
                      label: filter,
                      isSelected: _selectedFilter == filter,
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Alert list
            Expanded(
              child: filteredAlerts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'notifications_off',
                            color: AppTheme.textMediumEmphasisLight,
                            size: 64,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No alerts found',
                            style: TextStyle(
                              color: AppTheme.textMediumEmphasisLight,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Try adjusting your filters',
                            style: TextStyle(
                              color: AppTheme.textMediumEmphasisLight,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(16.w),
                      itemCount: filteredAlerts.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filteredAlerts.length) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.h),
                              child: CircularProgressIndicator(
                                color: AppTheme.accentColor,
                              ),
                            ),
                          );
                        }

                        final alert = filteredAlerts[index];
                        return AlertCardWidget(
                          alert: alert,
                          isMultiSelectMode: _isMultiSelectMode,
                          isSelected: _selectedAlerts.contains(alert['id']),
                          onTap: () {
                            if (_isMultiSelectMode) {
                              _selectAlert(alert['id'] as String);
                            } else {
                              Navigator.pushNamed(
                                  context, '/ai-analysis-results');
                            }
                          },
                          onLongPress: () {
                            if (!_isMultiSelectMode) {
                              _toggleMultiSelect();
                              _selectAlert(alert['id'] as String);
                            }
                          },
                          onSwipeRight: (alertId) {
                            // Show quick actions
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Quick actions available'),
                                action: SnackBarAction(
                                  label: 'Resolve',
                                  onPressed: () {
                                    // Mark as resolved
                                  },
                                ),
                              ),
                            );
                          },
                          onSwipeLeft: (alertId) {
                            // Archive alert
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Alert archived'),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isMultiSelectMode
          ? FloatingActionButton(
              onPressed: _toggleMultiSelect,
              backgroundColor: AppTheme.errorColor,
              child: CustomIconWidget(
                iconName: 'close',
                color: Colors.white,
                size: 24,
              ),
            )
          : null,
    );
  }
}
