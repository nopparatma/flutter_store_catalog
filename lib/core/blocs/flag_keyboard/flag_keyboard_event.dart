part of 'flag_keyboard_bloc.dart';

@immutable
abstract class FlagKeyboardEvent {}

class LoadFlagKeyboardEvent extends FlagKeyboardEvent {}

class ToggleFlagKeyboardEvent extends FlagKeyboardEvent {}
