import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colored_progress_indicators/flutter_colored_progress_indicators.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/room_category/room_category_bloc.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/ecat/get_room_category_rs.dart';
import 'package:flutter_store_catalog/core/services/ecat/category_service.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/views/layout.dart';
import 'package:flutter_store_catalog/ui/widgets/custom_back_to_top_button.dart';
import 'package:flutter_store_catalog/ui/widgets/home_tab_sticky_builder.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_store_catalog/ui/router.dart';
import 'package:easy_localization/easy_localization.dart';

class Room {
  static const num bathRoom = 1;
  static const num bedRoom = 2;
  static const num garden = 3;
  static const num livingRoom = 4;
  static const num kitchen = 5;
}

List<RoomModel> roomStyles = [
  RoomModel(Color(0xFF2882A4), 1),
  RoomModel(Color(0xFFFFB030), 2),
  RoomModel(Color(0xFF97C45D), 3),
  RoomModel(Color(0xFFFFA88D), 4),
  RoomModel(Color(0xFF787878), 5),
];

class RoomModel {
  final Color color;
  final num roomSeq;

  const RoomModel(this.color, this.roomSeq);
}

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> with TickerProviderStateMixin {
  AutoScrollController scrollController;
  TextEditingController searchBrandController;
  TabController tabController;
  RoomCategoryBloc roomCategoryBloc;
  bool visibleColorMaskOnTap = false;

  @override
  void initState() {
    super.initState();
    scrollController = AutoScrollController();
    searchBrandController = TextEditingController();
    tabController = TabController(length: HomeTabStickyBuilder.tabs.length, vsync: this, initialIndex: 2);
  }

  @override
  dispose() {
    scrollController?.dispose();
    tabController?.dispose();
    roomCategoryBloc?.close();
    super.dispose();
  }

  void onDestinationSelected(int index) {
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Home, (route) => false, arguments: {'isGoToCategoryTab': true});
    } else if (index == 1) {
      Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Brands, (route) => false);
    }
  }

  onTapRoom(num roomSeq) {
    print('Room seq: $roomSeq');
    roomCategoryBloc.add(SearchRoomCategoryEvent(roomSeq: roomSeq));
  }

  onChangePage(RoomList roomSelected) {
    Color roomColor = roomStyles.where((e) => e.roomSeq == roomSelected.roomSeq)?.first?.color;

    Navigator.of(context).pushNamed(
      WebRoutePaths.Room,
      arguments: {
        'backgroundColor': roomColor ?? colorHomeProBackground,
        'roomSelected': roomSelected,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => roomCategoryBloc = RoomCategoryBloc(BlocProvider.of<ApplicationBloc>(context))..add(FetchRoomCategoryEvent()),
      child: BlocListener<RoomCategoryBloc, RoomCategoryState>(
        bloc: roomCategoryBloc,
        listener: (context, state) async {
          if (state is ErrorRoomCategoryState) {
            DialogUtil.showErrorDialog(context, state.error);
          } else if (state is SearchRoomCategorySuccessState) {
            onChangePage(state.roomSelected);
          }
        },
        child: CommonLayout(
          body: Scaffold(
            body: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                controller: scrollController,
                children: [
                  HomeTabStickyBuilder(
                    scrollController: scrollController,
                    tabController: tabController,
                    onDestinationSelected: onDestinationSelected,
                    body: buildBody(),
                  ),
                ],
              ),
            ),
            floatingActionButton: CustomBackToTopButton(scrollController: scrollController),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return BlocBuilder<RoomCategoryBloc, RoomCategoryState>(
      bloc: roomCategoryBloc,
      builder: (context, state) {
        if (state is LoadingRoomCategoryState) {
          return Column(
            children: [
              Container(
                width: MediaQuery.maybeOf(context).size.width,
                height: MediaQuery.maybeOf(context).size.height,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    height: 64,
                    width: 64,
                    child: ColoredCircularProgressIndicator(strokeWidth: 8),
                  ),
                ),
              ),
            ],
          );
        }

        return Stack(
          children: [
            buildBlank(),
            buildMainRoomBg(),
          ],
        );
      },
    );
  }

  Widget buildMainRoomBg() {
    bool isPortrait = MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width;
    if (isPortrait) {
      return Container(
        child: Stack(
          children: [
            buildRoomBgImage('room_bg_portrait.png'),
            buildMaskOnTapPortrait(),
          ],
        ),
      );
    }

    return Container(
      child: Stack(
        children: [
          buildRoomBgImage('room_bg.png'),
          buildMaskOnTapLandscape(),
        ],
      ),
    );
  }

  Widget buildRoomBgImageByUrl() {
    String imgRooms = LanguageUtil.isTh(context) ? 'PNG_BYROOM_TH' : 'PNG_BYROOM_EN';

    return FadeInImage.assetNetwork(
      fit: BoxFit.cover,
      placeholder: '',
      placeholderErrorBuilder: (context, error, stackTrace) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            height: 64,
            width: 64,
            child: ColoredCircularProgressIndicator(strokeWidth: 8),
          ),
        );
      },
      image: getIt<CategoryService>().getImageByKeyUrl(imgRooms),
      imageErrorBuilder: (context, error, stackTrace) {
        return Container();
      },
    );
  }

  Widget buildRoomBgImage(String imgName) {
    return Stack(
      children: [
        Positioned.fill(child: Container(color: Colors.grey[50])),
        Image.asset('assets/images/${context.locale.toString()}/$imgName'),
      ],
    );
  }

  Widget buildMaskOnTapLandscape() {
    return Positioned.fill(
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onTapRoom(Room.garden),
                    child: Container(
                      color: visibleColorMaskOnTap ? Colors.blue.withOpacity(0.5) : null,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => onTapRoom(Room.bathRoom),
                          child: Container(
                            color: visibleColorMaskOnTap ? Colors.red.withOpacity(0.5) : null,
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => onTapRoom(Room.livingRoom),
                          child: Container(
                            color: visibleColorMaskOnTap ? Colors.green.withOpacity(0.5) : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onTapRoom(Room.bedRoom),
                    child: Container(
                      color: visibleColorMaskOnTap ? Colors.purple.withOpacity(0.5) : null,
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => onTapRoom(Room.kitchen),
                    child: Container(
                      color: visibleColorMaskOnTap ? Colors.orange.withOpacity(0.5) : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMaskOnTapPortrait() {
    return Positioned.fill(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onTapRoom(Room.bathRoom),
                    child: Container(
                      color: visibleColorMaskOnTap ? Colors.blue.withOpacity(0.5) : null,
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => onTapRoom(Room.bedRoom),
                    child: Container(
                      color: visibleColorMaskOnTap ? Colors.red.withOpacity(0.5) : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onTapRoom(Room.livingRoom),
              child: Container(
                color: visibleColorMaskOnTap ? Colors.green.withOpacity(0.5) : null,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: InkWell(
                    onTap: () => onTapRoom(Room.garden),
                    child: Container(
                      color: visibleColorMaskOnTap ? Colors.orange.withOpacity(0.5) : null,
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: InkWell(
                    onTap: () => onTapRoom(Room.kitchen),
                    child: Container(
                      color: visibleColorMaskOnTap ? Colors.purple.withOpacity(0.5) : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBlank() {
    return Container(
      height: MediaQuery.maybeOf(context).size.height,
      color: Color(0xFFA0B9C2).withOpacity(0.55),
    );
  }
}
