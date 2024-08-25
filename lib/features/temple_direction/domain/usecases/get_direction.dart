import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/usecase.dart';
import '../entities/direction.dart';
import '../repositories/direction_repository.dart';

class GetDirection implements UseCase<Direction, Params> {
  final DirectionRepository repository;

  GetDirection(this.repository);

  @override
  Future<Either<Failure, Direction>> call(Params params) async {
    return await repository.getDirection(params.latitude, params.longitude);
  }
}

class Params {
  final double latitude;
  final double longitude;

  Params({required this.latitude, required this.longitude});
}
