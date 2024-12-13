import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/splash_bloc/splash_bloc.dart';
import '../bloc/splash_bloc/splash_event.dart';
import '../bloc/splash_bloc/splash_state.dart';
import 'direction_screen.dart';
 // Import your DirectionPage here

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SplashBloc()..add(StartSplashEvent()),
        child: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is SplashFinishedState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DirectionPage()),
              );
            }
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration:  const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/splash_background.png'),

              fit: BoxFit.fill,
              )
            ),
            // Background color
            child: SafeArea(
              child: Column(

                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 250),
                    child: Text(
                      'Solomon\nPrayer Compass',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.merriweather(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: const Offset(4.0, 4.0),
                            blurRadius: 10.0,
                            color: Colors.amber.withOpacity(0.5)
                          )
                        ]
                      )

                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
