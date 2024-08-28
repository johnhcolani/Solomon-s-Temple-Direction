import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../bloc/direction_bloc.dart';
import '../bloc/direction_event.dart';
import '../bloc/direction_state.dart';
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
  bool _isVideoPlaying = true; // Track whether the video is playing
  bool _showPlayPauseIcon = false; // Initially, the icon is not shown

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
    try {
      Position position = await Geolocator.getCurrentPosition(
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

  void _togglePlayPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
        _isVideoPlaying = false;
      } else {
        _videoController.play();
        _isVideoPlaying = true;
      }
      _showPlayPauseIcon = true; // Show the icon immediately on tap

      // Start a timer to fade out the icon after 1 second
      Timer(const Duration(seconds: 1), () {
        setState(() {
          _showPlayPauseIcon = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;
        double screenWidth = constraints.maxWidth;
        bool isTablet = screenWidth > 600;

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
                      return SizedBox(
                        height: screenHeight,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xff9dbaca))),
                              SizedBox(height: 16.0),
                              Text('Fetching your location...',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      );
                    } else if (state is LoadingState) {
                      return SizedBox(
                        height: screenHeight,
                        child: const CircularProgressIndicator(),
                      );
                    } else if (state is LoadedState) {
                      double direction = state.direction - _currentHeading;
                      return SafeArea(
                        child: SizedBox(
                          height: screenHeight,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  'Pray in this direction',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.merriweather(
                                    fontSize: isTablet ? 38 : 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xffe6e3e0),
                                  ),
                                ),
                              ),
                              const Divider(height: 20),
                              SizedBox(
                                height: isTablet
                                    ? 280
                                    : (Platform.isAndroid ? 170 : 190),
                                child: MyScrollablePages(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: screenWidth *0.85,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  //isTablet ? 280 : (Platform.isAndroid ? 120 : 240),
                                  height: isTablet
                                      ? screenHeight * 0.35
                                      : screenHeight * 0.25,

                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: _togglePlayPause,
                                          child: _videoController
                                                  .value.isInitialized
                                              ? Container(
                                                  constraints:
                                                      const BoxConstraints
                                                          .expand(),
                                                  child: FittedBox(
                                                    fit: BoxFit.cover,
                                                    child: SizedBox(
                                                      width: _videoController
                                                          .value.size.width,
                                                      height: _videoController
                                                          .value.size.height,
                                                      child: VideoPlayer(
                                                          _videoController),
                                                    ),
                                                  ),
                                                )
                                              : const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                        ),
                                        AnimatedOpacity(
                                          opacity:
                                              _showPlayPauseIcon ? 1.0 : 0.0,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: _isVideoPlaying
                                              ? const Icon(Icons.pause,
                                                  color: Colors.white, size: 50)
                                              : const Icon(Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 50),
                                        ),
                                        if (_isVideoFinished)
                                          IconButton(
                                            icon: const Icon(Icons.replay,
                                                color: Colors.white, size: 50),
                                            onPressed: () {
                                              _videoController
                                                  .seekTo(Duration.zero);
                                              _videoController.play();
                                              setState(() {
                                                _isVideoFinished = false;
                                                _isVideoPlaying = true;
                                              });
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                  height: isTablet
                                      ? screenHeight * 0.3
                                      : (Platform.isAndroid
                                          ? 220
                                          : screenHeight * 0.3),
                                  child: DirectionWidget(direction: direction)),
                              //SizedBox(height: isTablet ? 80 : (Platform.isAndroid ? 60 : 140)),
                            ],
                          ),
                        ),
                      );
                    } else if (state is ErrorState) {
                      return SizedBox(
                        height: screenHeight,
                        child: Center(child: Text(state.message)),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
