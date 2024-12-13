import 'package:equatable/equatable.dart';

class Direction extends Equatable {
  final double bearing;

  const Direction({required this.bearing});

  @override
  List<Object> get props => [bearing];
}
