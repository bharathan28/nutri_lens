import 'package:flutter/material.dart';

class AROverlayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scanning Frame
        Center(
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                // Corner indicators
                ...List.generate(4, (index) {
                  return Positioned(
                    top: index < 2 ? 10 : null,
                    bottom: index >= 2 ? 10 : null,
                    left: index % 2 == 0 ? 10 : null,
                    right: index % 2 == 1 ? 10 : null,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                          width: 3,
                        ),
                      ),
                    ),
                  );
                }),
                
                // Center crosshair
                Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    child: Stack(
                      children: [
                        // Horizontal line
                        Positioned(
                          top: 14,
                          left: 5,
                          right: 5,
                          child: Container(
                            height: 2,
                            color: Colors.green,
                          ),
                        ),
                        // Vertical line
                        Positioned(
                          left: 14,
                          top: 5,
                          bottom: 5,
                          child: Container(
                            width: 2,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Instructions overlay
        Positioned(
          top: 120,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Point camera at food',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'Keep food within the green frame',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Animated scanning line
        AnimatedScanLine(),
      ],
    );
  }
}

class AnimatedScanLine extends StatefulWidget {
  @override
  _AnimatedScanLineState createState() => _AnimatedScanLineState();
}

class _AnimatedScanLineState extends State<AnimatedScanLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final centerY = screenHeight / 2;
        final scanAreaHeight = 280.0;
        final startY = centerY - (scanAreaHeight / 2);
        final endY = centerY + (scanAreaHeight / 2);
        
        final currentY = startY + (endY - startY) * _animation.value;
        
        return Positioned(
          top: currentY,
          left: (MediaQuery.of(context).size.width - 280) / 2,
          child: Container(
            width: 280,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.green.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
