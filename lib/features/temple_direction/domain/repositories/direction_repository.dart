import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/direction.dart';

abstract class DirectionRepository {
  Future<Either<Failure, Direction>> getDirection(double latitude, double longitude);
}
