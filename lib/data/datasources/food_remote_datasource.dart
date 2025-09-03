import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/scan_result_model.dart';
import '../models/user_goal_model.dart';

abstract class FoodRemoteDataSource {
  Future<ScanResultModel> scanFood(File imageFile);
  Future<UserGoalModel> getNutritionProgress();
  Future<void> updateNutritionGoals(double proteinGoal, double calorieGoal);
}

class FoodRemoteDataSourceImpl implements FoodRemoteDataSource {
  final DioClient client;

  FoodRemoteDataSourceImpl(this.client);

  @override
  Future<ScanResultModel> scanFood(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'food_image.jpg',
        ),
      });

      final response = await client.post(ApiConstants.scanFood, data: formData);
      
      if (response.statusCode == 200) {
        return ScanResultModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to scan food: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error occurred');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<UserGoalModel> getNutritionProgress() async {
    try {
      final response = await client.get(ApiConstants.getNutritionProgress);
      
      if (response.statusCode == 200) {
        return UserGoalModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to get nutrition progress');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error occurred');
    }
  }

  @override
  Future<void> updateNutritionGoals(double proteinGoal, double calorieGoal) async {
    try {
      final response = await client.put(
        ApiConstants.updateGoals,
        data: {
          'protein_goal': proteinGoal,
          'calorie_goal': calorieGoal,
        },
      );
      
      if (response.statusCode != 200) {
        throw ServerException('Failed to update nutrition goals');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error occurred');
    }
  }
}
