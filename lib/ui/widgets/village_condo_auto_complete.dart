import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_master_village_condo_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_master_village_condo_rs.dart';
import 'package:flutter_store_catalog/core/models/user_profile.dart';
import 'package:flutter_store_catalog/core/models/view/address_data.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/tms_service.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard_wrapper.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../shared/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class VillageCondoAutoComplete extends StatefulWidget {
  Function callback;
  TextEditingController villageController;
  String name;

  VillageCondoAutoComplete({this.callback, this.villageController, this.name});

  @override
  _VillageCondoAutoComplete createState() => _VillageCondoAutoComplete();
}

class _VillageCondoAutoComplete extends State<VillageCondoAutoComplete> {
  bool isSelected;
  InputDecoration inputDecoration;
  FocusNode focusNode;
  TextEditingController controller;


  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
      setFocus();
    });
    controller = new TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  void setFocus() {
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  Widget build(BuildContext context) {
    isSelected = isSelected ?? false;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [buildTextField()],
      ),
    );
  }

  Widget buildTextField() {
    if (isSelected) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('text.village'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                VirtualKeyboardWrapper(
                  textController: controller,
                  maxLength: 40,
                  builder: (textEditingController, focusNode, inputFormatters) {
                    return TextField(
                      enabled: !isSelected,
                      focusNode: focusNode,
                      controller: textEditingController,
                      inputFormatters: inputFormatters,
                      style: Theme.of(context).textTheme.normal.copyWith(),
                      decoration: InputDecoration(
                        fillColor: !isSelected ? Colors.white : colorGrey4,
                        filled: isSelected,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 27,left: 5),
            child: Material(
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: IconButton(
                  icon: const Icon(MdiIcons.trashCanOutline),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      isSelected = false;
                      widget.callback(null);
                      widget.villageController.text = '';
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('text.village'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
          VirtualKeyboardWrapper(
            textController: widget.villageController,
            maxLength: 40,
            builder: (textEditingController, focusNode, inputFormatters) {
              return TypeAheadField(
                direction: AxisDirection.up,
                textFieldConfiguration: TextFieldConfiguration(
                  style: Theme.of(context).textTheme.normal.copyWith(),
                  focusNode: focusNode,
                  controller: textEditingController,
                  scrollPadding: EdgeInsets.all(70),
                  autofocus: false,
                  inputFormatters: inputFormatters,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                hideSuggestionsOnKeyboardHide: true,
                getImmediateSuggestions: false,
                autoFlipDirection: true,
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  hasScrollbar: true,
                  constraints: BoxConstraints(
                    maxHeight: 300,
                  ),
                ),
                keepSuggestionsOnLoading: false,
                loadingBuilder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                },
                suggestionsCallback: (pattern) async {
                  if (pattern.length < 3) return [];
                  return onGetMasterVillageCondo(pattern);
                },
                onSuggestionSelected: (suggestion) {
                  setItemData(suggestion);
                },
                noItemsFoundBuilder: (context) {
                  return SizedBox.shrink();
                },
                itemBuilder: (context, itemData) {
                  return Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
                    padding: EdgeInsets.only(bottom: 8, top: 8, left: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${itemData.geoNameTH} ${itemData.geoProv}',
                            style: Theme.of(context).textTheme.small,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      );
    }
  }

  void setItemData(dynamic suggestion) {
    setState(() {
      isSelected = true;
      AddressData addressData = new AddressData();
      addressData.provice = suggestion.geoProv;
      addressData.zipcode = suggestion.geoZipcode;
      addressData.district = suggestion.geoDist;
      addressData.subDistrict = suggestion.geoSubdist;
      addressData.lat = num.parse(suggestion.geoLat);
      addressData.lon = num.parse(suggestion.geoLon);
      addressData.placeId = suggestion.geoID;
      addressData.geoName = suggestion.geoNameTH;
      addressData.type = TypeOfAddress.VILLAGE;
      widget.callback(addressData);
      controller.text = suggestion.geoNameTH;
    });
  }

  Future<List<GetMasterVillageCondoGeoList>> onGetMasterVillageCondo(String geoName) async {
    AppSession appSession = BlocProvider.of<ApplicationBloc>(context).state.appSession;

    final TMSService _tmsService = getIt<TMSService>();

    GetMasterVillageCondoRq rq = GetMasterVillageCondoRq();
    rq.geoDesc = geoName;
    rq.startRow = GetMasterVillageCondo.START_ROW;
    rq.pageSize = GetMasterVillageCondo.PAGE_SIZE;
    rq.geoType = [GetMasterVillageCondoGeoType(geoTypeCode: '001'), GetMasterVillageCondoGeoType(geoTypeCode: '002')];
    GetMasterVillageCondoRs rs = await _tmsService.getMasterVillageCondo(appSession, rq);
    return rs.geoList;
  }
}
