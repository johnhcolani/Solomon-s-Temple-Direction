import 'dart:io';
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
          // Image pointing to the direction, rotated by 180 degrees
          Transform.rotate(
            angle: direction * (math.pi / 180) + math.pi, // Convert direction to radians and rotate 180 degrees
            child: Image.asset(
              'assets/images/Image.png', // Path to your image
              width: 120, // Adjust size as needed
              height: 120, // Adjust size as needed
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
                    color: Colors.amber,
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

class CompassCircle extends StatelessWidget {
  const CompassCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Platform.isIOS ? 270 : 240, // Increase the size of the container
      height: Platform.isIOS ? 270 : 240, // Increase the size of the container
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
                    color: const Color(0xff9dbaca),
                  ),
                ),
              ),
            );
          }),
          // Display cardinal direction letters outside the degree markers
          const Positioned(
            top: 0, // Align to the top of the container
            child: Padding(
              padding: EdgeInsets.only(top: 5.0), // Add padding to move it outwards
              child: Text(
                'N',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
          ),
          const Positioned(
            right: 0, // Align to the right of the container
            child: Padding(
              padding: EdgeInsets.only(right: 15.0), // Add padding to move it outwards
              child: Text(
                'E',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const Positioned(
            bottom: 0, // Align to the bottom of the container
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.0), // Add padding to move it outwards
              child: Text(
                'S',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const Positioned(
            left: 0, // Align to the left of the container
            child: Padding(
              padding: EdgeInsets.only(left: 10.0), // Add padding to move it outwards
              child: Text(
                'W',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
