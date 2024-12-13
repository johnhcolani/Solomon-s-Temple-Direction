import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solomon_prayers_compass/features/temple_direction/presentation/bloc/direction_event.dart';
import 'package:solomon_prayers_compass/features/temple_direction/presentation/bloc/direction_state.dart';
import '../../domain/usecases/get_direction.dart';


class DirectionBloc extends Bloc<DirectionEvent, DirectionState> {
  final GetDirection getDirection;

  DirectionBloc({required this.getDirection}) : super(InitialState()) {
    // Register event handler for GetDirectionEvent
    on<GetDirectionEvent>((event, emit) async {
      emit(LoadingState());
      final failureOrDirection = await getDirection(
        Params(latitude: event.latitude, longitude: event.longitude),
      );

      failureOrDirection.fold(
            (failure) => emit(ErrorState("Could not get direction")),
            (direction) => emit(LoadedState(direction.bearing)),
      );
    });
  }
}
