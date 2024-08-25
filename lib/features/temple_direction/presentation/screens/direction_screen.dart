import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart';

import '../bloc/temple_direction_bloc.dart';
import '../bloc/temple_direction_event.dart';
import '../bloc/temple_direction_state.dart';
import '../widgets/direction_widget.dart';

class DirectionPage extends StatefulWidget {
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
    )..initialize().then((_) {
        setState(() {}); // Update UI after video is initialized
        _videoController.play(); // Auto-play the video
      })
    ..addListener((){
      setState(() {
        _isVideoFinished =_videoController.value.position >= _videoController.value.duration;
      });
    })
    ; // Start listening to the compass
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
      appBar: AppBar(title: const Text('Temple of Solomon Direction')),
      body: RefreshIndicator(
        onRefresh:
            _requestLocationAndFetchDirection, // Use the existing method for refresh
        child: SingleChildScrollView(
          // Wrap BlocBuilder in a scrollable view for RefreshIndicator
          physics:
              const AlwaysScrollableScrollPhysics(), // Ensure scrolling is always possible
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
                  child: CircularProgressIndicator(),
                );
              } else if (state is LoadedState) {
                // Adjust the arrow direction based on the current heading and the calculated direction to the temple
                double direction = state.direction - _currentHeading;
                return Container(
                  margin: EdgeInsets.all(24),
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'May your eyes be open toward this temple night and day, '
                          'this place of which you said, ‘My Name shall be there,’ '
                          'so that you will hear the prayer your servant prays toward this place.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '1 Kings 8:29',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        height: 220,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _videoController.value.isInitialized
                                  ? AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController),
                              )
                                  : Center(child: CircularProgressIndicator()),
                              if (_isVideoFinished)
                                IconButton(
                                  icon: Icon(Icons.play_arrow, color: Colors.white, size: 50),
                                  onPressed: () {
                                    _videoController.seekTo(Duration.zero); // Restart video
                                    _videoController.play(); // Play video
                                    setState(() {
                                      _isVideoFinished = false;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      DirectionWidget(direction: direction),
                    ],
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
    );
  }
}
