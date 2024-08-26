import 'package:flutter/material.dart';
import 'dart:math' as math;

class DirectionWidget extends StatelessWidget {
  final double direction; // Direction to the temple

  const DirectionWidget({super.key, required this.direction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Compass circle with degree markers
          const CompassCircle(),
          // Custom arrow pointing to the direction
          Transform.rotate(
            angle: direction * (math.pi / 180), // Convert direction to radians
            child: CustomPaint(
              size: const Size(120, 120), // Adjust size as needed
              painter: ArrowPainter(),
            ),
          ),
          // Circle with dot rotating to show the direction
          Transform.rotate(
            angle: direction * (math.pi / 180), // Convert direction to radians
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.withOpacity(0.5), width: 2),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Define arrow path
    Path path = Path();
    path.moveTo(size.width * 0.5, 0); // Arrow tip
    path.lineTo(size.width * 0.6, size.height * 0.4); // Right edge of the arrowhead
    path.lineTo(size.width * 0.5, size.height * 0.3); // Bottom middle of the arrowhead
    path.lineTo(size.width * 0.4, size.height * 0.4); // Left edge of the arrowhead
    path.close(); // Close path

    // Draw the path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CompassCircle extends StatelessWidget {
  const CompassCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,  // Increase the size of the container
      height: 270, // Increase the size of the container
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Generate small lines for degree markers
          ...List.generate(36, (index) {
            double angle = index * 10.0; // Angle in degrees
            return Transform.rotate(
              angle: angle * (math.pi / 180), // Convert to radians
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    width: 2,
                    height: 10,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }),
          // Display cardinal direction letters outside the degree markers
          const Positioned(
            top: 0, // Align to the top of the container
            child: Padding(
              padding: EdgeInsets.only(top: 15.0), // Add padding to move it outwards
              child: Text(
                'N',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const Positioned(
            right: 0, // Align to the right of the container
            child: Padding(
              padding: EdgeInsets.only(right: 15.0), // Add padding to move it outwards
              child: Text(
                'E',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          const Positioned(
            bottom: 0, // Align to the bottom of the container
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.0), // Add padding to move it outwards
              child: Text(
                'S',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          const Positioned(
            left: 0, // Align to the left of the container
            child: Padding(
              padding: EdgeInsets.only(left: 15.0), // Add padding to move it outwards
              child: Text(
                'W',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
