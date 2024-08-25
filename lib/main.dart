import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/temple_direction/data/models/location_data_source.dart';
import 'features/temple_direction/data/repository/temple_direction_repository_impl.dart';
import 'features/temple_direction/domain/usecases/get_direction.dart';
import 'features/temple_direction/presentation/bloc/temple_direction_bloc.dart';
import 'features/temple_direction/presentation/screens/direction_screen.dart';

void main() {
  runApp(const SolomonTempleApp());
}

class SolomonTempleApp extends StatelessWidget {
  const SolomonTempleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temple of Solomon Direction',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
          create: (context)=> DirectionBloc(
              getDirection: GetDirection(
                  DirectionRepositoryImpl(
                    locationDataSource: LocationDataSource(),
                  ))),
          child: DirectionPage()),
    );
  }
}
