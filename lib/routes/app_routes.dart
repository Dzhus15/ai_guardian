import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/ai_model_configuration/ai_model_configuration.dart';
import '../presentation/ai_analysis_results/ai_analysis_results.dart';
import '../presentation/alert_history/alert_history.dart';
import '../presentation/camera_management/camera_management.dart';
import '../presentation/live_monitoring_dashboard/live_monitoring_dashboard.dart';

class AppRoutes {
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String liveMonitoringDashboard = '/live-monitoring-dashboard';
  static const String aiAnalysisResults = '/ai-analysis-results';
  static const String cameraManagement = '/camera-management';
  static const String alertHistory = '/alert-history';
  static const String aiModelConfiguration = '/ai-model-configuration';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    loginScreen: (context) => const LoginScreen(),
    liveMonitoringDashboard: (context) => const LiveMonitoringDashboard(),
    aiAnalysisResults: (context) => const AiAnalysisResults(),
    cameraManagement: (context) => const CameraManagement(),
    alertHistory: (context) => const AlertHistory(),
    aiModelConfiguration: (context) => const AiModelConfiguration(),
  };
}
