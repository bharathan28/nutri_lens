import 'dart:io';
import 'package:camera/camera.dart' hide CameraException;
import '../../main.dart';
import '../../core/errors/exceptions.dart';

abstract class CameraDataSource {
  Future<CameraController> initializeCamera();
  Future<File> captureImage(CameraController controller);
  Future<void> disposeCamera(CameraController controller);
}

class CameraDataSourceImpl implements CameraDataSource {
  @override
  Future<CameraController> initializeCamera() async {
    try {
      if (cameras.isEmpty) {
        throw CameraException('No cameras available on this device');
      }

      final camera = cameras.first;
      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();
      return controller;
    } catch (e) {
      throw CameraException('Failed to initialize camera: $e');
    }
  }

  @override
  Future<File> captureImage(CameraController controller) async {
    try {
      if (!controller.value.isInitialized) {
        throw CameraException('Camera not initialized');
      }

      final XFile image = await controller.takePicture();
      return File(image.path);
    } catch (e) {
      throw CameraException('Failed to capture image: $e');
    }
  }

  @override
  Future<void> disposeCamera(CameraController controller) async {
    try {
      await controller.dispose();
    } catch (e) {
      // Log error but don't throw - disposal should be silent
      print('Error disposing camera: $e');
    }
  }
}
