import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

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

  @override
  void initState() {
    super.initState();
    _requestLocationAndFetchDirection();
    _listenToCompass(); // Start listening to the compass
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
      appBar: AppBar(title: Text('Temple of Solomon Direction')),
      body: RefreshIndicator(
        onRefresh: _requestLocationAndFetchDirection, // Use the existing method for refresh
        child: SingleChildScrollView( // Wrap BlocBuilder in a scrollable view for RefreshIndicator
          physics: const AlwaysScrollableScrollPhysics(), // Ensure scrolling is always possible
          child: BlocBuilder<DirectionBloc, DirectionState>(
            builder: (context, state) {
              if (state is InitialState) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: Text('Fetching your location...'),
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
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: DirectionWidget(direction: direction),
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
