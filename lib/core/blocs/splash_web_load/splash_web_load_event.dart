part of 'splash_web_load_bloc.dart';

@immutable
abstract class SplashWebLoadEvent {}

class SplashWebLoadInitEvent extends SplashWebLoadEvent {
  final String token;

  SplashWebLoadInitEvent(this.token);

  @override
  String toString() {
    return 'SplashWebLoadInitEvent{token: $token}';
  }
}
