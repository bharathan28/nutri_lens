import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/food_repository.dart';
import 'food_event.dart';
import 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository repository;

  FoodBloc(this.repository) : super(FoodInitial()) {
    on<ScanFoodEvent>(_onScanFood);
    on<LoadNutritionProgressEvent>(_onLoadNutritionProgress);
    on<UpdateNutritionGoalsEvent>(_onUpdateNutritionGoals);
    on<AddFoodToDailyEvent>(_onAddFoodToDaily);
  }

  Future<void> _onScanFood(
    ScanFoodEvent event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());

    final result = await repository.scanFood(event.imageFile);
    result.fold(
      (failure) => emit(FoodScanError(failure.message)),
      (scanResult) => emit(FoodScanSuccess(scanResult)),
    );
  }

  Future<void> _onLoadNutritionProgress(
    LoadNutritionProgressEvent event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());

    final result = await repository.getNutritionProgress();
    result.fold(
      (failure) => emit(NutritionProgressError(failure.message)),
      (nutritionData) => emit(NutritionProgressLoaded(nutritionData)),
    );
  }

  Future<void> _onUpdateNutritionGoals(
    UpdateNutritionGoalsEvent event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());

    final result = await repository.updateNutritionGoals(
      event.proteinGoal,
      event.calorieGoal,
    );
    
    result.fold(
      (failure) => emit(NutritionProgressError(failure.message)),
      (_) => add(LoadNutritionProgressEvent()),
    );
  }

  Future<void> _onAddFoodToDaily(
    AddFoodToDailyEvent event,
    Emitter<FoodState> emit,
  ) async {
    final result = await repository.addFoodToDaily(
      event.protein,
      event.calories,
    );
    
    result.fold(
      (failure) => emit(NutritionProgressError(failure.message)),
      (_) => add(LoadNutritionProgressEvent()),
    );
  }
}
