part of 'splash_web_load_bloc.dart';

@immutable
abstract class SplashWebLoadState {}

class InitialSplashWebLoadState extends SplashWebLoadState {
  @override
  String toString() {
    return 'InitialSplashWebLoadState{}';
  }
}

class LoadingSplashWebLoadState extends SplashWebLoadState {
  final String mode;

  LoadingSplashWebLoadState(this.mode);

  @override
  String toString() {
    return 'LoadingSplashWebLoadState{}';
  }
}

class ErrorSplashWebLoadState extends SplashWebLoadState {
  final dynamic error;

  ErrorSplashWebLoadState(this.error);

  @override
  String toString() {
    return 'ErrorSplashWebLoadState{error: $error}';
  }
}

class SuccessSplashWebLoadState extends SplashWebLoadState {
  @override
  String toString() {
    return 'SuccessSplashWebLoadState{}';
  }
}
