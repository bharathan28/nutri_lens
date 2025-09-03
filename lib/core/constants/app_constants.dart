class AppConstants {
  static const String appName = 'NutriLens';
  static const String appDescription = 'AR Food Scanner & Nutritional AI Coach';
  
  // Default nutrition goals
  static const double defaultProteinGoal = 120.0;
  static const double defaultCalorieGoal = 2000.0;
  
  // Camera settings
  static const double arOverlayOpacity = 0.8;
  static const int cameraQuality = 85;
  
  // Shared preferences keys
  static const String keyProteinGoal = 'protein_goal';
  static const String keyCalorieGoal = 'calorie_goal';
  static const String keyDailyProtein = 'daily_protein';
  static const String keyDailyCalories = 'daily_calories';
}
