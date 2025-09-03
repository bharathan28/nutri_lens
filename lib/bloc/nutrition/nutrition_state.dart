import 'package:equatable/equatable.dart';
import '../../data/models/user_goal_model.dart';

abstract class NutritionState extends Equatable {
  const NutritionState();

  @override
  List<Object?> get props => [];
}

class NutritionInitial extends NutritionState {}

class NutritionLoading extends NutritionState {}

class NutritionLoaded extends NutritionState {
  final UserGoalModel nutritionData;

  const NutritionLoaded(this.nutritionData);

  @override
  List<Object> get props => [nutritionData];
}

class NutritionError extends NutritionState {
  final String message;

  const NutritionError(this.message);

  @override
  List<Object> get props => [message];
}
