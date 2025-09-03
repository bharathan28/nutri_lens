import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:nutri_lens/bloc/camera/camera_bloc.dart';
import 'package:nutri_lens/bloc/food/food_bloc.dart';
import 'package:nutri_lens/bloc/nutrition/nutrition_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'data/datasources/food_remote_datasource.dart';
import 'data/datasources/food_local_datasource.dart';
import 'data/datasources/camera_datasource.dart';
import 'data/repositories/food_repository.dart';
import 'data/repositories/camera_repository.dart';
import 'data/repositories/nutrition_repository.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient(sl()));
  
  // Data sources
  sl.registerLazySingleton<FoodRemoteDataSource>(
    () => FoodRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FoodLocalDataSource>(
    () => FoodLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CameraDataSource>(
    () => CameraDataSourceImpl(),
  );
  
  // Repositories
  sl.registerLazySingleton<FoodRepository>(
    () => FoodRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<CameraRepository>(
    () => CameraRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<NutritionRepository>(
    () => NutritionRepositoryImpl(sl()),
  );
  
  // BLoCs
  sl.registerFactory(() => CameraBloc(sl()));
  sl.registerFactory(() => FoodBloc(sl()));
  sl.registerFactory(() => NutritionBloc(sl()));
}
