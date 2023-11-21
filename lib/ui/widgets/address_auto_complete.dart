import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/app_session.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_address_paging_rq.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_address_paging_rs.dart';
import 'package:flutter_store_catalog/core/services/bkoffc/master_service.dart';
import 'package:flutter_store_catalog/core/models/view/address_data.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_line_icon_icons.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard_wrapper.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';

class AddressAutoComplete extends StatefulWidget {
  Function callback;
  AddressData addressSelected;
  bool isEnabled;
  AddressAutoComplete({this.callback, this.isEnabled = true, this.addressSelected});

  @override
  _AddressAutoComplete createState() => _AddressAutoComplete();
}

class _AddressAutoComplete extends State<AddressAutoComplete> {
  List<AddressList> lstAddress = new List<AddressList>();
  String addressCondition = TypeOfAddress.ZIPCODE;
  //AddressData addressSelected;
  bool isSelected = false;
  TextEditingController controller;

  List<DropdownMenuItem<String>> optionsAddressCustomer = [
    DropdownMenuItem<String>(value: TypeOfAddress.SUBDISTRICT, child: Text('text.subdis'.tr())),
    DropdownMenuItem<String>(value: TypeOfAddress.DISTRICT, child: Text('text.dist'.tr())),
    DropdownMenuItem<String>(value: TypeOfAddress.PROVINCE, child: Text('text.province'.tr())),
    DropdownMenuItem<String>(value: TypeOfAddress.ZIPCODE, child: Text('text.zipcode'.tr())),
  ];
  @override
  void initState() {
    super.initState();
    controller = new TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildTextField(),
        //buildTextLabel()
      ],
    );
  }

  Widget buildTextField() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 49,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.normal.copyWith(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                contentPadding: EdgeInsets.only(left: 10),
              ),
              value: addressCondition,
              items: optionsAddressCustomer,
              icon: Icon(Icons.keyboard_arrow_down_outlined),
              onChanged: (val) {
                setState(() {
                  addressCondition = val;
                });
              },
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 9,
          child: buildTextFieldAfterChange(),
        ),
      ],
    );
  }

  Widget buildTextFieldAfterChange() {
      return VirtualKeyboardWrapper(
        textController: controller,
          keyboardType: addressCondition == TypeOfAddress.ZIPCODE ? VirtualKeyboardType.Numeric : VirtualKeyboardType.Alphanumeric,
          inputFormatters: [],
          builder: (textEditingController, focusNode, inputFormatters) {
            return TypeAheadField(
              direction: AxisDirection.up,
              textFieldConfiguration: TextFieldConfiguration(
                focusNode: focusNode,
                controller: textEditingController,
                inputFormatters: inputFormatters,
                style: Theme.of(context).textTheme.normal.copyWith(),
                scrollPadding: EdgeInsets.all(70),
                enabled: widget.isEnabled,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              hideSuggestionsOnKeyboardHide: true,
              getImmediateSuggestions: false,
              autoFlipDirection: false,
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                hasScrollbar: true,
                constraints: BoxConstraints(
                  maxHeight: 300,
                ),
              ),
              suggestionsCallback: (pattern) async {
                if (pattern.length < 3) return [];
                return onGetAddressPaging(pattern, addressCondition);
              },
              onSuggestionSelected: (suggestion) {
                onSubmitItem(suggestion);
              },
              noItemsFoundBuilder: (context) {
                return SizedBox.shrink();
              },
              itemBuilder: (context, itemData) {
                return Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Text(
                          itemData.subDistrictName,
                          style: Theme
                              .of(context)
                              .textTheme
                              .normal,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          itemData.districtName,
                          style: Theme
                              .of(context)
                              .textTheme
                              .normal,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          itemData.nameThai,
                          style: Theme
                              .of(context)
                              .textTheme
                              .normal,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          itemData.zipCode,
                          style: Theme
                              .of(context)
                              .textTheme
                              .normal,
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          });
  }

  void onSubmitItem(AddressList data) {
    setState(() {
      AddressData addressData = new AddressData();
      addressData.provice = data.nameThai;
      addressData.zipcode = data.zipCode;
      addressData.district = data.districtName;
      addressData.subDistrict = data.subDistrictName;
      addressData.type = TypeOfAddress.ADDRESS;
      widget.addressSelected = addressData;

      isSelected = true;
      controller.text = '';
      widget.callback(widget.addressSelected);
    });
  }

  Future<List<AddressList>> onGetAddressPaging(String searchTerm, String addressCondition) async {
    final MasterService _masterService = getIt<MasterService>();
    AppSession appSession = BlocProvider.of<ApplicationBloc>(context).state.appSession;

    GetAddressPagingRq getAddressPagingRq = GetAddressPagingRq();

    if (addressCondition == TypeOfAddress.ZIPCODE) {
      getAddressPagingRq.zipcode = searchTerm;
    }if (addressCondition == TypeOfAddress.PROVINCE) {
      getAddressPagingRq.province = searchTerm;
    }if (addressCondition == TypeOfAddress.DISTRICT) {
      getAddressPagingRq.district = searchTerm;
    }if (addressCondition == TypeOfAddress.SUBDISTRICT) {
      getAddressPagingRq.subDistrict = searchTerm;
    }
    getAddressPagingRq.lang = AddressFormat.THAI;
    getAddressPagingRq.startRow = SearchAddress.START_ROW;
    getAddressPagingRq.pageSize = SearchAddress.PAGE_SIZE;

    GetAddressPagingRs getAddressPagingRs = await _masterService.getAddressPaging(appSession, getAddressPagingRq);

    return getAddressPagingRs.addressList;
  }
}
