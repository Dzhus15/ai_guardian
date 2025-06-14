import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SecurityBadgeWidget extends StatelessWidget {
  const SecurityBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.accentColor.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring animation effect
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
            // Inner security icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'security',
                color: AppTheme.accentColor,
                size: 40,
              ),
            ),
            // Small monitoring indicator
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppTheme.successColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.secondaryLight,
                    width: 2,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'visibility',
                  color: AppTheme.secondaryLight,
                  size: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
