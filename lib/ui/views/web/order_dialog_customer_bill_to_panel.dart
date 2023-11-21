import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/create_customer/create_customer_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/sales_cart/sales_cart_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/search_customer/search_customer_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/views/web/order.dart';
import 'package:flutter_store_catalog/ui/widgets/create_customer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/core/utilities/common_util.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_solid_icon_icons.dart';
import 'package:flutter_store_catalog/ui/widgets/search_result_text.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard_wrapper.dart';

final List<DropdownMenuItem<String>> searchTypeItems = [
  DropdownMenuItem<String>(value: TypeOfCustomerSearch.ALL, child: Text('text.select_all'.tr())),
  DropdownMenuItem<String>(value: TypeOfCustomerSearch.TELEPHONE, child: Text('text.telephone'.tr())),
  DropdownMenuItem<String>(value: TypeOfCustomerSearch.MEMBERNO, child: Text('text.card_number'.tr())),
  DropdownMenuItem<String>(value: TypeOfCustomerSearch.CUSTNO, child: Text('text.emp_no'.tr())),
  DropdownMenuItem<String>(value: TypeOfCustomerSearch.FULLNAME, child: Text('text.fullName'.tr())),
  DropdownMenuItem<String>(value: TypeOfCustomerSearch.IDCARD, child: Text('text.id_card_no'.tr())),
];

final List<TextInputFormatter> inputFormatterNumberLenght10 = [
  FilteringTextInputFormatter.digitsOnly,
  LengthLimitingTextInputFormatter(10),
];

final List<TextInputFormatter> inputFormatterNumberLenght13 = [
  FilteringTextInputFormatter.digitsOnly,
  LengthLimitingTextInputFormatter(13),
];

class PopupSearchBillToPanel extends StatefulWidget {
  final Customer customer;
  final Customer billToOld;

  PopupSearchBillToPanel({this.customer, this.billToOld});

  @override
  _PopupSearchBillToPanelState createState() => _PopupSearchBillToPanelState();
}

class _PopupSearchBillToPanelState extends State<PopupSearchBillToPanel> {
  TextEditingController searchController = new TextEditingController();
  String searchTypeSelect = TypeOfCustomerSearch.ALL;
  List<CustomerPartners> billToList;
  Customer billToSelected;

  @override
  void initState() {
    super.initState();
    billToList = widget.customer.customerPartners.where((element) {
      return CustomerPartnerType.BILL_TO == element.partnerFunctionTypeId || CustomerPartnerType.BILL_TO == element.partnerCustomer.partnerFunctionTypeId || CustomerPartnerType.SOLD_TO == element.partnerFunctionTypeId;
    }).toList();
  }

  onSearch() {
    String searchValue = searchController.text;
    setState(() {
      billToList = widget.customer.customerPartners.where((element) {
        bool billTo = (CustomerPartnerType.BILL_TO == element.partnerFunctionTypeId || CustomerPartnerType.BILL_TO == element.partnerCustomer.partnerFunctionTypeId || CustomerPartnerType.SOLD_TO == element.partnerFunctionTypeId);

        if (searchValue.isNullEmptyOrWhitespace) return billTo;

        bool isMatchCondition = false;

        bool isMatchTel = element.partnerCustomer?.phoneNumber1?.startsWith(searchValue) ?? false;
        bool isMatchSapId = element.partnerCustomer?.sapId?.startsWith(searchValue) ?? false;
        bool isMatchMemberNo = element.partnerCustomer?.cardNumber?.startsWith(searchValue) ?? false;
        bool isMatchFullName = (element.partnerCustomer?.firstName?.toLowerCase()?.contains(searchValue?.toLowerCase()) ?? false) || (element.partnerCustomer?.lastName?.toLowerCase()?.contains(searchValue?.toLowerCase()) ?? false);
        bool isMatchTaxId = element.partnerCustomer?.taxId?.startsWith(searchValue) ?? false;
        switch (searchTypeSelect) {
          case TypeOfCustomerSearch.ALL:
            isMatchCondition = isMatchTel || isMatchSapId || isMatchMemberNo || isMatchFullName || isMatchTaxId;
            break;
          case TypeOfCustomerSearch.TELEPHONE:
            isMatchCondition = isMatchTel;
            break;
          case TypeOfCustomerSearch.CUSTNO:
            isMatchCondition = isMatchSapId;
            break;
          case TypeOfCustomerSearch.MEMBERNO:
            isMatchCondition = isMatchMemberNo;
            break;
          case TypeOfCustomerSearch.FULLNAME:
            isMatchCondition = isMatchFullName;
            break;
          case TypeOfCustomerSearch.IDCARD:
            isMatchCondition = isMatchTaxId;
            break;
        }

        return billTo && isMatchCondition;
      }).toList();
    });
  }

