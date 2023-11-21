part of 'room_category_bloc.dart';

@immutable
abstract class RoomCategoryEvent {}

class SearchRoomCategoryEvent extends RoomCategoryEvent {
  final num roomSeq;

  SearchRoomCategoryEvent({this.roomSeq});

  @override
  String toString() {
    return 'SearchRoomCategoryEvent{roomSeq: $roomSeq}';
  }
}

class FetchRoomCategoryEvent extends RoomCategoryEvent {
  @override
  String toString() {
    return 'FetchRoomCategoryEvent{}';
  }
}
