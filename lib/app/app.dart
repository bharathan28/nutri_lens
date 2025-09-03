import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_lens/bloc/camera/camera_bloc.dart';
import 'package:nutri_lens/bloc/food/food_bloc.dart';
import 'package:nutri_lens/bloc/nutrition/nutrition_bloc.dart';
import '../injection_container.dart' as di;
import '../presentation/screens/home_screen.dart';
import 'routes.dart';

class NutriLensApp extends StatelessWidget {
  const NutriLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CameraBloc>(create: (context) => di.sl<CameraBloc>()),
        BlocProvider<FoodBloc>(create: (context) => di.sl<FoodBloc>()),
        BlocProvider<NutritionBloc>(create: (context) => di.sl<NutritionBloc>()),
      ],
      child: MaterialApp(
        title: 'NutriLens - AR Food Scanner',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green[600],
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: HomeScreen(),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
