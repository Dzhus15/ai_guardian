import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedFilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const AdvancedFilterBottomSheet({
    super.key,
    required this.onApplyFilters,
  });

  @override
  State<AdvancedFilterBottomSheet> createState() =>
      _AdvancedFilterBottomSheetState();
}

class _AdvancedFilterBottomSheetState extends State<AdvancedFilterBottomSheet> {
  DateTimeRange? _selectedDateRange;
  String _selectedLocation = 'All Locations';
  String _selectedAlertType = 'All Types';
  String _selectedSeverity = 'All Severities';

  final List<String> _locations = [
    'All Locations',
    'Camera 1 - Office Floor',
    'Camera 2 - Server Room',
    'Camera 3 - Main Entrance',
    'Camera 4 - Parking Lot',
    'Camera 5 - Warehouse',
  ];

  final List<String> _alertTypes = [
    'All Types',
    'Intrusion Detection',
    'Inappropriate Behavior',
    'Security Breach',
    'Motion Detection',
    'Equipment Tampering',
  ];

  final List<String> _severities = [
    'All Severities',
    'Critical',
    'High',
    'Medium',
    'Low',
  ];

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.accentColor,
                  onPrimary: Colors.white,
                  surface: AppTheme.lightTheme.cardColor,
                  onSurface: AppTheme.textHighEmphasisLight,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedDateRange = null;
      _selectedLocation = 'All Locations';
      _selectedAlertType = 'All Types';
      _selectedSeverity = 'All Severities';
    });
  }

  void _applyFilters() {
    final filters = {
      'dateRange': _selectedDateRange,
      'location': _selectedLocation,
      'alertType': _selectedAlertType,
      'severity': _selectedSeverity,
    };
    widget.onApplyFilters(filters);
  }

  Widget _buildDropdownSection(
    String title,
    String value,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTheme.textHighEmphasisLight,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.neutralLight,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.textMediumEmphasisLight,
                size: 20,
              ),
              style: TextStyle(
                color: AppTheme.textHighEmphasisLight,
                fontSize: 14.sp,
              ),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: AppTheme.neutralLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Text(
                  'Advanced Filters',
                  style: TextStyle(
                    color: AppTheme.textHighEmphasisLight,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: AppTheme.accentColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Range
                  Text(
                    'Date Range',
                    style: TextStyle(
                      color: AppTheme.textHighEmphasisLight,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: _selectDateRange,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.neutralLight,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'date_range',
                            color: AppTheme.textMediumEmphasisLight,
                            size: 20,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              _selectedDateRange != null
                                  ? '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month}/${_selectedDateRange!.start.year} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}/${_selectedDateRange!.end.year}'
                                  : 'Select date range',
                              style: TextStyle(
                                color: _selectedDateRange != null
                                    ? AppTheme.textHighEmphasisLight
                                    : AppTheme.textMediumEmphasisLight,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Location
                  _buildDropdownSection(
                    'Camera Location',
                    _selectedLocation,
                    _locations,
                    (value) => setState(() => _selectedLocation = value),
                  ),
                  SizedBox(height: 24.h),

                  // Alert Type
                  _buildDropdownSection(
                    'Alert Type',
                    _selectedAlertType,
                    _alertTypes,
                    (value) => setState(() => _selectedAlertType = value),
                  ),
                  SizedBox(height: 24.h),

                  // Severity
                  _buildDropdownSection(
                    'Severity Level',
                    _selectedSeverity,
                    _severities,
                    (value) => setState(() => _selectedSeverity = value),
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              border: Border(
                top: BorderSide(
                  color: AppTheme.neutralLight,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
