import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_goal_model.dart';

abstract class FoodLocalDataSource {
  Future<UserGoalModel> getCachedNutritionProgress();
  Future<void> cacheNutritionProgress(UserGoalModel nutritionData);
  Future<void> updateDailyProgress(double protein, double calories);
  Future<void> resetDailyProgress();
}

class FoodLocalDataSourceImpl implements FoodLocalDataSource {
  final SharedPreferences sharedPreferences;

  FoodLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<UserGoalModel> getCachedNutritionProgress() async {
    try {
      final proteinGoal = sharedPreferences.getDouble(AppConstants.keyProteinGoal) ?? 
                         AppConstants.defaultProteinGoal;
      final calorieGoal = sharedPreferences.getDouble(AppConstants.keyCalorieGoal) ?? 
                         AppConstants.defaultCalorieGoal;
      final dailyProtein = sharedPreferences.getDouble(AppConstants.keyDailyProtein) ?? 0.0;
      final dailyCalories = sharedPreferences.getDouble(AppConstants.keyDailyCalories) ?? 0.0;

      return UserGoalModel(
        dailyProteinGoal: proteinGoal,
        dailyCalorieGoal: calorieGoal,
        currentProtein: dailyProtein,
        currentCalories: dailyCalories,
      );
    } catch (e) {
      throw CacheException('Failed to get cached nutrition data: $e');
    }
  }

  @override
  Future<void> cacheNutritionProgress(UserGoalModel nutritionData) async {
    try {
      await Future.wait([
        sharedPreferences.setDouble(AppConstants.keyProteinGoal, nutritionData.dailyProteinGoal),
        sharedPreferences.setDouble(AppConstants.keyCalorieGoal, nutritionData.dailyCalorieGoal),
        sharedPreferences.setDouble(AppConstants.keyDailyProtein, nutritionData.currentProtein),
        sharedPreferences.setDouble(AppConstants.keyDailyCalories, nutritionData.currentCalories),
      ]);
    } catch (e) {
      throw CacheException('Failed to cache nutrition data: $e');
    }
  }

  @override
  Future<void> updateDailyProgress(double protein, double calories) async {
    try {
      final currentData = await getCachedNutritionProgress();
      final updatedData = currentData.copyWith(
        currentProtein: currentData.currentProtein + protein,
        currentCalories: currentData.currentCalories + calories,
      );
      await cacheNutritionProgress(updatedData);
    } catch (e) {
      throw CacheException('Failed to update daily progress: $e');
    }
  }

  @override
  Future<void> resetDailyProgress() async {
    try {
      await Future.wait([
        sharedPreferences.setDouble(AppConstants.keyDailyProtein, 0.0),
        sharedPreferences.setDouble(AppConstants.keyDailyCalories, 0.0),
      ]);
    } catch (e) {
      throw CacheException('Failed to reset daily progress: $e');
    }
  }
}
