import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/nutrition_repository.dart';
import 'nutrition_event.dart';
import 'nutrition_state.dart';

class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  final NutritionRepository repository;

  NutritionBloc(this.repository) : super(NutritionInitial()) {
    on<LoadDailyProgressEvent>(_onLoadDailyProgress);
    on<UpdateProgressEvent>(_onUpdateProgress);
    on<ResetDailyProgressEvent>(_onResetDailyProgress);
  }

  Future<void> _onLoadDailyProgress(
    LoadDailyProgressEvent event,
    Emitter<NutritionState> emit,
  ) async {
    emit(NutritionLoading());

    final result = await repository.getDailyProgress();
    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (nutritionData) => emit(NutritionLoaded(nutritionData)),
    );
  }

  Future<void> _onUpdateProgress(
    UpdateProgressEvent event,
    Emitter<NutritionState> emit,
  ) async {
    final result = await repository.updateProgress(
      event.protein,
      event.calories,
    );
    
    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (_) => add(LoadDailyProgressEvent()),
    );
  }

  Future<void> _onResetDailyProgress(
    ResetDailyProgressEvent event,
    Emitter<NutritionState> emit,
  ) async {
    final result = await repository.resetDailyProgress();
    
    result.fold(
      (failure) => emit(NutritionError(failure.message)),
      (_) => add(LoadDailyProgressEvent()),
    );
  }
}
