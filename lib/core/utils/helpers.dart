import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Helpers {
  static String formatDouble(double value, {int decimals = 1}) {
    return value.toStringAsFixed(decimals);
  }

  static String formatCalories(double calories) {
    return '${calories.toInt()} cal';
  }

  static String formatProtein(double protein) {
    return '${formatDouble(protein)}g protein';
  }

  static double calculateProgress(double current, double goal) {
    if (goal <= 0) return 0.0;
    return (current / goal).clamp(0.0, 1.0);
  }

  static String formatProgress(double current, double goal) {
    final percentage = (calculateProgress(current, goal) * 100).toInt();
    return '$percentage%';
  }

  static Future<String> saveImageToLocal(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = 'food_scan_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = '${directory.path}/$fileName';
      
      await imageFile.copy(filePath);
      return filePath;
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  static String encodeImageToBase64(File imageFile) {
    final bytes = imageFile.readAsBytesSync();
    return base64Encode(bytes);
  }
}
