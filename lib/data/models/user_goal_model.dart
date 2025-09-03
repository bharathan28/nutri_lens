import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_goal_model.g.dart';

@JsonSerializable()
class UserGoalModel extends Equatable {
  final double dailyProteinGoal;
  final double dailyCalorieGoal;
  final double currentProtein;
  final double currentCalories;

  const UserGoalModel({
    required this.dailyProteinGoal,
    required this.dailyCalorieGoal,
    this.currentProtein = 0.0,
    this.currentCalories = 0.0,
  });

  factory UserGoalModel.fromJson(Map<String, dynamic> json) => _$UserGoalModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserGoalModelToJson(this);

  UserGoalModel copyWith({
    double? dailyProteinGoal,
    double? dailyCalorieGoal,
    double? currentProtein,
    double? currentCalories,
  }) {
    return UserGoalModel(
      dailyProteinGoal: dailyProteinGoal ?? this.dailyProteinGoal,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      currentProtein: currentProtein ?? this.currentProtein,
      currentCalories: currentCalories ?? this.currentCalories,
    );
  }

  double get proteinProgress => currentProtein / dailyProteinGoal;
  double get calorieProgress => currentCalories / dailyCalorieGoal;

  @override
  List<Object> get props => [dailyProteinGoal, dailyCalorieGoal, currentProtein, currentCalories];
}
