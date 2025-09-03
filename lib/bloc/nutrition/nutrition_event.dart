import 'package:equatable/equatable.dart';

abstract class NutritionEvent extends Equatable {
  const NutritionEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailyProgressEvent extends NutritionEvent {}

class UpdateProgressEvent extends NutritionEvent {
  final double protein;
  final double calories;

  const UpdateProgressEvent({
    required this.protein,
    required this.calories,
  });

  @override
  List<Object> get props => [protein, calories];
}

class ResetDailyProgressEvent extends NutritionEvent {}
