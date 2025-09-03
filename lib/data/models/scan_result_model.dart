import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'food_model.dart';

part 'scan_result_model.g.dart';

@JsonSerializable()
class ScanResultModel extends Equatable {
  final bool success;
  final FoodModel? food;
  final double confidence;
  final String? error;
  final DateTime timestamp;

  const ScanResultModel({
    required this.success,
    this.food,
    required this.confidence,
    this.error,
    required this.timestamp,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      success: json['success'] ?? false,
      food: json['food'] != null ? FoodModel.fromJson(json['food']) : null,
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      error: json['error'],
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _$ScanResultModelToJson(this);

  @override
  List<Object?> get props => [success, food, confidence, error, timestamp];
}
