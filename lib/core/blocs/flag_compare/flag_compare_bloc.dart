import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'flag_compare_event.dart';
part 'flag_compare_state.dart';

class FlagCompareBloc extends Bloc<FlagCompareEvent, FlagCompareState> {
  @override
  FlagCompareState get initialState => FlagCompareState(false);

  @override
  Stream<FlagCompareState> mapEventToState(FlagCompareEvent event) async* {
    if (event is ToggleFlagCompareEvent) {
      yield* mapEventToggleFlagCompare(event);
    }
  }

  Stream<FlagCompareState> mapEventToggleFlagCompare(ToggleFlagCompareEvent event) async* {
    yield FlagCompareState(!state.isCompared);
  }
}

