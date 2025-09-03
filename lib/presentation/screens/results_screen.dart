import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutri_lens/bloc/food/food_bloc.dart';
import 'package:nutri_lens/bloc/food/food_event.dart';
import 'package:nutri_lens/bloc/food/food_state.dart';
import 'package:nutri_lens/bloc/nutrition/nutrition_bloc.dart';
import 'package:nutri_lens/bloc/nutrition/nutrition_event.dart';
import 'dart:io';
import '../../data/models/scan_result_model.dart';
import '../widgets/nutrition_card_widget.dart';
import '../widgets/common_widgets.dart';

class ResultsScreen extends StatelessWidget {
  final String imagePath;
  final ScanResultModel? foodResult;

  const ResultsScreen({
    Key? key,
    required this.imagePath,
    this.foodResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Results'),
        backgroundColor: Colors.green[600],
        elevation: 0,
      ),
      body: BlocConsumer<FoodBloc, FoodState>(
        listener: (context, state) {
          if (state is FoodAddedToDaily) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Food added to daily tracking!'),
                backgroundColor: Colors.green,
              ),
            );
            // Update nutrition bloc
            context.read<NutritionBloc>().add(LoadDailyProgressEvent());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(),
                SizedBox(height: 20),
                _buildResultSection(context, state),
                SizedBox(height: 30),
                _buildActionButtons(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildResultSection(BuildContext context, FoodState state) {
    if (state is FoodLoading) {
      return Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            CircularProgressIndicator(color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Analyzing food...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Our AI is identifying the food and calculating nutrition',
              style: TextStyle(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state is FoodScanSuccess) {
      final food = state.scanResult.food;
      if (food != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food identification
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 30),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        Text(
                          'Confidence: ${(state.scanResult.confidence * 100).toInt()}%',
                          style: TextStyle(
                            color: Colors.green[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Nutrition information
            Text(
              'Nutrition Information (per 100g)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 15),
            
            NutritionCardWidget(
              calories: food.caloriesPer100g,
              protein: food.proteinPer100g,
              carbs: food.carbsPer100g,
              fat: food.fatPer100g,
            ),
          ],
        );
      }
    }

    if (state is FoodScanError) {
      return ErrorWidget(
        message: state.message,
        onRetry: () {
          context.read<FoodBloc>().add(ScanFoodEvent(File(imagePath)));
        },
      );
    }

    return Container();
  }

  Widget _buildActionButtons(BuildContext context, FoodState state) {
    return Column(
      children: [
        if (state is FoodScanSuccess && state.scanResult.food != null)
          ElevatedButton(
            onPressed: () {
              final food = state.scanResult.food!;
              context.read<FoodBloc>().add(AddFoodToDailyEvent(
                protein: food.proteinPer100g,
                calories: food.caloriesPer100g,
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Add to Daily Tracking',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        
        SizedBox(height: 15),
        
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.green[600]!),
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            'Scan Another Food',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
