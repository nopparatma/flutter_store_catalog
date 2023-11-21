import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/basket/basket_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/create_customer/create_customer_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/flag_keyboard/flag_keyboard_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/save_sale_cart/save_sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/get_customer_titles_rs.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/models/view/address_data.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/widgets/address_auto_complete.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/ui/widgets/plot_map.dart';
import 'package:flutter_store_catalog/ui/widgets/village_condo_auto_complete.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard_wrapper.dart';

class CreateCustomer extends StatefulWidget {
  final String createMode;
  final Customer customer;
  final num salesCartOid;
  final String phoneNo;

  CreateCustomer(this.createMode, {this.customer, this.salesCartOid, this.phoneNo});

  _CreateCustomer createState() => _CreateCustomer();
}

final List<DropdownMenuItem<String>> custTypeItems = [
  DropdownMenuItem<String>(value: TypeOfBillTo.NITI_PERSON, child: Text('text.niti_person'.tr())),
  DropdownMenuItem<String>(value: TypeOfBillTo.GENERAL_PERSON, child: Text('text.general_person'.tr())),
];

final List<DropdownMenuItem<String>> idTypeItems = [
  DropdownMenuItem<String>(value: TypeOfBillTo.CITIZEN_CARD, child: Text('text.id_card'.tr())),
  DropdownMenuItem<String>(value: TypeOfBillTo.PASSPORT_CARD, child: Text('text.passport'.tr())),
];

final List<DropdownMenuItem<String>> branchTypeItems = [
  DropdownMenuItem<String>(value: TypeOfBillTo.HEAD_OFFICE, child: Text('text.head_office'.tr())),
  DropdownMenuItem<String>(value: TypeOfBillTo.STORE, child: Text('text.store'.tr())),
  DropdownMenuItem<String>(value: TypeOfBillTo.OTHER, child: Text('text.other'.tr())),
];

class _CreateCustomer extends State<CreateCustomer> {
  CreateCustomerBloc createCustomerBloc;
  final _formKey = GlobalKey<FormState>();
  List<CustomerTitle> lstCustomerTitles;

  TextEditingController _fname = new TextEditingController();
  TextEditingController _fnameCom = new TextEditingController();
  TextEditingController _lname = new TextEditingController();
  TextEditingController _number = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _idCard = new TextEditingController();
  TextEditingController _passportId = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _unit = new TextEditingController();
  TextEditingController _floor = new TextEditingController();
  TextEditingController _village = new TextEditingController();
  TextEditingController _descr = new TextEditingController();
  TextEditingController _moo = new TextEditingController();
  TextEditingController _soi = new TextEditingController();
  TextEditingController _street = new TextEditingController();
  TextEditingController _building = new TextEditingController();
  TextEditingController _lat = new TextEditingController();
  TextEditingController _lon = new TextEditingController();
  TextEditingController _subDistrict = new TextEditingController();
  TextEditingController _district = new TextEditingController();
  TextEditingController _province = new TextEditingController();
  TextEditingController _zipCode = new TextEditingController();
  TextEditingController _branchId = new TextEditingController();
  TextEditingController _branchDesc = new TextEditingController();

  //Location location = new Location();
  //LocationData userLocation;
  AddressData addressSelected;
  bool isSelectedVillage = false;
  String branchTypeSelect = TypeOfBillTo.HEAD_OFFICE;
  String custTypeSelect = TypeOfBillTo.GENERAL_PERSON;
  String idTypeSelect = TypeOfBillTo.CITIZEN_CARD;
  String titleIdValue;
  List<DropdownMenuItem<String>> titleItem = [];
  bool isShowBranchPanel = false;
  GlobalKey<_BottomScreenPanelState> bottomScreenPanelKey = GlobalKey();
  ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    addressSelected = AddressData();
    lstCustomerTitles = BlocProvider.of<ApplicationBloc>(context).state?.getCustomerTitlesRs?.lstCustomerTitles ?? [];

    if (!StringUtil.isNullOrEmpty(widget.phoneNo)) {
      _phone.text = widget.phoneNo;
    }

