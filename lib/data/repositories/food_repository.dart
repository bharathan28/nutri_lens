import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../models/scan_result_model.dart';
import '../models/user_goal_model.dart';
import '../datasources/food_remote_datasource.dart';
import '../datasources/food_local_datasource.dart';

abstract class FoodRepository {
  Future<Either<Failure, ScanResultModel>> scanFood(File imageFile);
  Future<Either<Failure, UserGoalModel>> getNutritionProgress();
  Future<Either<Failure, void>> updateNutritionGoals(double proteinGoal, double calorieGoal);
  Future<Either<Failure, void>> addFoodToDaily(double protein, double calories);
}

class FoodRepositoryImpl implements FoodRepository {
  final FoodRemoteDataSource remoteDataSource;
  final FoodLocalDataSource localDataSource;

  FoodRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ScanResultModel>> scanFood(File imageFile) async {
    try {
      final result = await remoteDataSource.scanFood(imageFile);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserGoalModel>> getNutritionProgress() async {
    try {
      // Try to get from remote first
      try {
        final remoteData = await remoteDataSource.getNutritionProgress();
        // Cache the remote data
        await localDataSource.cacheNutritionProgress(remoteData);
        return Right(remoteData);
      } catch (e) {
        // If remote fails, get from local cache
        final localData = await localDataSource.getCachedNutritionProgress();
        return Right(localData);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get nutrition progress'));
    }
  }

  @override
  Future<Either<Failure, void>> updateNutritionGoals(double proteinGoal, double calorieGoal) async {
    try {
      await remoteDataSource.updateNutritionGoals(proteinGoal, calorieGoal);
      
      // Update local cache
      final currentData = await localDataSource.getCachedNutritionProgress();
      final updatedData = currentData.copyWith(
        dailyProteinGoal: proteinGoal,
        dailyCalorieGoal: calorieGoal,
      );
      await localDataSource.cacheNutritionProgress(updatedData);
      
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addFoodToDaily(double protein, double calories) async {
    try {
      await localDataSource.updateDailyProgress(protein, calories);
      return Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
