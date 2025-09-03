import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:nutri_lens/bloc/camera/camera_bloc.dart';
import 'package:nutri_lens/bloc/camera/camera_event.dart';
import 'package:nutri_lens/bloc/camera/camera_state.dart';
import 'package:nutri_lens/bloc/food/food_bloc.dart';
import 'package:nutri_lens/bloc/food/food_event.dart';

import '../../app/routes.dart';
import '../widgets/ar_overlay_widget.dart';
import '../widgets/camera_controls_widget.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CameraBloc>().add(CameraPermissionRequestedEvent());
  }

  @override
  void dispose() {
    context.read<CameraBloc>().add(DisposeCameraEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<CameraBloc, CameraState>(
        listener: (context, state) {
          if (state is CameraImageCaptured) {
            // Trigger food scanning
            context.read<FoodBloc>().add(ScanFoodEvent(state.imageFile));
            
            // Navigate to results screen
            Navigator.pushNamed(
              context,
              AppRoutes.results,
              arguments: {
                'imagePath': state.imageFile.path,
                'foodResult': null,
              },
            );
          } else if (state is CameraError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is CameraPermissionDenied) {
            _showPermissionDialog();
          }
        },
        builder: (context, state) {
          if (state is CameraLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 20),
                  Text(
                    'Initializing camera...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }

          if (state is CameraPermissionDenied) {
            return _buildPermissionDenied();
          }

          if (state is CameraError) {
            return _buildErrorState(state.message);
          }

          if (state is CameraReady || state is CameraCapturing) {
            final controller = (state is CameraReady) 
                ? state.controller 
                : ((state as CameraCapturing));
            
            return Stack(
              fit: StackFit.expand,
              children: [
                // Camera Preview
                if (state is CameraReady)
                  CameraPreview(state.controller),
                
                // AR Overlay
                AROverlayWidget(),
                
                // Camera Controls
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CameraControlsWidget(
                    isCapturing: state is CameraCapturing,
                    onCapture: () => context.read<CameraBloc>().add(CaptureImageEvent()),
                  ),
                ),
                
                // Back Button
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Container(); // Fallback
        },
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 20),
            Text(
              'Camera Permission Required',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We need camera access to scan food items',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.read<CameraBloc>().add(CameraPermissionRequestedEvent()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[400],
            ),
            SizedBox(height: 20),
            Text(
              'Camera Error',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.read<CameraBloc>().add(InitializeCameraEvent()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Permission'),
        content: Text('Camera access is required to scan food. Please enable it in settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Open app settings here if needed
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
