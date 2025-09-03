import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'injection_container.dart' as di;

// Global list of available cameras
List<CameraDescription> cameras = [];

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations (portrait only for better AR experience)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize cameras
  try {
    cameras = await availableCameras();
  } catch (e) {
    // Continue even if cameras fail - app can still show other features
    cameras = [];
  }
  
  // Initialize dependency injection
  try {
    await di.init();
  } catch (e) {
    // Handle DI initialization error gracefully
  }
  
  // Run the app
  runApp(NutriLensApp());
}
