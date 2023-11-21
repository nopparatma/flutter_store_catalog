part of 'order.dart';

class InquiryAndReserveQueuePanel extends StatefulWidget {
  final SalesCartDto salesCartDto;
  final OrderBloc orderBloc;
  final DeliveryInquiryReserveBloc inquiryReserveBloc;
  final bool isPortrait;
  final bool isEnableSameDayPanel;

  InquiryAndReserveQueuePanel({
    this.salesCartDto,
    this.orderBloc,
    this.inquiryReserveBloc,
    this.isPortrait = false,
    this.isEnableSameDayPanel = true,
  });

  @override
  InquiryAndReserveQueuePanelState createState() => InquiryAndReserveQueuePanelState();
}

class InquiryAndReserveQueuePanelState extends State<InquiryAndReserveQueuePanel> {
  bool _isEnableReserveSameTime = true;
  bool _isEnableSameDay = true;
  bool _isReserveSameTime = false;
  bool _isSameDay = false;

  String _errorMessage = '';

  String deliveryDate = '';
  SalesCartReserve _salesCartReserve;

  @override
  void initState() {
    _salesCartReserve = BlocProvider.of<SalesCartBloc>(context).state.salesCartReserve;
    if (_salesCartReserve.soMode == SOMode.CUST_RECEIVE) {
      _isEnableReserveSameTime = false;
      _isEnableSameDay = false;
    }

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<bool> _validateBackStep() async {
    if (widget.orderBloc.state is CalculatePromotionCompleteState) {
      return await DialogUtil.showCustomDialog(context, child: PopupBackStep('common.dialog_title_warning'.tr(), '${'warning.edit_delivery_date.first'.tr()}\n${'warning.edit_delivery_date.second'.tr()}', CancelSalesType.SalesOrder)) ?? false;
    }
    return null;
  }

  Future<void> _onOpenPopupEditDate(QueueDataItemDto editDateItem) async {
    await DialogUtil.showCustomDialog(
      context,
      child: _PopupSelectDayReserveQueue(
        widget.orderBloc,
        widget.inquiryReserveBloc,
        editDateItem,
        widget.salesCartDto.displayQueueItemList,
        _salesCartReserve.soMode,
      ),
    );
  }

  Future<void> _onInquirySameDaySingleDay() async {
    bool validateBack = await _validateBackStep();
    if (validateBack != null) {
      if (validateBack) widget.orderBloc.add(BackStepToInquiryPanel(backStepFlag: OrderStepBackFlag.INQUIRY_SAME_DAY_SINGLE_DAY));
    } else {
      widget.inquiryReserveBloc.add(
        InquiryQueueEvent(salesCartReserve: _salesCartReserve),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeliveryInquiryReserveBloc, DeliveryInquiryReserveState>(
          bloc: widget.inquiryReserveBloc,
          condition: (prevState, currentState) {
            return true;
          },
          listener: (context, state) async {
            if (state is InquiryQueueErrorState) {
              if (state.error is AppException) {
                if (state.error.error is WarningWebApiException) {
                  WarningWebApiException warnError = state.error.error;
                  _errorMessage = '${warnError.error}';
                } else if (state.error.error is ErrorWebApiException) {
                  ErrorWebApiException errorError = state.error.error;
                  _errorMessage = '${errorError.error}';
                } else {
                  _errorMessage = '${state.error.error}';
                }
              }
            } else if (state is InquiryQueueSuccessState) {
              if (_salesCartReserve.isSameDay && !state.canReserveSameDay) {
                _salesCartReserve.isSameDay = false;
                _isEnableSameDay = false;
                _salesCartReserve.isReserveSingleTime = _isReserveSameTime;
              }
              _isSameDay = _salesCartReserve.isSameDay;
              _isReserveSameTime = _salesCartReserve.isReserveSingleTime;
            }
          },
        ),
        BlocListener<OrderBloc, OrderState>(
          listener: (context, state) async {
            if (state is InquiryQueueCompleteState) {
              if (state.backStepFlag == OrderStepBackFlag.INQUIRY_SAME_DAY_SINGLE_DAY) {
                widget.inquiryReserveBloc.add(
                  InquiryQueueEvent(salesCartReserve: _salesCartReserve),
                );
              } else if (state.backStepFlag == OrderStepBackFlag.EDIT_DELIVERY_DATE) {
                _onOpenPopupEditDate(state.editDateItem);
              }
            }
          },
        ),
      ],
      child: BlocBuilder<DeliveryInquiryReserveBloc, DeliveryInquiryReserveState>(
        bloc: widget.inquiryReserveBloc,
        condition: (previousState, currentState) {
          if (currentState is DeliveryInquiryReserveLoadingState) {
            return false;
          }

          return true;
        },
        builder: (context, state) {
          if (widget.isPortrait) {
            return _buildOrderPortrait(context);
          } else {
            return _buildOrderLandscape(context);
          }
        },
      ),
    );
  }

  Widget _buildOrderLandscape(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          if (widget.isEnableSameDayPanel) _buildNextDaySameDayPanel(context),
          if (widget.isEnableSameDayPanel) SizedBox(height: 10),
          _buildItems(context),
        ],
      ),
    );
  }

  Widget _buildOrderPortrait(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: widget.isEnableSameDayPanel ? _buildNextDaySameDayPanel(context) : Container(),
        ),
        SizedBox(width: 40.0),
        Expanded(
          flex: 1,
          child: _buildItems(context),
        ),
      ],
    );
  }

  Widget _buildNextDaySameDayPanel(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomCheckbox(
              value: _isReserveSameTime,
              isCheckIcon: false,
              onChanged: _isEnableReserveSameTime
                  ? (value) {
                      _salesCartReserve.isReserveSingleTime = value;
                      if (value) _salesCartReserve.isSameDay = false;
                      _onInquirySameDaySingleDay();
                    }
                  : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'text.reserve_queue_single_day'.tr(),
                      style: Theme.of(context).textTheme.normal.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'text.reserve_queue_single_day_remark'.tr(),
                      style: Theme.of(context).textTheme.small,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCheckbox(
              value: _isSameDay,
              isCheckIcon: false,
              onChanged: _isEnableSameDay
                  ? (value) {
                      _salesCartReserve.isSameDay = value;
                      if (value) _salesCartReserve.isReserveSingleTime = false;
                      _onInquirySameDaySingleDay();
                    }
                  : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      child: Image.asset('assets/images/${context.locale.toString()}/sameday_2.png'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItems(BuildContext context) {
    return ListView.separated(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: widget.salesCartDto.displayQueueItemList.length + 1,
        itemBuilder: (BuildContext context, int index) {
          //Divider For Last Item
          if (index == widget.salesCartDto.displayQueueItemList.length) {
            return Container();
          }

          QueueDataItemDto item = widget.salesCartDto.displayQueueItemList[index];
          return _buildListItem(context, item);
        });
  }

  Widget _buildListItem(BuildContext context, QueueDataItemDto item) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItemImage(context, item),
            SizedBox(width: 20),
            Expanded(
              child: _buildItemDetail(context, item),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        _buildDeliveryDatePanel(context, item),
        SizedBox(height: 5.0),
      ],
    );
  }

  Widget _buildItemImage(BuildContext context, QueueDataItemDto item) {
    String imgUrl;
    if (item.basketItem?.article?.imageList?.isNotNE ?? false) {
      imgUrl = item.basketItem.getImageUrl();
    }

    if (!item.salesCartItem.isMainInstall) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 80.0,
          height: 80.0,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FadeInImage(
                fit: BoxFit.fill,
                placeholder: AssetImage('assets/images/non_article_image.png'),
                image: item.salesCartItem.isLocalImage() ? AssetImage(item.salesCartItem.getImagePath()) : NetworkImage(ImageUtil.getFullURL(imgUrl)),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/non_article_image.png',
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 88.0,
      );
    }
  }

  Widget _buildItemDetail(BuildContext context, QueueDataItemDto item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.salesCartItem.itemDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.normal,
        ),
        Text(
          'text.sku.colon'.tr(args: ['${StringUtil.trimLeftZero(item.salesCartItem.articleNo)}']),
          style: Theme.of(context).textTheme.small.copyWith(color: Colors.grey),
        ),
        Text(
          'text.qty.colon'.tr(args: ['${item.salesCartItem.qty}']),
          style: Theme.of(context).textTheme.small.copyWith(color: Colors.grey),
        ),
        _buildPrice(context, item),
        _buildInstallService(context, item),
        _buildViewCheckList(context, item),
      ],
    );
  }

  Widget _buildPrice(BuildContext context, QueueDataItemDto item) {
    bool showPromotionPrice = false;
    String priceText = '';
    Color txtColor = Color(0xFF15213F);

    if (item.salesCartItem.isPremium) {
      txtColor = Colors.red;
      priceText = 'text.free'.tr();
    } else if (item.basketItem?.isHaveSpecialPrice() ?? false) {
      showPromotionPrice = true;
      txtColor = Colors.red;
      priceText = StringUtil.getDefaultCurrencyFormat(item.basketItem?.getPromotionPrice() ?? 0);
    } else {
      priceText = StringUtil.getDefaultCurrencyFormat(item.basketItem?.getNormalPrice() ?? 0);
    }

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          if (showPromotionPrice)
            TextSpan(
              text: '${StringUtil.getDefaultCurrencyFormat(item.basketItem?.getNormalPrice() ?? 0)}',
              style: Theme.of(context).textTheme.small.copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough),
            ),
          if (showPromotionPrice)
            TextSpan(
              text: ' ',
            ),
          TextSpan(
            text: priceText,
            style: Theme.of(context).textTheme.normal.copyWith(
                  fontWeight: FontWeight.bold,
                  color: txtColor,
                ),
          ),
          if (!item.salesCartItem.isPremium)
            TextSpan(
              text: ' ',
            ),
          if (!item.salesCartItem.isPremium)
            TextSpan(
              text: 'text.baht'.tr(),
              style: Theme.of(context).textTheme.small,
            ),
        ],
      ),
    );
  }

  Widget _buildDeliveryDatePanel(BuildContext context, QueueDataItemDto item) {
    String dateStr = item.selectedDate.isNull ? '' : DateTimeUtil.toDateTimeString(item.selectedDate, 'dd/MM/yyyy');

    String _itemErrorMsg = _errorMessage;
    if (_itemErrorMsg.isNullEmptyOrWhitespace && item.selectedDate.isNull && !item.isPending) {
      _itemErrorMsg = 'text.error_cannot_inquiry_delivery_date'.tr();
    }

    bool isCR = item.patType == PatType.COURIER;
    bool isPending = item.isPending;

    return Container(
      //height: (item.selectedTimeNo.isNotNE && item.selectedTimeNo != TimeNo.NO_DURATION ? 50 : 30,
      constraints: BoxConstraints(minHeight: 30),
      decoration: BoxDecoration(
          color: colorBlue5,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          border: Border.all(
            color: _itemErrorMsg.isEmpty ? Colors.transparent : Colors.red,
          )),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            if (!isPending)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(
                  NovaSolidIcon.calendar_timeout,
                  color: _itemErrorMsg.isEmpty ? colorBlue7 : Colors.red,
                ),
              ),
            Expanded(
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: _itemErrorMsg.isEmpty
                          ? !isCR
                              ? !isPending
                                  ? '${'text.receive_date'.tr()} $dateStr'
                                  : 'text.pending_msg_reserve_date'.tr()
                              : 'text.courier_delivery_date'.tr()
                          : _itemErrorMsg,
                      style: Theme.of(context).textTheme.small.copyWith(
                            color: _itemErrorMsg.isEmpty ? colorBlue2_2 : Colors.red,
                          ),
                    ),
                    WidgetSpan(
                        child: SizedBox(
                      width: 5,
                    )),
                    if (item.selectedTimeNo.isNotNE && item.selectedTimeNo != TimeNo.NO_DURATION)
                      TextSpan(
                        text: '\n${_getTimeDetail(item.selectedTimeNo)}',
                        style: Theme.of(context).textTheme.small.copyWith(
                              color: _itemErrorMsg.isEmpty ? colorBlue2_2 : Colors.red,
                            ),
                      ),
                  ],
                ),
              ),
            ),
            if (!isCR && !isPending && item.selectedDate.isNotNull && item.fastestDate != null && item.fastestDate.compareTo(item.selectedDate) == 0 && item.fastestTime == item.selectedTimeNo)
              Container(
                height: 20,
                child: Image.asset('assets/images/${context.locale.toString()}/fastest.png'),
              ),
            if (!isCR && !isPending && _itemErrorMsg.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InkWell(
                  onTap: () async {
                    bool validateBack = await _validateBackStep();
                    if (validateBack != null) {
                      if (validateBack) widget.orderBloc.add(BackStepToInquiryPanel(backStepFlag: OrderStepBackFlag.EDIT_DELIVERY_DATE, editDateItem: item));
                    } else {
                      _onOpenPopupEditDate(item);
                    }
                  },
                  child: Text(
                    'text.edit'.tr(),
                    style: Theme.of(context).textTheme.small.copyWith(
                          color: colorBlue7,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getTimeDetail(String timeNo) {
    DsTimeGroup timeGrp = BlocProvider.of<ApplicationBloc>(context).state.getDsTimeGroupRs?.dsTimeGroups?.firstWhere((e) => e.timeNo == timeNo, orElse: () => null);

    if (timeGrp.isNull) {
      return '';
    }
    return '${timeGrp.timeName} ${timeGrp.timeDesc}';
  }

  Widget _buildInstallService(BuildContext context, QueueDataItemDto item) {
    if (item.queueItemInstallServices.isNullOrEmpty) {
      return SizedBox.shrink();
    }

    List<QueueDataItemDto> itemsInsServ = item.queueItemInstallServices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: itemsInsServ.length,
          itemBuilder: (context, index) => _buildItemInstallService(context, itemsInsServ[index]),
          separatorBuilder: (context, index) => Divider(),
        ),
      ],
    );
  }

  Widget _buildItemInstallService(BuildContext context, QueueDataItemDto item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.salesCartItem.itemDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.normal,
        ),
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: StringUtil.getDefaultCurrencyFormat(item.salesCartItem.unitPrice ?? 0),
                style: Theme.of(context).textTheme.normal.copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' ',
              ),
              TextSpan(
                text: 'text.baht'.tr(),
                style: Theme.of(context).textTheme.small,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildViewCheckList(BuildContext context, QueueDataItemDto item) {
    if (item.basketItem == null || item.salesCartItem.installCheckListId == null) {
      return SizedBox.shrink();
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            color: colorBlue5,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  MdiIcons.clipboardCheckOutline,
                  color: Color(0xFF1F5FFF),
                  size: 20,
                ),
                Text(' ', style: Theme.of(context).textTheme.small),
                Expanded(
                  child: Text(
                    'text.header_checklist'.tr(),
                    style: Theme.of(context).textTheme.small.copyWith(color: Color(0xFF1F5FFF)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  child: Row(
                    children: [
                      Text('text.view'.tr(),
                          style: Theme.of(context).textTheme.small.copyWith(
                                decoration: TextDecoration.underline,
                                color: Color(0xFF1F5FFF),
                                fontWeight: FontWeight.bold,
                              )),
                    ],
                  ),
                  onTap: () async {
                    bool isLandscape = MediaQuery.maybeOf(context).size.width > MediaQuery.maybeOf(context).size.height;

                    DialogUtil.showCustomDialog(
                      context,
                      child: Container(
                        width: 800,
                        height: MediaQuery.of(context).size.height * (isLandscape ? 0.8 : 0.5),
                        child: ViewAnswerPanel(
                          articleDetail: item.basketItem.article,
                          sgTrnItemOid: item.salesCartItem.installCheckListId,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PopupSelectDayReserveQueue extends StatefulWidget {
  final OrderBloc orderBloc;
  final DeliveryInquiryReserveBloc inquiryReserveBloc;
  final QueueDataItemDto selectQueueDataItemDto;
  final List<QueueDataItemDto> queueDataItemDtoList;
  final String soMode;

  _PopupSelectDayReserveQueue(
    this.orderBloc,
    this.inquiryReserveBloc,
    this.selectQueueDataItemDto,
    this.queueDataItemDtoList,
    this.soMode,
  );

  @override
  _PopupSelectDayReserveQueueState createState() => _PopupSelectDayReserveQueueState();
}

class _PopupSelectDayReserveQueueState extends State<_PopupSelectDayReserveQueue> {
  double popupWidth;
  double timeBoxWidth;
  String timeNoSelected;
  DateTime dateSelected;
  DateTime dateFocus;
  GetDsTimeGroupRs getDsTimeGroupRs;
  SalesCartReserve _salesCartReserve;

  @override
  void initState() {
    getDsTimeGroupRs = BlocProvider.of<ApplicationBloc>(context).state.getDsTimeGroupRs;

    dateSelected = widget.selectQueueDataItemDto.selectedDate;
    dateFocus = widget.selectQueueDataItemDto.selectedDate;
    timeNoSelected = widget.selectQueueDataItemDto.selectedTimeNo;

    _salesCartReserve = BlocProvider.of<SalesCartBloc>(context).state.salesCartReserve;

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeOf(context).size.width < VERTICAL_WIDTH || MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width) {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.75;
    } else {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.5;
    }

    timeBoxWidth = (popupWidth - (popupWidth * 0.1)) / getDsTimeGroupRs.dsTimeGroups.length;

    return BlocConsumer<DeliveryInquiryReserveBloc, DeliveryInquiryReserveState>(
        bloc: widget.inquiryReserveBloc,
        listener: (context, state) async {
          if (state is InquiryQueueSelectDaySuccessState) {
            widget.selectQueueDataItemDto.queueDateMap = state.queueDataItemDto.queueDateMap;
            timeNoSelected = null;

            DateTime date = DateTimeUtil.toDate(dateFocus);
            if (widget.selectQueueDataItemDto.queueDateMap.containsKey(date) && widget.selectQueueDataItemDto.queueDateMap[date].status == DateStatus.Available) {
              dateSelected = dateFocus;
            }
          }
        },
        builder: (context, state) {
          return Container(
            width: popupWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: popupWidth * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'text.select_receive_date'.tr(),
                    style: Theme.of(context).textTheme.larger.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 350,
                    ),
                    child: _buildCalendar(context),
                  ),
                  SizedBox(height: 10),
                  if (widget.soMode != SOMode.CUST_RECEIVE) _buildTimePanel(context),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: colorGrey3,
                            ),
                            color: colorGreen3),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'text.available'.tr(),
                        style: Theme.of(context).textTheme.normal.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      SizedBox(
                        width: 60.0,
                      ),
                      Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: colorBlue7,
                            ),
                            color: colorBlue4),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'text.selected_date'.tr(),
                        style: Theme.of(context).textTheme.normal.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      SizedBox(
                        width: 60.0,
                      ),
                      Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: colorGrey4,
                            ),
                            color: colorGrey3),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'text.full_queue'.tr(),
                        style: Theme.of(context).textTheme.normal.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: popupWidth * 0.4,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        primary: colorBlue7,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                      ),
                      onPressed: dateSelected != null && (timeNoSelected != null || widget.soMode == SOMode.CUST_RECEIVE)
                          ? () {
                              widget.selectQueueDataItemDto.selectedDate = dateSelected;
                              widget.selectQueueDataItemDto.selectedTimeNo = timeNoSelected;
                              widget.selectQueueDataItemDto.selectedTimeType = timeNoSelected == TimeNo.NO_DURATION ? TimeType.NO_DURATION : TimeType.SPECIFY_DURATION;

                              if (_salesCartReserve.isReserveSingleTime) {
                                widget.queueDataItemDtoList.forEach((e) {
                                  if (e.isPending) return;
                                  e.selectedDate = dateSelected;
                                  e.selectedTimeNo = timeNoSelected;
                                  e.selectedTimeType = timeNoSelected == TimeNo.NO_DURATION ? TimeType.NO_DURATION : TimeType.SPECIFY_DURATION;
                                });
                              }

                              if (SOMode.DELIVERY == _salesCartReserve.soMode && QueueStyle.NEXT_DAY == widget.selectQueueDataItemDto.queueStyle) {
                                widget.inquiryReserveBloc.add(CalculateDeliveryFeeEvent(widget.queueDataItemDtoList));
                              } else {
                                widget.orderBloc.add(ChangeQueueDateToEvent());
                              }
                              Navigator.pop(context);
                            }
                          : null,
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
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTimePanel(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Text(
            'text.select_time'.tr(),
            style: Theme.of(context).textTheme.normal.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Container(
        constraints: BoxConstraints(minHeight: 50),
        child: IntrinsicHeight(
          child: Row(
            children: getDsTimeGroupRs.dsTimeGroups.map((e) {
              return _buildTimeBox(
                context,
                e.timeNo,
                e.timeName,
                e.timeDesc,
              );
            }).toList(),
          ),
        ),
      ),
    ]);
  }

  Widget _buildTimeBox(BuildContext context, String timeNo, String timeName, String timeRange) {
    if (timeNo == TimeNo.NO_DURATION) {
      timeRange = '';
    }

    DateTime date = DateTimeUtil.toDate(dateFocus);
    bool isEnable = widget.selectQueueDataItemDto.queueDateMap.containsKey(date) && widget.selectQueueDataItemDto.queueDateMap[date].queueTime.isNotNE && widget.selectQueueDataItemDto.queueDateMap[date].queueTime.any((element) => element.timeNo == timeNo);

    return InkWell(
      onTap: isEnable
          ? () {
              setState(() {
                timeNoSelected = timeNo;
              });
            }
          : null,
      child: Container(
        width: timeBoxWidth,
        decoration: BoxDecoration(
          border: Border.all(color: timeNoSelected == timeNo && isEnable ? colorBlue7 : Colors.grey),
          color: !isEnable
              ? colorGrey3
              : timeNoSelected == timeNo
                  ? colorBlue4
                  : colorGreen3,
        ),
        child: Column(
          children: [
            Text(
              timeName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.normal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if(timeNo != '0')
            Text(
              timeRange,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.small,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return CustomTableCalendar(
      lang: context.locale.toString(),
      startDate: DateTimeUtil.toDate(DateTime.now()),
      endDate: _salesCartReserve.isSameDay ? DateTimeUtil.toDate(DateTime.now()) : DateTimeUtil.toDate(DateTime.utc(2999, 12, 31)),
      selectedDate: dateSelected,
      focusDate: dateFocus,
      readyDateInStock: widget.selectQueueDataItemDto.readyDateInStock,
      queueDateMap: widget.selectQueueDataItemDto.queueDateMap,
      soMode: widget.soMode,
      headerMagin: EdgeInsets.symmetric(horizontal: popupWidth * 0.15),
      onDaySelected: (selectedDate, focusedDate) {
        if (selectedDate.month == focusedDate.month && selectedDate.year == focusedDate.year) {
          selectedDate = DateTimeUtil.toDate(selectedDate);
          if (widget.selectQueueDataItemDto.queueDateMap.containsKey(selectedDate) || widget.soMode == SOMode.CUST_RECEIVE) {
            setState(() {
              dateSelected = selectedDate;
              dateFocus = selectedDate;
              timeNoSelected = null;
            });
          } else {
            dateFocus = selectedDate;

            widget.inquiryReserveBloc.add(InquiryQueueSelectDateEvent(
              salesCartReserve: _salesCartReserve,
              inquiryDate: selectedDate,
              selectQueueDataItemDto: widget.selectQueueDataItemDto,
              queueDataItemDtoList: widget.queueDataItemDtoList,
            ));
          }
        }
      },
      // queueDateMap: null,
    );
  }
}
