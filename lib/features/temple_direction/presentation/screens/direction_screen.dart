import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../bloc/temple_direction_bloc.dart';
import '../bloc/temple_direction_event.dart';
import '../bloc/temple_direction_state.dart';
import '../widgets/direction_widget.dart';
import '../widgets/my_scrollable_pages.dart';

class DirectionPage extends StatefulWidget {
  const DirectionPage({super.key});

  @override
  _DirectionPageState createState() => _DirectionPageState();
}

class _DirectionPageState extends State<DirectionPage> {
  double _currentHeading = 0.0; // Device's heading
  late VideoPlayerController _videoController;
  bool _isVideoFinished = false;

  @override
  void initState() {
    super.initState();
    _requestLocationAndFetchDirection();
    _listenToCompass();
    // Initialize the video player controller with the asset video
    _videoController = VideoPlayerController.asset(
      'assets/videos/solomon_temple.mp4', // Path to the video file in assets
    )
      ..initialize().then((_) {
        setState(() {}); // Update UI after video is initialized
        _videoController.play(); // Auto-play the video
      })
      ..addListener(() {
        setState(() {
          _isVideoFinished = _videoController.value.position >=
              _videoController.value.duration;
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose(); // Dispose of the controller
    super.dispose();
  }

  Future<void> _requestLocationAndFetchDirection() async {
    print("Checking location services...");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission denied forever.");
      return;
    }

    print("Getting current location...");
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("Current location: ${position.latitude}, ${position.longitude}");
      context.read<DirectionBloc>().add(GetDirectionEvent(
        position.latitude,
        position.longitude,
      ));
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _listenToCompass() {
    FlutterCompass.events?.listen((event) {
      setState(() {
        _currentHeading = event.heading ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0d2938), // Start color
              Color(0xff2e6e8c), // End color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _requestLocationAndFetchDirection,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: BlocBuilder<DirectionBloc, DirectionState>(
              builder: (context, state) {
                if (state is InitialState) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: const Text('Fetching your location...'),
                  );
                } else if (state is LoadingState) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                } else if (state is LoadedState) {
                  double direction = state.direction - _currentHeading;
                  return SafeArea(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              'Pray in this direction',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.merriweather(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xffe6e3e0),
                              ),
                            ),
                          ),
                          const Divider(height: 20),
                          Expanded(
                            flex: 1,
                            child: MyScrollablePages(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              height: Platform.isIOS ? 215 : 170,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    _videoController.value.isInitialized
                                        ? AspectRatio(
                                      aspectRatio:
                                      _videoController.value.aspectRatio,
                                      child: VideoPlayer(_videoController),
                                    )
                                        : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    if (_isVideoFinished)
                                      IconButton(
                                        icon: const Icon(Icons.play_arrow,
                                            color: Colors.white, size: 50),
                                        onPressed: () {
                                          _videoController.seekTo(Duration.zero);
                                          _videoController.play();
                                          setState(() {
                                            _isVideoFinished = false;
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          DirectionWidget(direction: direction),
                          SizedBox(height: Platform.isAndroid ? 60 : 140),
                        ],
                      ),
                    ),
                  );
                } else if (state is ErrorState) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: Text(state.message),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
