import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SSOOptionsWidget extends StatelessWidget {
  const SSOOptionsWidget({super.key});

  void _handleSSOLogin(BuildContext context, String provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '$provider SSO',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          '$provider Single Sign-On integration will be available in the enterprise version.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleBiometricLogin(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Biometric Authentication',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Biometric authentication (Face ID/Touch ID/Fingerprint) will be enabled after your first successful login.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.dividerLight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.dividerLight,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Enterprise SSO Options
        Text(
          'Enterprise Authentication',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        // Microsoft SSO Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () => _handleSSOLogin(context, 'Microsoft'),
            icon: CustomIconWidget(
              iconName: 'business',
              color: AppTheme.textMediumEmphasisLight,
              size: 20,
            ),
            label: Text(
              'Continue with Microsoft',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textHighEmphasisLight,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: AppTheme.neutralLight,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Google SSO Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () => _handleSSOLogin(context, 'Google'),
            icon: CustomIconWidget(
              iconName: 'account_circle',
              color: AppTheme.textMediumEmphasisLight,
              size: 20,
            ),
            label: Text(
              'Continue with Google',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textHighEmphasisLight,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: AppTheme.neutralLight,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Biometric Authentication Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () => _handleBiometricLogin(context),
            icon: CustomIconWidget(
              iconName: 'fingerprint',
              color: AppTheme.textMediumEmphasisLight,
              size: 20,
            ),
            label: Text(
              'Use Biometric Authentication',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textHighEmphasisLight,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: AppTheme.neutralLight,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
