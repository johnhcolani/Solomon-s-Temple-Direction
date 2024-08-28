import 'package:equatable/equatable.dart';

abstract class DirectionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetDirectionEvent extends DirectionEvent {
  final double latitude;
  final double longitude;

  GetDirectionEvent(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}
