import 'package:equatable/equatable.dart';
import '../../data/models/scan_result_model.dart';
import '../../data/models/user_goal_model.dart';

abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object?> get props => [];
}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodScanSuccess extends FoodState {
  final ScanResultModel scanResult;

  const FoodScanSuccess(this.scanResult);

  @override
  List<Object> get props => [scanResult];
}

class FoodScanError extends FoodState {
  final String message;

  const FoodScanError(this.message);

  @override
  List<Object> get props => [message];
}

class NutritionProgressLoaded extends FoodState {
  final UserGoalModel nutritionData;

  const NutritionProgressLoaded(this.nutritionData);

  @override
  List<Object> get props => [nutritionData];
}

class NutritionProgressError extends FoodState {
  final String message;

  const NutritionProgressError(this.message);

  @override
  List<Object> get props => [message];
}

class FoodAddedToDaily extends FoodState {
  final UserGoalModel updatedNutrition;

  const FoodAddedToDaily(this.updatedNutrition);

  @override
  List<Object> get props => [updatedNutrition];
}
