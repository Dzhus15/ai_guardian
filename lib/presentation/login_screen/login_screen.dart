import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/login_form_widget.dart';
import './widgets/security_badge_widget.dart';
import './widgets/sso_options_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isFormValid = false;
  String? _errorMessage;

  // Mock credentials for testing
  final String _mockEmail = "admin@aiguardian.com";
  final String _mockPassword = "Guardian123!";

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final isEmailValid =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    final isPasswordValid = password.length >= 8;

    setState(() {
      _isFormValid = isEmailValid && isPasswordValid;
      if (_errorMessage != null && _isFormValid) {
        _errorMessage = null;
      }
    });
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate() || !_isFormValid) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email == _mockEmail && password == _mockPassword) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/live-monitoring-dashboard');
      }
    } else {
      setState(() {
        _errorMessage =
            "Invalid credentials. Please check your email and password.";
        _isLoading = false;
      });

      // Error haptic feedback
      HapticFeedback.heavyImpact();
    }
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Password Reset',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Password reset functionality will be implemented in the next version.',
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

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: _dismissKeyboard,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    64,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Security Badge
                  const SecurityBadgeWidget(),

                  const SizedBox(height: 48),

                  // Welcome Text
                  Text(
                    'Welcome to AI Guardian',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Secure monitoring system access',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // Login Form
                  LoginFormWidget(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    emailFocusNode: _emailFocusNode,
                    passwordFocusNode: _passwordFocusNode,
                    isPasswordVisible: _isPasswordVisible,
                    isLoading: _isLoading,
                    errorMessage: _errorMessage,
                    onPasswordVisibilityToggle: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    onForgotPassword: _handleForgotPassword,
                  ),

                  const SizedBox(height: 24),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          _isFormValid && !_isLoading ? _handleSignIn : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid
                            ? AppTheme.accentColor
                            : AppTheme.neutralLight,
                        foregroundColor: _isFormValid
                            ? AppTheme.secondaryLight
                            : AppTheme.textDisabledLight,
                        elevation: _isFormValid ? 2.0 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.secondaryLight,
                                ),
                              ),
                            )
                          : Text(
                              'Sign In',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _isFormValid
                                    ? AppTheme.secondaryLight
                                    : AppTheme.textDisabledLight,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // SSO Options
                  const SSOOptionsWidget(),

                  const SizedBox(height: 24),

                  // Mock Credentials Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.dataVisualizationColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.dataVisualizationColor
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'info',
                              color: AppTheme.dataVisualizationColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Demo Credentials',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.dataVisualizationColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Email: $_mockEmail\nPassword: $_mockPassword',
                          style: AppTheme.getMonospaceStyle(
                            isLight: true,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
