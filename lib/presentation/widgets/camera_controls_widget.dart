import 'package:flutter/material.dart';

class CameraControlsWidget extends StatelessWidget {
  final bool isCapturing;
  final VoidCallback onCapture;

  const CameraControlsWidget({
    Key? key,
    required this.isCapturing,
    required this.onCapture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Capture Button
          GestureDetector(
            onTap: isCapturing ? null : onCapture,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: isCapturing
                  ? Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        color: Colors.green,
                        strokeWidth: 3,
                      ),
                    )
                  : Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                      size: 40,
                    ),
            ),
          ),
          
          SizedBox(height: 15),
          
          // Instructions
          Text(
            isCapturing ? 'Analyzing food...' : 'Tap to scan food',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          if (!isCapturing) ...[
            SizedBox(height: 5),
            Text(
              'Make sure food is well lit and in focus',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
