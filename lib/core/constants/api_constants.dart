class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8000/api/';
  static const String scanFood = 'scan-food/';
  static const String getNutritionProgress = 'nutrition-progress/';
  static const String updateGoals = 'update-goals/';
  
  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}
