import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_store_catalog/core/blocs/application/application_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/create_customer/create_customer_bloc.dart';
import 'package:flutter_store_catalog/core/blocs/search_customer/search_customer_bloc.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/get_it.dart';
import 'package:flutter_store_catalog/core/models/bkoffc/sale_cart.dart';
import 'package:flutter_store_catalog/core/services/dotnet/customer_information_service.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_store_catalog/core/utilities/language_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_line_icon_icons.dart';

import 'create_customer.dart';
import 'custom_number_pad.dart';
import 'package:easy_localization/easy_localization.dart';

class DialogCustomer extends StatefulWidget {
  final String phoneNo;
  final String partnerTypeId;

  DialogCustomer({this.phoneNo, this.partnerTypeId});

  @override
  _DialogCustomer createState() => _DialogCustomer();
}

class _DialogCustomer extends State<DialogCustomer> {
  Customer customer;
  SearchCustomerBloc searchCustomerBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    searchCustomerBloc?.close();
    super.dispose();
  }

  onCreateCustomerNotFound(String phoneNo) async {
    Customer createCustomer = await DialogUtil.showCustomDialog(
      context,
      isScrollView: false,
      child: CreateCustomer(CreateCustomerMode.SOLD_TO, phoneNo: phoneNo),
      backgroundColor: Colors.white,
    );

    onFoundCustomer(createCustomer);
  }

  onFoundCustomer(Customer selectCustomer) {
    if (selectCustomer != null) {
      setState(() {
        customer = selectCustomer;
      });
      searchCustomerBloc.add(
        SendOtpEvent(telephoneNo: customer.phoneNumber1),
      );
      // Navigator.pop(context, customer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchCustomerBloc>(
          create: (context) {
            searchCustomerBloc = SearchCustomerBloc(BlocProvider.of<ApplicationBloc>(context));
            if (!StringUtil.isNullOrEmpty(widget.phoneNo)) {
              searchCustomerBloc.add(
                SearchCustomerSearchEvent(
                  searchCondition: widget.phoneNo.startsWith('0') ? TypeOfCustomerSearch.TELEPHONE : TypeOfCustomerSearch.MEMBERNO,
                  searchValue: widget.phoneNo,
                  partnerTypeId: widget.partnerTypeId,
                ),
              );
            }

            return searchCustomerBloc;
          },
        ),
      ],
      child: BlocConsumer<SearchCustomerBloc, SearchCustomerState>(
        buildWhen: (previous, current) {
          return current is SuccesSendOtpState || current is InitialSearchCustomerState || current is InitialOtpState;
        },
        listenWhen: (previous, current) {
          if (previous is LoadingSearchCustomerByState) {
            DialogUtil.hideLoadingDialog(context);
          }
          if (previous is LoadingOtpState) {
            DialogUtil.hideLoadingDialog(context);
          }
          return true;
        },
        listener: (context, state) async {
          if (state is ErrorSearchCustomerByState) {
            DialogUtil.showErrorDialog(context, state.error);
          } else if (state is LoadingSearchCustomerByState) {
            DialogUtil.showLoadingDialog(context);
          } else if (state is CustomerNotFoundState) {
            bool isOpenDialogCreateCustomer = await DialogUtil.showConfirmDialog(
              context,
              title: 'text.no.data.in.system'.tr(),
              message: 'text.no.data.in.system.desr'.tr(namedArgs: {"newLine": "\n", "doubleQuote": "\u0022"}),
              textOk: 'text.create.customer'.tr(),
            );

            if (isOpenDialogCreateCustomer ?? false) {
              onCreateCustomerNotFound(state.phoneNo);
            }
          } else if (state is LoadingOtpState) {
            DialogUtil.showLoadingDialog(context);
          } else if (state is ErrorOtpState) {
            DialogUtil.showErrorDialog(context, state.error);
          } else if (state is SuccesValidateOtpState) {
            Navigator.pop(context, customer);
          }
          if (state is SuccessSearchByCustomerByState) {
            Customer selectCustomer;
            List<Customer> rewardCustomers = state.customers.where((element) => element.isRewardCardNo != null && element.isRewardCardNo).toList();
            List<Customer> regularCustomers = state.customers.where((element) => element.isRewardCardNo == null || !element.isRewardCardNo).toList();

            if (rewardCustomers.isNotEmpty) {
              if (!rewardCustomers.any((a) => a.cardNumber != rewardCustomers.first.cardNumber)) {
                selectCustomer = rewardCustomers.first;
              } else {
                selectCustomer = await DialogUtil.showCustomDialog(
                  context,
                  isScrollView: false,
                  child: DuplicateCustomer(rewardCustomers),
                  backgroundColor: Colors.white,
                );
              }
            } else if (regularCustomers.isNotEmpty) {
              selectCustomer = regularCustomers.first;
            }

            onFoundCustomer(selectCustomer);
          }
        },
        builder: (context, state) {
          if (state is SuccesSendOtpState)
            return ConfirmOtp(
              customer: customer,
              phoneNumber: customer.phoneNumber1,
              otpSMSId: state.otpSMSId,
              otpId: state.otpId,
              timeoutInSecond: DateTime.now().millisecondsSinceEpoch + (1000 * state.timeoutInSecond),
              refCode: state.refCode,
            );
          return SearchCustomer(onFoundCustomer: onFoundCustomer);
        },
      ),
    );
  }

  Widget _buildDialogCustomerNotFound(String phoneNo) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('text.no.data.in.system'.tr(), style: Theme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(
            'text.no.data.in.system.desr'.tr(namedArgs: {"newLine": "\n", "doubleQuote": "\u0022"}),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    primary: colorAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Container(
                    height: 49,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('text.back'.tr(), style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 5,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: colorBlue7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Container(
                    height: 49,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('text.create.customer'.tr(), style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DuplicateCustomer extends StatefulWidget {
  final List<Customer> customers;

  DuplicateCustomer(this.customers);

  _DuplicateCustomer createState() => _DuplicateCustomer();
}

class _DuplicateCustomer extends State<DuplicateCustomer> {
  Customer selectCustomer;

  onSelectCustomer(Customer customer) {
    setState(() {
      selectCustomer = customer;
    });
  }

  void onChooseCustomer() {
    Navigator.pop(context, selectCustomer);
  }

  @override
  Widget build(BuildContext context) {
    return _buildSelectCustomer(widget.customers);
  }

  Widget _buildSelectCustomer(List<Customer> customers) {
    return Container(
      width: 400,
      height: MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width ? MediaQuery.maybeOf(context).size.height * 0.33 : MediaQuery.maybeOf(context).size.height * 0.75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('text.select.customer'.tr(), style: Theme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.bold)),
          Text(
            'text.duplicate.customer.contact.cs'.tr(namedArgs: {"newLine": "\n"}),
            style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Expanded(
            flex: 1,
            child: ListView(
              shrinkWrap: true,
              children: customers.map((e) {
                return _buildSelectCustomerCard(e);
              }).toList(),
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      primary: colorBlue7,
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: selectCustomer != null ? () => onChooseCustomer() : null,
                    child: Text(
                      'text.select'.tr(),
                      style: Theme.of(context).textTheme.normal.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectCustomerCard(Customer customer) {
    ButtonStyle style = OutlinedButton.styleFrom(
      backgroundColor: colorGreyBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      shadowColor: colorGreyBlueShadow,
    );

    if (selectCustomer?.customerOid == customer.customerOid) {
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

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: OutlinedButton(
        style: style,
        child: ListTile(
          leading: Image.asset(
            'assets/images/home_card.png',
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${customer.cardNumber}',
                style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
              if (customer.isRewardCardNo && !StringUtil.isNullOrEmpty(customer.memberCardTypeId))
                Container(
                  height: 22,
                  child: FadeInImage.assetNetwork(
                    placeholder: '',
                    placeholderErrorBuilder: (context, error, stackTrace) => Container(),
                    image: ImageUtil.getFullURL(getIt<CustomerInformationService>().getTierImage(customer.sapId)),
                    imageErrorBuilder: (context, error, stackTrace) => Container(),
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('${customer.firstName}'),
              Text(BlocProvider.of<ApplicationBloc>(context).state.getCensorPhoneNo(customer.phoneNumber1)),
            ],
          ),
        ),
        onPressed: () {
          onSelectCustomer(customer);
        },
      ),
    );
  }
}

class SearchCustomer extends StatefulWidget {
  final Function(Customer selectedCustomer) onFoundCustomer;

  SearchCustomer({Key key, this.onFoundCustomer}) : super(key: key);

  _SearchCustomer createState() => _SearchCustomer();
}

class _SearchCustomer extends State<SearchCustomer> {
  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  setValue(String val) {
    if (searchController.text.length < 10)
      setState(() {
        searchController.text += val;
      });
  }

  backspace(String text) {
    if (text.length > 0) {
      setState(() {
        searchController.text = text.split('').sublist(0, text.length - 1).join('');
      });
    }
  }

  onSearch(String text) {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<SearchCustomerBloc>(context).add(
        SearchCustomerSearchEvent(
          searchCondition: text.startsWith('0') ? TypeOfCustomerSearch.TELEPHONE : TypeOfCustomerSearch.MEMBERNO,
          searchValue: text,
        ),
      );
    }
  }

  onCreateCustomer() async {
    Customer createCustomer = await DialogUtil.showCustomDialog(
      context,
      isScrollView: false,
      child: CreateCustomer(CreateCustomerMode.SOLD_TO),
      backgroundColor: Colors.white,
    );

    widget.onFoundCustomer(createCustomer);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        color: Colors.white.withOpacity(0),
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('text.search'.tr(), style: Theme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 16),
            Text(
              'text.search.desr'.tr(namedArgs: {"newLine": "\n"}),
              style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              width: 280,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: TextFormField(
                showCursor: false,
                controller: searchController,
                style: Theme.of(context).textTheme.larger.copyWith(),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'text.enter.phone.homecard'.tr(),
                  hintStyle: Theme.of(context).textTheme.normal.copyWith(),
                  hintMaxLines: 1,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hoverColor: Colors.transparent,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (StringUtil.isNullOrEmpty(value)) {
                    return 'text.warning.specify.search.data'.tr();
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.length == 10) {
                    setState(() {});
                  }
                },
              ),
            ),
            Container(
              width: 280,
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomNumberPad(
                        text: '1',
                        onPressed: () => setValue('1'),
                        style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                      ),
                      CustomNumberPad(
                        text: '2',
                        onPressed: () => setValue('2'),
                        style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                      ),
                      CustomNumberPad(
                        text: '3',
                        onPressed: () => setValue('3'),
                        style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomNumberPad(
                        text: '4',
                        onPressed: () => setValue('4'),
                        style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                      ),
                      CustomNumberPad(
                        text: '5',
                        onPressed: () => setValue('5'),
                        style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                      ),
                      CustomNumberPad(
                        text: '6',
                        onPressed: () => setValue('6'),
                        style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomNumberPad(
                        text: '7',
                        onPressed: () => setValue('7'),
                        style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                      ),
                      CustomNumberPad(
                        text: '8',
                        onPressed: () => setValue('8'),
                        style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                      ),
                      CustomNumberPad(
                        text: '9',
                        onPressed: () => setValue('9'),
                        style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomNumberPad(
                        icon: NovaLineIcon.arrow_left_1,
                        onPressed: () => backspace(searchController.text),
                      ),
                      CustomNumberPad(
                        text: '0',
                        onPressed: () => setValue('0'),
                        style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                      ),
                      CustomNumberPad(
                        text: 'text.menu_search'.tr(),
                        backgroundColor: colorOrangeGradient2,
                        onPressed: searchController.text.length == 10 ? () => onSearch(searchController.text) : null,
                        style: LanguageUtil.isTh(context) ? Theme.of(context).textTheme.large.copyWith(color: Colors.white) : Theme.of(context).textTheme.normal.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () {
                onCreateCustomer();
              },
              child: Text(
                'text.create.customer'.tr(),
                style: Theme.of(context).textTheme.normal.copyWith(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmOtp extends StatefulWidget {
  final Customer customer;
  final String phoneNumber;
  final String otpSMSId;
  final String otpId;
  final int timeoutInSecond;
  final String refCode;

  ConfirmOtp({this.customer, this.phoneNumber, this.otpSMSId, this.otpId, this.timeoutInSecond, this.refCode});

  _ConfirmOtp createState() => _ConfirmOtp();
}

class _ConfirmOtp extends State<ConfirmOtp> {
  TextEditingController verifyOtpController = TextEditingController();

  setValue(String val) {
    if (verifyOtpController.text.length < 6)
      setState(() {
        verifyOtpController.text += val;
        //widget.onChange(widget.number);
      });
  }

  backspace(String text) {
    if (text.length > 0) {
      setState(() {
        verifyOtpController.text = text.split('').sublist(0, text.length - 1).join('');
        //widget.onChange(widget.number);
      });
    }
  }

  onReSendOtp() {
    BlocProvider.of<SearchCustomerBloc>(context).add(
      SendOtpEvent(telephoneNo: widget.phoneNumber),
    );
  }

  onValidateOtp(String otpCode) {
    BlocProvider.of<SearchCustomerBloc>(context).add(
      ValidateOtpEvent(otpId: widget.otpId, otpSMSId: widget.otpSMSId, telephoneNo: widget.phoneNumber, otpCode: otpCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'text.confirm.member'.tr(),
            style: Theme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 16),
          Text('text.service.send.otp.to.you'.tr(), style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white)),
          Text(BlocProvider.of<ApplicationBloc>(context).state.getCensorPhoneNo(widget.phoneNumber ?? ''), style: Theme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
          Text('text.you.otp'.tr(), style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white)),
          SizedBox(height: 10),
          PinCode(
            text: verifyOtpController.text,
            length: 6,
          ),
          Container(
            width: 280,
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomNumberPad(
                      text: '1',
                      onPressed: () => setValue('1'),
                      style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                    ),
                    CustomNumberPad(
                      text: '2',
                      onPressed: () => setValue('2'),
                      style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                    ),
                    CustomNumberPad(
                      text: '3',
                      onPressed: () => setValue('3'),
                      style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomNumberPad(
                      text: '4',
                      onPressed: () => setValue('4'),
                      style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                    ),
                    CustomNumberPad(
                      text: '5',
                      onPressed: () => setValue('5'),
                      style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                    ),
                    CustomNumberPad(
                      text: '6',
                      onPressed: () => setValue('6'),
                      style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomNumberPad(
                      text: '7',
                      onPressed: () => setValue('7'),
                      style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                    ),
                    CustomNumberPad(
                      text: '8',
                      onPressed: () => setValue('8'),
                      style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                    ),
                    CustomNumberPad(
                      text: '9',
                      onPressed: () => setValue('9'),
                      style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomNumberPad(
                      icon: NovaLineIcon.arrow_left_1,
                      onPressed: () => backspace(verifyOtpController.text),
                    ),
                    CustomNumberPad(
                      text: '0',
                      onPressed: () => setValue('0'),
                      style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold, color: colorDark),
                    ),
                    CustomNumberPad(
                      text: 'common.button_confirm'.tr(),
                      backgroundColor: colorOrangeGradient2,
                      onPressed: verifyOtpController.text.length == 6 ? () => onValidateOtp(verifyOtpController.text) : null,
                      style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          CountdownTimer(
            endTime: widget.timeoutInSecond,
            widgetBuilder: (_, CurrentRemainingTime time) {
              if (time == null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'text.if.not.receive.otp'.tr(),
                      style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        onReSendOtp();
                      },
                      child: Text(
                        'text.send.again'.tr(),
                        style: Theme.of(context).textTheme.normal.copyWith(
                              color: colorBlue4,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ],
                );
              }
              int min = time.min ?? 0;
              int sec = time.sec ?? 0;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'text.if.not.receive.otp'.tr(),
                    style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white),
                  ),
                  Icon(
                    Icons.timer,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              BlocProvider.of<SearchCustomerBloc>(context).add(
                ResetSearchCustomerEvent(),
              );
            },
            child: Text(
              'text.back.to.edit'.tr(),
              style: Theme.of(context).textTheme.normal.copyWith(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class PinCode extends StatelessWidget {
  final int length;
  final String text;

  const PinCode({Key key, this.length, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> code = text.split('').toList();
    List<Widget> previewLength = [];

    for (var i = 0; i < length; i++) {
      previewLength.add(Box(
        isActive: code.length >= i + 1,
        text: code.length > 0 && i < code.length ? code[i] : '',
      ));
    }

    return Container(padding: EdgeInsets.symmetric(vertical: 15.0), child: Wrap(children: previewLength));
  }
}

class Box extends StatelessWidget {
  final bool isActive;
  final String text;

  const Box({Key key, this.isActive = false, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      child: Container(
        width: 50.0,
        height: 65.0,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.larger,
          ),
        ),
      ),
    );
  }
}
