import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';


@JsonSerializable()
class FoodModel extends Equatable {
  final int? id;
  final String name;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;

  const FoodModel({
    this.id,
    required this.name,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) => _$FoodModelFromJson(json);
  Map<String, dynamic> toJson() => _$FoodModelToJson(this);

  @override
  List<Object?> get props => [id, name, caloriesPer100g, proteinPer100g, carbsPer100g, fatPer100g];
}