    if (TypeOfBillTo.GENERAL_PERSON == custTypeSelect) {
      titleItem = lstCustomerTitles.where((e) => "P" == e.type).map((x) => DropdownMenuItem<String>(value: x.titleId, child: Text('${x.name}'))).toSet().toList();
    } else if (TypeOfBillTo.NITI_PERSON == custTypeSelect) {
      titleItem = lstCustomerTitles.where((e) => "C" == e.type).map((x) => DropdownMenuItem<String>(value: x.titleId, child: Text('${x.name}'))).toSet().toList();
    }
    titleIdValue = titleItem.first.value;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    createCustomerBloc.close();
    _fname.dispose();
    _fnameCom.dispose();
    _lname.dispose();
    _number.dispose();
    _phone.dispose();
    _idCard.dispose();
    _passportId.dispose();
    _email.dispose();
    _unit.dispose();
    _floor.dispose();
    _village.dispose();
    _descr.dispose();
    _moo.dispose();
    _soi.dispose();
    _street.dispose();
    _building.dispose();
    _lat.dispose();
    _lon.dispose();
    _subDistrict.dispose();
    _district.dispose();
    _province.dispose();
    _zipCode.dispose();
    _branchDesc.dispose();
    _branchId.dispose();
  }

  void callBackAddressAtc(AddressData addressData) {
    setState(() {
      isSelectedVillage = false;
      addressSelected = addressData;
      _subDistrict.text = addressData.subDistrict;
      _district.text = addressData.district;
      _province.text = addressData.provice;
      _zipCode.text = addressData.zipcode;
    });
  }

  void callbackVillageAtc(AddressData addressData) {
    setState(() {
      if (addressData == null) {
        isSelectedVillage = false;
        addressSelected = AddressData();
        _subDistrict.text = '';
        _district.text = '';
        _province.text = '';
        _zipCode.text = '';
        _lat.text = '';
        _lon.text = '';
      } else {
        isSelectedVillage = true;
        addressSelected = addressData;
        _subDistrict.text = addressData.subDistrict;
        _district.text = addressData.district;
        _province.text = addressData.provice;
        _zipCode.text = addressData.zipcode;
        _lat.text = addressData.lat.toString();
        _lon.text = addressData.lon.toString();
      }
    });
  }

  onPinMap() async {
    final AddressData address = await DialogUtil.showCustomDialog(
      context,
      backgroundColor: Colors.white,
      child: Container(
        width: 700,
        height: 600,
        child: PlotMap(
          addressData: addressSelected,
        ),
      ),
    );

    if (address != null) {
      setState(() {
        addressSelected.lat = address.lat;
        addressSelected.lon = address.lon;
        _lat.text = address.lat.toString();
        _lon.text = address.lon.toString();
      });
    }
  }

  onSelectCustomerType(String value) {
    setState(() {
      custTypeSelect = value;
      if (custTypeSelect == TypeOfBillTo.NITI_PERSON) {
        idTypeSelect = TypeOfBillTo.CITIZEN_CARD;
      }
      if (TypeOfBillTo.GENERAL_PERSON == custTypeSelect) {
        titleItem = lstCustomerTitles.where((e) => "P" == e.type).map((x) => DropdownMenuItem<String>(value: x.titleId, child: Text('${x.name}'))).toSet().toList();
      } else if (TypeOfBillTo.NITI_PERSON == custTypeSelect) {
        titleItem = lstCustomerTitles.where((e) => "C" == e.type).map((x) => DropdownMenuItem<String>(value: x.titleId, child: Text('${x.name}'))).toSet().toList();
      }
      titleIdValue = titleItem.first.value;
    });
  }

  onCreateCustomer() {
    if (_formKey.currentState.validate()) {
      if (addressSelected == null || StringUtil.isNullOrEmpty(addressSelected.zipcode)) return DialogUtil.showWarningDialog(context, 'common.dialog_title_warning'.tr(), 'text.please_enter_subdist_dist_province_zipcode'.tr());
      if (CreateCustomerMode.SOLD_TO == widget.createMode) {
        Customer customer = Customer()
          ..lastName = _lname.text
          ..firstName = _fname.text
          ..transportData = new TransportData()
          ..number = _number.text
          ..taxId = idTypeSelect == TypeOfBillTo.CITIZEN_CARD ? _idCard.text : _passportId.text
          ..unit = _unit.text
          ..floor = _floor.text
          ..village = StringUtil.isNullOrEmpty(addressSelected.placeId) ? _village.text : addressSelected.geoName
          ..moo = _moo.text
          ..soi = _soi.text
          ..street = _street.text
          ..building = _building.text
          ..phoneNumber1 = _phone.text
          ..subDistrict = addressSelected.subDistrict
          ..district = addressSelected.district
          ..province = addressSelected.provice
          ..zipCode = addressSelected.zipcode
          ..placeId = addressSelected.placeId
          ..transportData.routeDetails = _descr.text
          ..transportData.tmsLatitude = addressSelected.lat?.toString()
          ..transportData.tmsLongtitude = addressSelected.lon?.toString();
        createCustomerBloc.add(CreateSoldToCustomerEvent(customer: customer));
      } else if (CreateCustomerMode.SHIP_TO == widget.createMode) {
        createCustomerBloc.add(CreateShiptoCustomerEvent(
          salesCartOid: widget.salesCartOid,
          placeId: addressSelected.placeId,
          soldTo: widget.customer,
          phoneNumber1: _phone.text,
          number: _number.text,
          unit: _unit.text,
          floor: _floor.text,
          building: _building.text,
          moo: _moo.text,
          soi: _soi.text,
          street: _street.text,
          subDistrict: addressSelected.subDistrict,
          district: addressSelected.district,
          province: addressSelected.provice,
          zipcode: addressSelected.zipcode,
          village: StringUtil.isNullOrEmpty(addressSelected.placeId) ? _village.text : addressSelected.geoName,
          routeDetails: _descr.text,
          tmsLatitude: addressSelected.lat?.toString(),
          tmsLongtitude: addressSelected.lon?.toString(),
        ));
      } else if (CreateCustomerMode.BILL_TO == widget.createMode) {
        String _titleName = lstCustomerTitles.where((e) => (((TypeOfBillTo.GENERAL_PERSON == custTypeSelect) && ("P" == e.type)) || ((TypeOfBillTo.NITI_PERSON == custTypeSelect) && ("C" == e.type))) && titleIdValue == e.titleId).toList().first.name;
        createCustomerBloc.add(CreateBillToCustomerEvent(
          salesCartOid: widget.salesCartOid,
          placeId: addressSelected.placeId,
          soldTo: widget.customer,
          idCard: idTypeSelect == TypeOfBillTo.CITIZEN_CARD ? _idCard.text : _passportId.text,
          type: TypeOfBillTo.GENERAL_PERSON == custTypeSelect ? idTypeSelect : TypeOfBillTo.SPECIFIED,
          titleId: titleIdValue ?? "",
          title: _titleName ?? "",
          lastName: _lname.text ?? "",
          firstName: TypeOfBillTo.GENERAL_PERSON == custTypeSelect ? _fname.text : _fnameCom.text ?? "",
          phoneNumber1: _phone.text ?? "",
          number: _number.text ?? "",
          email: _email.text ?? "",
          unit: _unit.text ?? "",
          floor: _floor.text ?? "",
          building: _building.text ?? "",
          branchId: _branchId.text ?? "",
          branchType: branchTypeSelect ?? "",
          branchDesc: _branchDesc.text ?? "",
          moo: _moo.text ?? "",
          soi: _soi.text ?? "",
          street: _street.text ?? "",
          subDistrict: addressSelected.subDistrict,
          district: addressSelected.district,
          province: addressSelected.provice,
          zipcode: addressSelected.zipcode,
          village: StringUtil.isNullOrEmpty(addressSelected.placeId) ? _village.text : addressSelected.geoName,
          routeDetails: _descr.text ?? "",
          tmsLatitude: addressSelected.lat?.toString(),
          tmsLongtitude: addressSelected.lon?.toString(),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateCustomerBloc>(
      create: (context) => createCustomerBloc = CreateCustomerBloc(BlocProvider.of<ApplicationBloc>(context)),
      child: BlocConsumer<CreateCustomerBloc, CreateCustomerState>(
        listenWhen: (previous, current) {
          if (previous is LoadingCreateCustomerState) {
            DialogUtil.hideLoadingDialog(context);
          }
          return true;
        },
        listener: (context, state) async {
          if (state is LoadingCreateCustomerState) {
            DialogUtil.showLoadingDialog(context);
          } else if (state is ErrorCreateCustomerState) {
            DialogUtil.showErrorDialog(context, state.error);
          } else if (state is CreateSoldToCustomerSuccessState) {
            Navigator.pop(context, state.customer);
          } else if (state is CreateShipToCustomerSuccessState) {
            Navigator.pop(context, state.customer);
          } else if (state is CreateBillToCustomerSuccessState) {
            Navigator.pop(context, state.customer);
          }
        },
        buildWhen: (previous, current) {
          return current is InitialCreateCustomerState;
        },
        builder: (context, state) {
          return buildCustomerForm();
        },
      ),
    );
  }

  Widget buildCreateCustomerHeader(String header) {
    return Text(
      header,
      style: Theme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget buildCreateSoldTo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildItemInput(
              _fname,
              title: 'text.firstname'.tr(),
              isRequired: true,
              validateMsg: 'waring.specify.with.args'.tr(args: ['text.firstname'.tr()]),
              flex: 6,
              textLength: 100,
              isAllowSpecialCharacter: false,
            ),
            SizedBox(width: 5.0),
            buildItemInput(
              _lname,
              title: 'text.lastname'.tr(),
              isRequired: true,
              validateMsg: 'waring.specify.with.args'.tr(args: ['text.lastname'.tr()]),
              flex: 6,
              textLength: 100,
              isAllowSpecialCharacter: false,
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildItemInput(
              _phone,
              title: 'text.telephone'.tr(),
              isRequired: true,
              validateMsg: 'waring.specify.with.args'.tr(args: ['text.telephone'.tr()]),
              flex: 6,
              inputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              textLength: 10,
              keyBoardType: VirtualKeyboardType.Numeric,
              customValidator: (value) {
                if (value != null && value.length < 10) {
                  return 'text.please_specify_phone_ten_digits'.tr();
                }
                return null;
              },
            ),
            SizedBox(width: 5.0),
            buildItemInput(
              _email,
              title: 'text.email'.tr(),
              flex: 6,
              keyBoardType: VirtualKeyboardType.Email,
              validateMsg: 'text.validate_input_format'.tr(args: ['text.email'.tr()]),
              customValidator: (value) {
                if (value != null && !StringUtil.isValidEmail(value)) {
                  return 'text.validate_input_format'.tr(args: ['text.email'.tr()]);
                }
                return null;
              },
            ),
          ],
        ),
        SizedBox(height: 5),
        Divider(
          color: colorDividerGrey,
          thickness: 1,
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget buildCreateBillTo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('text.customer.type'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 49,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.normal.copyWith(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: EdgeInsets.only(left: 10),
                        ),
                        items: custTypeItems,
                        value: custTypeSelect,
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        onChanged: (val) {
                          onSelectCustomerType(val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (TypeOfBillTo.GENERAL_PERSON == custTypeSelect) buildDropDownCustomerType(),
            SizedBox(width: 10),
            if (idTypeSelect == TypeOfBillTo.CITIZEN_CARD)
              buildItemInput(
                _idCard,
                title: TypeOfBillTo.GENERAL_PERSON == custTypeSelect ? 'text.personal.id'.tr() : 'text.input.tax_identification_number'.tr(),
                isRequired: true,
                flex: TypeOfBillTo.GENERAL_PERSON == custTypeSelect ? 6 : 9,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textLength: 13,
                keyBoardType: VirtualKeyboardType.Numeric,
                validateMsg: 'waring.specify.with.args'.tr(args: [TypeOfBillTo.GENERAL_PERSON == custTypeSelect ? 'text.personal.id'.tr() : 'text.input.tax_identification_number'.tr()]),
                customValidator: (value) {
                  if (value != null && !StringUtil.isValidThaiIDCard(value)) {
                    return 'text.validate_input_format'.tr(args: [TypeOfBillTo.GENERAL_PERSON == custTypeSelect ? 'text.personal.id'.tr() : 'text.input.tax_identification_number'.tr()]);
                  }
                  return null;
                },
              ),
            if (idTypeSelect == TypeOfBillTo.PASSPORT_CARD)
              buildItemInput(
                _passportId,
                title: TypeOfBillTo.GENERAL_PERSON == custTypeSelect ? 'text.personal.id'.tr() : 'text.input.tax_identification_number'.tr(),
                isRequired: true,
                flex: TypeOfBillTo.GENERAL_PERSON == custTypeSelect ? 6 : 9,
                textLength: 13,
                validateMsg: 'waring.specify.with.args'.tr(args: [TypeOfBillTo.GENERAL_PERSON == custTypeSelect ? 'text.personal.id'.tr() : 'text.input.tax_identification_number'.tr()]),
              ),
          ],
        ),
        TypeOfBillTo.GENERAL_PERSON == custTypeSelect ? buildGeneralPerson() : buildCardNitiPerson(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildItemInput(
              _phone,
              title: 'text.telephone'.tr(),
              isRequired: true,
              validateMsg: 'waring.specify.with.args'.tr(args: ['text.telephone'.tr()]),
              inputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              textLength: 10,
              keyBoardType: VirtualKeyboardType.Numeric,
              customValidator: (value) {
                if (value != null && value.length < 9) {
                  return 'text.please_specify_phone_nine_or_ten_digits'.tr();
                }
                return null;
              },
            ),
            SizedBox(width: 10),
            buildItemInput(
              _email,
              title: 'text.email'.tr(),
              keyBoardType: VirtualKeyboardType.Email,
              validateMsg: 'text.validate_input_format'.tr(args: ['text.email'.tr()]),
              customValidator: (value) {
                if (value != null && !StringUtil.isValidEmail(value)) {
                  return 'text.validate_input_format'.tr(args: ['text.email'.tr()]);
                }
                return null;
              },
            ),
          ],
        ),
        SizedBox(height: 5),
        Divider(
          color: colorDividerGrey,
          thickness: 1,
        ),
      ],
    );
  }

  Widget buildDropDownCustomerType() {
    return Expanded(
      flex: 3,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  Text('text.card.type'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 49,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.normal.copyWith(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        contentPadding: EdgeInsets.only(left: 10),
                      ),
                      value: idTypeSelect,
                      items: idTypeItems,
                      icon: Icon(Icons.keyboard_arrow_down_outlined),
                      onChanged: (val) {
                        setState(() {
                          idTypeSelect = val;
                          _idCard.text = '';
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGeneralPerson() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitleCustomer(),
            SizedBox(width: 10),
            buildItemInput(
              _fname,
              title: 'text.firstname'.tr(),
              isRequired: true,
              textLength: 100,
              flex: 5,
              validateMsg: 'waring.specify.with.args'.tr(args: ['text.firstname'.tr()]),
              isAllowSpecialCharacter: false,
            ),
            SizedBox(width: 10),
            buildItemInput(
              _lname,
              title: 'text.lastname'.tr(),
              isRequired: true,
              textLength: 100,
              flex: 4,
              validateMsg: 'waring.specify.with.args'.tr(args: ['text.lastname'.tr()]),
              isAllowSpecialCharacter: false,
            ),
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget buildCardNitiPerson() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitleCustomer(),
            SizedBox(width: 10),
            buildItemInput(
              _fnameCom,
              title: 'common.name'.tr(),
              isRequired: true,
              flex: 9,
              validateMsg: 'waring.specify.with.args'.tr(args: ['common.name'.tr()]),
              textLength: 100,
              isAllowSpecialCharacter: true,
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('text.branch_type'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 49,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.normal.copyWith(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: EdgeInsets.only(left: 10),
                        ),
                        items: branchTypeItems,
                        value: branchTypeSelect,
                        icon: Icon(Icons.keyboard_arrow_down_outlined),
                        onChanged: (val) {
                          setState(() {
                            branchTypeSelect = val;
                            isShowBranchPanel = TypeOfBillTo.STORE == val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isShowBranchPanel ? buildBranchPanel() : Expanded(flex: 9, child: SizedBox()),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget buildTitleCustomer() {
    return Expanded(
      flex: 3,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('text.customer.title'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 49,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.normal.copyWith(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  contentPadding: EdgeInsets.only(left: 10),
                ),
                items: titleItem,
                value: titleIdValue,
                icon: Icon(Icons.keyboard_arrow_down_outlined),
                onChanged: (val) {
                  setState(() {
                    titleIdValue = val;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBranchPanel() {
    return Expanded(
      flex: 9,
      child: Row(
        children: [
          SizedBox(width: 10),
          buildItemInput(_branchId, flex: 3, title: 'text.branch_id'.tr(), isRequired: true, validateMsg: 'waring.specify.with.args'.tr(args: ['text.branch_id'.tr()]), textLength: 100),
          SizedBox(width: 10),
          buildItemInput(_branchDesc, flex: 6, title: 'text.store'.tr(), isRequired: true, validateMsg: 'waring.specify.with.args'.tr(args: ['text.store'.tr()]), textLength: 100),
        ],
      ),
    );
  }

  Widget buildCustomerForm() {
    return Container(
      width: 800,
      height: 800,
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (CreateCustomerMode.SOLD_TO == widget.createMode) buildCreateCustomerHeader('text.create.customer'.tr()),
            if (CreateCustomerMode.SHIP_TO == widget.createMode) buildCreateCustomerHeader('text.add.new.shipto'.tr()),
            if (CreateCustomerMode.BILL_TO == widget.createMode) buildCreateCustomerHeader('text.add.new.tax.invoice.customer'.tr()),
            SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: ListView(
                controller: scrollController,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  if (CreateCustomerMode.SOLD_TO == widget.createMode) buildCreateSoldTo(),
                  if (CreateCustomerMode.BILL_TO == widget.createMode) buildCreateBillTo(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildItemInput(_number, title: 'text.number'.tr(), isRequired: true, validateMsg: 'waring.specify.with.args'.tr(args: ['text.number'.tr()]), textLength: 10),
                      SizedBox(width: 10),
                      buildItemInput(_unit, title: 'text.unit'.tr(), textLength: 10),
                      SizedBox(width: 10),
                      buildItemInput(_floor, title: 'text.floor'.tr(), textLength: 10),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: VillageCondoAutoComplete(
                          name: 'text.village'.tr(),
                          villageController: _village,
                          callback: callbackVillageAtc,
                        ),
                      ),
                      SizedBox(width: 10),
                      buildItemInput(_building, title: 'text.building'.tr(), textLength: 40),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildItemInput(_moo, title: 'text.moo'.tr(), textLength: 10, keyBoardType: VirtualKeyboardType.Numeric),
                      SizedBox(width: 10),
                      buildItemInput(_soi, title: 'text.soi'.tr(), textLength: 60),
                      SizedBox(width: 10),
                      buildItemInput(_street, title: 'text.street'.tr(), textLength: 40),
                    ],
                  ),
                  SizedBox(height: 5),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text('text.find.address'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                          Text('*', style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: colorRed1)),
                        ],
                      ),
                      AddressAutoComplete(
                        callback: this.callBackAddressAtc,
                        isEnabled: !this.isSelectedVillage,
                        addressSelected: this.addressSelected,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('text.subdis'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                            TextField(
                              controller: _subDistrict,
                              enabled: false,
                              style: Theme.of(context).textTheme.small.copyWith(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                fillColor: colorGrey4,
                                filled: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('text.dist'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                            TextField(
                              controller: _district,
                              enabled: false,
                              style: Theme.of(context).textTheme.small.copyWith(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                fillColor: colorGrey4,
                                filled: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('text.province'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                            TextField(
                              controller: _province,
                              enabled: false,
                              style: Theme.of(context).textTheme.small.copyWith(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                fillColor: colorGrey4,
                                filled: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('text.zipcode'.tr(), style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                            TextField(
                              controller: _zipCode,
                              enabled: false,
                              style: Theme.of(context).textTheme.small.copyWith(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                fillColor: colorGrey4,
                                filled: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      buildItemInput(
                        _descr,
                        title: 'text.route.descr'.tr(),
                        hint: 'text.route.descr.hint'.tr(namedArgs: {"newLine": "\n"}),
                        isAllowSpecialCharacter: false,
                        onFocusChange: (value) {
                          bottomScreenPanelKey.currentState.setBottomVisible(value);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lat', style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                            TextField(
                              controller: _lat,
                              enabled: false,
                              style: Theme.of(context).textTheme.small.copyWith(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                fillColor: colorGrey4,
                                filled: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Long', style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                            TextField(
                              controller: _lon,
                              enabled: false,
                              style: Theme.of(context).textTheme.small.copyWith(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                fillColor: colorGrey4,
                                filled: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            Text(''),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: BorderSide(
                                  width: 1,
                                  color: colorBlue7,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              onPressed: () async {
                                onPinMap();
                              },
                              child: Container(
                                height: 49,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      color: colorBlue7,
                                      size: 30,
                                    ),
                                    Text('text.pin.location'.tr(),
                                        style: Theme.of(context).textTheme.normal.copyWith(
                                              color: colorBlue7,
                                              fontWeight: FontWeight.bold,
                                            )),
                                  ],
                                ),
                              ),
                              //onPressed: onPressed,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  BottomScreenPanel(
                    key: bottomScreenPanelKey,
                    scrollController: scrollController,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 480,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  primary: colorBlue7,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  onCreateCustomer();
                },
                child: Text(
                  'text.save'.tr(),
                  style: Theme.of(context).textTheme.normal.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemInput(
    TextEditingController controller, {
    String title = '',
    String hint = '',
    bool isRequired = false,
    bool isEnabled = true,
    List<TextInputFormatter> inputFormatter,
    String validateMsg,
    num flex = 1,
    int textLength = 255,
    VirtualKeyboardType keyBoardType,
    bool isAllowSpecialCharacter = true,
    FormFieldValidator<String> customValidator,
    ValueChanged<bool> onFocusChange,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                Text(title, style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold)),
                if (isRequired) Text('*', style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: colorRed1)),
              ],
            ),
            VirtualKeyboardWrapper(
              key: GlobalKey(),
              textController: controller,
              inputFormatters: inputFormatter,
              maxLength: textLength,
              keyboardType: keyBoardType,
              isAllowSpecialCharacter: isAllowSpecialCharacter,
              builder: (textEditingController, focusNode, inputFormatters) {
                return Focus(
                  onFocusChange: onFocusChange,
                  child: TextFormField(
                    enabled: isEnabled,
                    focusNode: focusNode,
                    controller: textEditingController,
                    inputFormatters: inputFormatters,
                    style: Theme.of(context).textTheme.normal.copyWith(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      hintText: hint,
                      fillColor: isEnabled ? Colors.white : colorGrey4,
                      filled: !isEnabled,
                      suffixIcon: textEditingController.text.length > 0 ? buildIconClear(textEditingController) : SizedBox.shrink(),
                    ),
                    validator: (value) {
                      if (value.isEmpty && isRequired) {
                        return validateMsg;
                      }

                      String customValidatorMsg = StringUtil.isNotEmpty(value) && customValidator != null ? customValidator(value) : null;
                      if (StringUtil.isNotEmpty(customValidatorMsg)) {
                        return customValidatorMsg;
                      }
                      return null;
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIconClear(TextEditingController controller) {
    return IconButton(
      onPressed: controller.text.isNotEmpty ? () => controller.clear() : null,
      icon: Icon(
        Icons.clear,
        size: 15,
      ),
    );
  }
}

class BottomScreenPanel extends StatefulWidget {
  final ScrollController scrollController;
  BottomScreenPanel({Key key, this.scrollController}) : super(key: key);

  @override
  _BottomScreenPanelState createState() => _BottomScreenPanelState();
}

class _BottomScreenPanelState extends State<BottomScreenPanel> {
  bool isBottomVisible = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isBottomVisible,
      child: Container(
        height: 200,
      ),
    );
  }

  void setBottomVisible(bool val) {
    bool isLandscape = MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;
    if (!isLandscape) return;

    setState(() {
      isBottomVisible = val;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    });
  }
}
