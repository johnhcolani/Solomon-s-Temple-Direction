import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitialState()) {
    on<StartSplashEvent>((event, emit) async {
      // Simulate a delay to show the splash screen
      await Future.delayed(const Duration(seconds: 3));
      emit(SplashFinishedState());
    });
  }
}
