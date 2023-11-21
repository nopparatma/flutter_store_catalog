part of 'order.dart';

class CustomerPanel extends StatefulWidget {
  final SalesCartDto salesCartDto;
  final OrderBloc orderBloc;
  final CalculatePromotionBloc calProBloc;
  final bool isPortrait;

  CustomerPanel({
    this.salesCartDto,
    this.orderBloc,
    this.calProBloc,
    this.isPortrait = false,
  });

  @override
  CustomerPanelState createState() => CustomerPanelState();
}

class CustomerPanelState extends State<CustomerPanel> {
  List<CustomerPartners> _shipToCustomerList;

  @override
  void initState() {
    _shipToCustomerList = widget.salesCartDto.salesCart.customer.customerPartners.where((element) {
      return CustomerPartnerType.SHIP_TO == element.partnerFunctionTypeId && (CustomerPartnerType.SHIP_TO == element.partnerCustomer.partnerFunctionTypeId || CustomerPartnerType.SOLD_TO == element.partnerCustomer.partnerFunctionTypeId);
    }).toList();
    super.initState();
  }

  @override
  dispose() {
    //_orderBloc.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _shipToCustomerList = widget.salesCartDto.salesCart.customer.customerPartners.where((element) {
        return CustomerPartnerType.SHIP_TO == element.partnerFunctionTypeId && (CustomerPartnerType.SHIP_TO == element.partnerCustomer.partnerFunctionTypeId || CustomerPartnerType.SOLD_TO == element.partnerCustomer.partnerFunctionTypeId);
      }).toList();
    });
  }

  void _onTapInquiry(bool isSelectDifference, bool isCustomerReceive, Customer shipToCustomer, {ShippingPointList shippingPointSelected}) {
    if (isSelectDifference) {
      widget.orderBloc.add(SelectShipToEvent(
        isCustomerReceive: isCustomerReceive,
        shipToCustomer: shipToCustomer,
        shippingPointStore: shippingPointSelected,
      ));
    } else {
      setState(() {});
    }
  }

  Future<void> _onTapCustomerReceiveValidate(bool value) async {
    bool validateBack = await _validateBackStep();
    if (validateBack != null) {
      if (validateBack) widget.orderBloc.add(BackStepToCustomerPanel(backStepFlag: OrderStepBackFlag.CUSTOMER_RECEIVE, customerReceiveValue: value));
    } else {
      _onTapCustomerReceive(value: value, isCustomerReceive: true);
    }
  }

  Future<void> _onTapCustomerReceive({bool value, bool isCustomerReceive}) async {
    ShippingPointList shippingPointSelected = await DialogUtil.showCustomDialog(context, isScrollView: false, child: DialogSelectShippingPointStore());

    if (shippingPointSelected != null) {
      _onTapInquiry(true, isCustomerReceive, null, shippingPointSelected: shippingPointSelected);
    } else {
      _onTapInquiry(false, false, null);
    }
  }

  Future<void> _onCreateCustomerValidate() async {
    bool validateBack = await _validateBackStep();
    if (validateBack != null) {
      if (validateBack) widget.orderBloc.add(BackStepToCustomerPanel(backStepFlag: OrderStepBackFlag.CREATE_SHIP_TO));
    } else {
      _onCreateCustomer();
    }
  }

  Future<void> _onCreateCustomer() async {
    final Customer result = await DialogUtil.showCustomDialog(
      context,
      isScrollView: false,
      child: CreateCustomer(CreateCustomerMode.SHIP_TO, salesCartOid: widget.salesCartDto.salesCart.salesCartOid, customer: widget.salesCartDto.salesCart.customer),
      backgroundColor: Colors.white,
    );

    if (result != null) {
      setState(() {
        widget.salesCartDto.salesCart.customer = result;
        Customer billTo = result.customerPartners.isNotNE ? result.customerPartners.first.partnerCustomer : null;
        if (billTo.isNotNull) _onTapInquiry(true, false, billTo);
      });
    }
  }

  Future<bool> _validateBackStep() async {
    if (widget.orderBloc.state is CalculatePromotionCompleteState) {
      return await DialogUtil.showCustomDialog(context, child: PopupBackStep('common.dialog_title_warning'.tr(), '${'warning.edit_delivery_date.first'.tr()}\n${'warning.edit_delivery_date.second'.tr()}', CancelSalesType.SalesOrder)) ?? false;
    }
    return null;
  }

  num getListViewHeight() {
    final num heightPerItem = 90;
    final num defaultHeight = MathUtil.multiple(heightPerItem, 3);

    num numOfItem = _shipToCustomerList.length;
    num listviewHeight = MathUtil.multiple(heightPerItem, numOfItem);

    if (listviewHeight > defaultHeight && listviewHeight > MediaQuery.maybeOf(context).size.height - 500) {
      return defaultHeight;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container();
    if (widget.isPortrait) {
      content = _buildCustomerPortrait(context);
    } else {
      content = _buildCustomerLandscape(context);
    }

    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) async {
        if (state is ShowCustomerInfoState) {
          if (state.backStepFlag == OrderStepBackFlag.CUSTOMER_RECEIVE) {
            _onTapCustomerReceive(value: state.customerReceiveValue, isCustomerReceive: true);
          } else if (state.backStepFlag == OrderStepBackFlag.CREATE_SHIP_TO) {
            _onCreateCustomer();
          }
        }
      },
      child: content,
    );
  }

  Widget _buildCustomerLandscape(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          _buildCustomerInfo(context),
          SizedBox(height: 20),
          _buildShipToPanel(context),
          SizedBox(height: 20),
          _buildReceiveAtHomeproPanel(context),
        ],
      ),
    );
  }

  Widget _buildCustomerPortrait(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: _buildCustomerInfo(context),
        ),
        SizedBox(width: 40.0),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: Column(
              children: [
                _buildShipToPanel(context),
                SizedBox(height: 40),
                _buildReceiveAtHomeproPanel(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo(BuildContext context) {
    bool isHomeCard = !widget.salesCartDto.getCustCardNo().isNullEmptyOrWhitespace;
    String sapId = widget?.salesCartDto?.salesCart?.customer?.sapId;

    Widget content = Container();

    if (isHomeCard) {
      content = Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: 70,
              child: Image.asset('assets/images/home_card.png'),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    widget.salesCartDto.getCustCardNo(),
                    style: Theme.of(context).textTheme.normal.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(width: 5),
                  if (!StringUtil.isNullOrEmpty(sapId))
                    Container(
                      height: 22,
                      child: FadeInImage.assetNetwork(
                        placeholder: '',
                        placeholderErrorBuilder: (context, error, stackTrace) => Container(),
                        image: ImageUtil.getFullURL(getIt<CustomerInformationService>().getTierImage(sapId)),
                        imageErrorBuilder: (context, error, stackTrace) => Container(),
                      ),
                    ),
                ],
              ),
              InkWell(
                onTap: () {
                  DialogUtil.showCustomDialog(context, backgroundColor: Colors.white, child: _buildCustomerInfoDialog());
                },
                child: Text(
                  'text.see_more'.tr(),
                  style: Theme.of(context).textTheme.small.copyWith(
                        color: colorBlue7,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      content = Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: 40,
              child: Icon(
                NovaSolidIcon.user_information,
                size: 30,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.salesCartDto.getCustFullName(),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.normal.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  BlocProvider.of<ApplicationBloc>(context).state.getCensorPhoneNo(widget.salesCartDto.getCustTelNo()),
                  style: Theme.of(context).textTheme.small,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: colorGreyBlue,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorGreyBlueShadow,
            blurRadius: 5.0,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: content,
      ),
    );
  }

  Widget _buildShipToPanel(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'text.delivery_method'.tr(),
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.normal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Container(
          height: getListViewHeight(),
          child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: getListViewHeight() == null,
              itemCount: _shipToCustomerList.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildShipToBox(context, _shipToCustomerList[index].partnerCustomer);
              }),
        ),
        SizedBox(height: 5),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            primary: colorBlue5,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: () => _onCreateCustomerValidate(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '+ ${'text.new_ship_to_address'.tr()}',
                style: Theme.of(context).textTheme.small.copyWith(
                      color: colorBlue7,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShipToBox(BuildContext context, Customer shipto) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            if (await _validateBackStep() ?? true) {
              _onTapInquiry(widget.salesCartDto.shipToCustomer != shipto, false, shipto);
            }
          },
          child: Container(
            constraints: BoxConstraints(minHeight: 70),
            decoration: BoxDecoration(
              color: colorGrey4,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCheckbox(
                    isCheckIcon: false,
                    value: widget.salesCartDto.shipToCustomer?.customerOid == shipto.customerOid,
                    onChanged: (value) async {
                      if (await _validateBackStep() ?? true) {
                        _onTapInquiry(value, false, shipto);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.pin_drop),
                  ),
                  Expanded(
                    child: Text(
                      StringUtil.getAddress(
                        shipto.village,
                        shipto.floor,
                        shipto.unit,
                        shipto.soi,
                        shipto.moo,
                        shipto.number,
                        shipto.street,
                        shipto.subDistrict,
                        shipto.district,
                        shipto.province,
                        shipto.zipCode,
                      ),
                      style: Theme.of(context).textTheme.small.copyWith(
                            color: colorDark,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildReceiveAtHomeproPanel(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => _onTapCustomerReceiveValidate(!widget.salesCartDto.isCustomerReceive),
          child: Container(
            constraints: BoxConstraints(minHeight: 70),
            decoration: BoxDecoration(
              color: colorGrey4,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              image: DecorationImage(image: AssetImage("assets/images/pickupatbranch.png"), alignment: Alignment.centerRight),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCheckbox(
                    isCheckIcon: false,
                    value: widget.salesCartDto.isCustomerReceive,
                    onChanged: (value) => _onTapCustomerReceiveValidate(value),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.pin_drop,
                    ),
                  ),
                  Text(
                    'text.customer_receive'.tr(),
                    style: Theme.of(context).textTheme.normal.copyWith(
                          color: colorDark,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        if (widget.salesCartDto.isCustomerReceive)
          Column(
            children: [
              ShippingPointStoreItem(shippingPointStore: widget.salesCartDto.shippingPointStore),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  primary: colorBlue5,
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () => _onTapCustomerReceiveValidate(widget.salesCartDto.isCustomerReceive),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'text.more_store'.tr(),
                      style: Theme.of(context).textTheme.small.copyWith(color: colorBlue7, decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            ],
          )
      ],
    );
  }

  Widget _buildCustomerInfoDialog() {
    String sapId = widget?.salesCartDto?.salesCart?.customer?.sapId;

    return Container(
      width: 300,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 70,
              child: Image.asset('assets/images/home_card.png'),
            ),
            title: Row(
              children: [
                Text(
                  widget.salesCartDto.getCustCardNo(),
                  style: Theme.of(context).textTheme.normal.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(width: 5),
                if (!StringUtil.isNullOrEmpty(sapId))
                  Container(
                    height: 22,
                    child: FadeInImage.assetNetwork(
                      placeholder: '',
                      placeholderErrorBuilder: (context, error, stackTrace) => Container(),
                      image: ImageUtil.getFullURL(getIt<CustomerInformationService>().getTierImage(sapId)),
                      imageErrorBuilder: (context, error, stackTrace) => Container(),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 5),
          ListTile(
            title: Text(
              'text.customer_point'.tr(),
              style: Theme.of(context).textTheme.normal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(
              ' ' + StringUtil.getDefaultCurrencyFormat(widget.salesCartDto.totalMemberPoint),
              style: Theme.of(context).textTheme.normal,
            ),
          ),
          Divider(
            color: colorDividerGrey,
            thickness: 1,
          ),
          SizedBox(height: 2),
          ListTile(
            title: Text(
              'common.name'.tr(),
              style: Theme.of(context).textTheme.normal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(
              ' ' + widget.salesCartDto.salesCart.customer.firstName ?? '',
              style: Theme.of(context).textTheme.normal,
            ),
          ),
          Divider(
            color: colorDividerGrey,
            thickness: 1,
          ),
          SizedBox(height: 2),
          ListTile(
            title: Text(
              'text.lastname'.tr(),
              style: Theme.of(context).textTheme.normal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(
              ' ' + widget.salesCartDto.salesCart.customer.lastName ?? '',
              style: Theme.of(context).textTheme.normal,
            ),
          ),
          Divider(
            color: colorDividerGrey,
            thickness: 1,
          ),
          SizedBox(height: 2),
          ListTile(
            title: Text(
              'text.telephone'.tr(),
              style: Theme.of(context).textTheme.normal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(
              ' ' + BlocProvider.of<ApplicationBloc>(context).state.getCensorPhoneNo(widget.salesCartDto.salesCart.customer.phoneNumber1),
              style: Theme.of(context).textTheme.normal,
            ),
          ),
          Divider(
            color: colorDividerGrey,
            thickness: 1,
          ),
          SizedBox(height: 2),
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'common.dialog_button_ok'.tr(),
                      style: Theme.of(context).textTheme.normal.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
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
}
