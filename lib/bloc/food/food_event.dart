import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object?> get props => [];
}

class ScanFoodEvent extends FoodEvent {
  final File imageFile;

  const ScanFoodEvent(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}

class LoadNutritionProgressEvent extends FoodEvent {}

class UpdateNutritionGoalsEvent extends FoodEvent {
  final double proteinGoal;
  final double calorieGoal;

  const UpdateNutritionGoalsEvent({
    required this.proteinGoal,
    required this.calorieGoal,
  });

  @override
  List<Object> get props => [proteinGoal, calorieGoal];
}

class AddFoodToDailyEvent extends FoodEvent {
  final double protein;
  final double calories;

  const AddFoodToDailyEvent({
    required this.protein,
    required this.calories,
  });

  @override
  List<Object> get props => [protein, calories];
}
