import 'package:dartz/dartz.dart';


import '../../../../core/errors/failures.dart';
import '../../domain/entities/direction.dart';
import '../../domain/repositories/direction_repository.dart';
import '../models/direction_model.dart';
import '../models/location_data_source.dart';

class DirectionRepositoryImpl implements DirectionRepository {
  final LocationDataSource locationDataSource;

  DirectionRepositoryImpl({required this.locationDataSource});

  @override
  Future<Either<Failure, Direction>> getDirection(double latitude, double longitude) async {
    try {
      final bearing = await locationDataSource.getDirectionToTemple(latitude, longitude);
      return Right(DirectionModel(bearing: bearing));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