  Future<void> _onCreateCustomer() async {
    SalesCart salesCart = BlocProvider.of<SalesCartBloc>(context).state.salesCartDto.salesCart;
    final Customer result = await DialogUtil.showCustomDialog(
      context,
      isScrollView: false,
      child: CreateCustomer(CreateCustomerMode.BILL_TO, salesCartOid: salesCart.salesCartOid, customer: widget.customer),
      backgroundColor: Colors.white,
    );

    if (result != null) {
      setState(() {
        salesCart.customer = result;
        billToList = result.customerPartners.where((element) {
          return CustomerPartnerType.BILL_TO == element.partnerFunctionTypeId || CustomerPartnerType.BILL_TO == element.partnerCustomer.partnerFunctionTypeId || CustomerPartnerType.SOLD_TO == element.partnerFunctionTypeId;
        }).toList();
        billToSelected = billToList.first.partnerCustomer;
      });
    }
  }

  onSelectCustomer(Customer customer) {
    setState(() {
      billToSelected = customer;
    });
  }

  onChooseCustomer() {
    Navigator.pop(context, billToSelected);
  }

  @override
  Widget build(BuildContext context) {
    double popupWidth;

    if (MediaQuery.maybeOf(context).size.width < VERTICAL_WIDTH || MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width) {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.75;
    } else {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.5;
    }

    return Container(
      width: popupWidth,
      height: 800,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'text.tax_invoice'.tr(),
              style: Theme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'text.search_bill_to'.tr(),
            style: Theme.of(context).textTheme.normal.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  height: 40,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelStyle: Theme.of(context).textTheme.smaller.copyWith(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: EdgeInsets.only(left: 15),
                    ),
                    items: searchTypeItems,
                    value: searchTypeSelect,
                    icon: Icon(Icons.keyboard_arrow_down_outlined),
                    onChanged: (value) {
                      setState(() {
                        searchTypeSelect = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                flex: 8,
                child: VirtualKeyboardWrapper(
                  onKeyPress: (key) {
                    onSearch();

                    if (searchController.text.length < 10 && TypeOfCustomerSearch.TELEPHONE == searchTypeSelect || TypeOfCustomerSearch.CUSTNO == searchTypeSelect || TypeOfCustomerSearch.MEMBERNO == searchTypeSelect) {
                      return;
                    }

                    if (searchController.text.length < 13 && TypeOfCustomerSearch.IDCARD == searchTypeSelect) {
                      return;
                    }
                  },
                  textController: searchController,
                  maxLength: TypeOfCustomerSearch.TELEPHONE == searchTypeSelect || TypeOfCustomerSearch.CUSTNO == searchTypeSelect || TypeOfCustomerSearch.MEMBERNO == searchTypeSelect
                      ? 10
                      : TypeOfCustomerSearch.IDCARD == searchTypeSelect
                          ? 13
                          : 40,
                  keyboardType: TypeOfCustomerSearch.FULLNAME == searchTypeSelect || TypeOfCustomerSearch.ALL == searchTypeSelect ? VirtualKeyboardType.Alphanumeric : VirtualKeyboardType.Numeric,
                  builder: (textEditingController, focusNode, inputFormatters) {
                    return TextFormField(
                      inputFormatters: inputFormatters,
                      focusNode: focusNode,
                      controller: textEditingController,
                      autovalidateMode: AutovalidateMode.disabled,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'text.warning.specify.search.data'.tr();
                        }
                        return null;
                      },
                      onChanged: (value) {
                        onSearch();

                        if (value.length < 10 && TypeOfCustomerSearch.TELEPHONE == searchTypeSelect || TypeOfCustomerSearch.CUSTNO == searchTypeSelect || TypeOfCustomerSearch.MEMBERNO == searchTypeSelect) {
                          return;
                        }

                        if (value.length < 13 && TypeOfCustomerSearch.IDCARD == searchTypeSelect) {
                          return;
                        }
                      },
                      style: Theme.of(context).textTheme.small.copyWith(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding: EdgeInsets.all(8),
                        hintText: 'text.menu_search'.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (billToList.isNullOrEmpty) SearchResultText(result: 0, searchText: searchController.text),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: colorBlue5,
              padding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            onPressed: () {
              _onCreateCustomer();
            },
            child: Container(
              width: popupWidth * 0.35,
              child: Text(
                '+ ${'text.new_ship_to_address'.tr()}',
                style: Theme.of(context).textTheme.small.copyWith(
                      color: colorBlue7,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 1,
            child: ListView(
              shrinkWrap: true,
              children: billToList.map((e) {
                return _buildSelectCustomerCard(e);
              }).toList(),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              width: popupWidth * 0.4,
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  primary: colorBlue7,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: billToSelected != null ? () => onChooseCustomer() : null,
                child: Text(
                  'text.select'.tr(),
                  style: Theme.of(context).textTheme.normal.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectCustomerCard(CustomerPartners customerPartners) {
    if (customerPartners.isNullOrEmpty) {
      return SizedBox.shrink();
    }
    Customer customer = customerPartners.partnerCustomer;
    bool isPerson = StringUtil.isNullOrEmpty(customer.titleId) ? true : BlocProvider.of<ApplicationBloc>(context).state?.getCustomerTitlesRs?.lstCustomerTitles?.where((e) => e.titleId == customer.titleId)?.first?.type == TypeOfBillTo.GENERAL_PERSON;

    String getBillToFullNameWithTitle() {
      if (customerPartners != null) {
        if (customerPartners.partnerCustomer.title.isNullEmptyOrWhitespace) {
          return '${customerPartners.partnerCustomer.firstName} ${customerPartners.partnerCustomer.lastName ?? ''}';
        }

        return '${customerPartners.partnerCustomer.title} ${customerPartners.partnerCustomer.firstName} ${customerPartners.partnerCustomer.lastName ?? ''}';
      }
      return '';
    }

    ButtonStyle style = OutlinedButton.styleFrom(
      backgroundColor: colorGreyBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      shadowColor: colorGreyBlueShadow,
    );

    if (billToSelected?.customerOid == customer.customerOid) {
      style = OutlinedButton.styleFrom(
        backgroundColor: colorBlue5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadowColor: colorGreyBlueShadow,
        side: BorderSide(
          color: colorBlue7,
        ),
      );
    }

    return Column(
      children: [
        OutlinedButton(
          style: style,
          child: ListTile(
            leading: Icon(
              isPerson ? NovaSolidIcon.user_information : NovaSolidIcon.real_estate_information,
            ),
            title: Text(
              getBillToFullNameWithTitle(),
              style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(BlocProvider.of<ApplicationBloc>(context).state.getCensorIdCard(customer.taxId.isNullEmptyOrWhitespace ? CustomerTaxId.DEFAULT_TAX_ID : customer.taxId)),
                  Text('${StringUtil.getAddress(customer.village, customer.floor, customer.unit, customer.soi, customer.moo, customer.number, customer.street, customer.subDistrict, customer.district, customer.province, customer.zipCode)}'),
                  Text(BlocProvider.of<ApplicationBloc>(context).state.getCensorPhoneNo(customer.phoneNumber1)),
                ],
              ),
            ),
          ),
          onPressed: () {
            onSelectCustomer(customer);
          },
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
