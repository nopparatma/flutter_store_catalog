import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_store_catalog/core/utilities/shared_pref_util.dart';
import 'package:meta/meta.dart';

part 'flag_keyboard_event.dart';

part 'flag_keyboard_state.dart';

class FlagKeyboardBloc extends Bloc<FlagKeyboardEvent, FlagKeyboardState> {
  @override
  FlagKeyboardState get initialState => FlagKeyboardState(true);

  static const String SHARED_PREF_FLAG_KEYBOARD = 'SHARED_PREF_FLAG_KEYBOARD';

  @override
  Stream<FlagKeyboardState> mapEventToState(FlagKeyboardEvent event) async* {
    if (event is LoadFlagKeyboardEvent) {
      yield* mapEventLoadFlagKeyboard(event);
    } else if (event is ToggleFlagKeyboardEvent) {
      yield* mapEventToggleFlagKeyboard(event);
    }
  }

  Stream<FlagKeyboardState> mapEventLoadFlagKeyboard(LoadFlagKeyboardEvent event) async* {
    if (await SharedPrefUtil.containsKey(SHARED_PREF_FLAG_KEYBOARD)) {
      bool flagKeyboard = await SharedPrefUtil.read(SHARED_PREF_FLAG_KEYBOARD);
      yield FlagKeyboardState(flagKeyboard);
    } else {
      yield FlagKeyboardState(true);
    }
  }

  Stream<FlagKeyboardState> mapEventToggleFlagKeyboard(ToggleFlagKeyboardEvent event) async* {
    bool isEnabledNextState = !state.isEnabled;
    await SharedPrefUtil.save(SHARED_PREF_FLAG_KEYBOARD, isEnabledNextState);
    yield FlagKeyboardState(isEnabledNextState);
  }
}
