import 'package:flutter/material.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/camera_screen.dart';
import '../presentation/screens/results_screen.dart';
import '../presentation/screens/dashboard_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String camera = '/camera';
  static const String results = '/results';
  static const String dashboard = '/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case camera:
        return MaterialPageRoute(builder: (_) => CameraScreen());
      case results:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ResultsScreen(
            imagePath: args?['imagePath'] ?? '',
            foodResult: args?['foodResult'],
          ),
        );
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
