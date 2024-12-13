
import '../../domain/entities/direction.dart';

class DirectionModel extends Direction {
  const DirectionModel({required super.bearing});

  factory DirectionModel.fromJson(Map<String, dynamic> json) {
    return DirectionModel(bearing: json['bearing']);
  }

  Map<String, dynamic> toJson() {
    return {'bearing': bearing};
  }
}
