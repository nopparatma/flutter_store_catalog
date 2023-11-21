part of 'room_category_bloc.dart';

@immutable
abstract class RoomCategoryState {}

class InitialRoomCategoryState extends RoomCategoryState {}

class LoadingRoomCategoryState extends RoomCategoryState {}

class ErrorRoomCategoryState extends RoomCategoryState {
  final dynamic error;

  ErrorRoomCategoryState(this.error);

  @override
  String toString() {
    return 'ErrorRoomCategoryState{error: $error}';
  }
}

class SearchRoomCategorySuccessState extends RoomCategoryState {
  final RoomList roomSelected;

  SearchRoomCategorySuccessState({this.roomSelected});

  @override
  String toString() {
    return 'SearchRoomCategorySuccessState{roomSelected: $roomSelected}';
  }
}

class FetchRoomCategorySuccessState extends RoomCategoryState {
  FetchRoomCategorySuccessState();

  @override
  String toString() {
    return 'FetchRoomCategorySuccessState{}';
  }
}
