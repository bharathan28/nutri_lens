import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';


@JsonSerializable()
class NutritionModel extends Equatable {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double servingSize;

  const NutritionModel({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.servingSize = 100.0,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) => _$NutritionModelFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionModelToJson(this);

  @override
  List<Object> get props => [calories, protein, carbs, fat, servingSize];
}
