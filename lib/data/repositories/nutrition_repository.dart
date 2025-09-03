import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_goal_model.dart';
import '../datasources/food_local_datasource.dart';

abstract class NutritionRepository {
  Future<Either<Failure, UserGoalModel>> getDailyProgress();
  Future<Either<Failure, void>> updateProgress(double protein, double calories);
  Future<Either<Failure, void>> resetDailyProgress();
}

class NutritionRepositoryImpl implements NutritionRepository {
  final FoodLocalDataSource localDataSource;

  NutritionRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, UserGoalModel>> getDailyProgress() async {
    try {
      final progress = await localDataSource.getCachedNutritionProgress();
      return Right(progress);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateProgress(double protein, double calories) async {
    try {
      await localDataSource.updateDailyProgress(protein, calories);
      return Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> resetDailyProgress() async {
    try {
      await localDataSource.resetDailyProgress();
      return Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
