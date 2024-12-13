import 'package:equatable/equatable.dart';

abstract class DirectionState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends DirectionState {}

class LoadingState extends DirectionState {}

class LoadedState extends DirectionState {
  final double direction;

  LoadedState(this.direction);

  @override
  List<Object> get props => [direction];
}

class ErrorState extends DirectionState {
  final String message;

  ErrorState(this.message);

  @override
  List<Object> get props => [message];
}
