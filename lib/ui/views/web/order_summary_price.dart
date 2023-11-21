part of 'order.dart';

class SummaryPrice extends StatefulWidget {
  final SalesCartDto salesCartDto;
  final OrderBloc orderBloc;
  final DeliveryInquiryReserveBloc inquiryReserveBloc;
  final CalculatePromotionBloc calProBloc;
  final AutoScrollController scrollController;
  final int autoScrollTabIndex;

  SummaryPrice({
    this.salesCartDto,
    this.orderBloc,
    this.inquiryReserveBloc,
    this.calProBloc,
    this.scrollController,
    this.autoScrollTabIndex,
  });

  @override
  SummaryPriceState createState() => SummaryPriceState();
}

class SummaryPriceState extends State<SummaryPrice> {
  SalesCartReserve _salesCartReserve;
  SalesCartDto _salesCartDto;

  @override
  void initState() {
    _salesCartDto = BlocProvider.of<SalesCartBloc>(context).state.salesCartDto;
    _salesCartReserve = BlocProvider.of<SalesCartBloc>(context).state.salesCartReserve;
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<void> onShowPopUpConfirmAppointment(bool isEdit) async {
    var close = await DialogUtil.showCustomDialog(
      context,
      isScrollView: false,
      child: _PopupConfirmReserveQueue(
        widget.orderBloc,
        _salesCartDto.displayQueueItemList,
        isEdit: isEdit,
      ),
    );
    if (isEdit && (close ?? false)) {
      onConfirmReserveQueue();
      //รอปรับโค้ดอีกครั้ง
    }
  }

  void onConfirmReserveQueue() {
    List<QueueData> newQueueDataList = <QueueData>[];

    /// ข้อมูลสำหรับปั้น queueDataList ไม่เกี่ยวกับหน้าจอ
    /// กัน artc maininstall ที่อยู่เป็น detail กับมาเป็นตัวหลัก
    List<QueueDataItemDto> queueItemDtoForReserve = <QueueDataItemDto>[];
    _salesCartDto.displayQueueItemList.forEach((displayQueueItem) {
      queueItemDtoForReserve.add(displayQueueItem);
      if (displayQueueItem.queueItemInstallServices.isNotNE) {
        displayQueueItem.queueItemInstallServices.forEach((insServItem) {
          insServItem.contactName = displayQueueItem.contactName;
          insServItem.contactTel = displayQueueItem.contactTel;
          insServItem.spacialOrderText = displayQueueItem.spacialOrderText;

          insServItem.selectedDate = displayQueueItem.selectedDate;
          insServItem.selectedTimeNo = displayQueueItem.selectedTimeNo;
          insServItem.selectedTimeType = displayQueueItem.selectedTimeType;
          insServItem.fastestDate = displayQueueItem.fastestDate;
          insServItem.fastestTime = displayQueueItem.fastestTime;
          queueItemDtoForReserve.add(insServItem);
        });
      }
    });

    queueItemDtoForReserve.forEach((e) {
      if (newQueueDataList.isNotNE) {}

      List<QueueDataItem> qItemList = [];

      QueueData queueData = _salesCartReserve.queueDataList.firstWhere((qData) => qData.queueDataItems.any((item) => item.salesCartItem == e.salesCartItem), orElse: () => null);
      QueueDataItem qItem = queueData?.queueDataItems?.firstWhere((item) => item.salesCartItem == e.salesCartItem, orElse: () => null);
      if (qItem != null) qItemList.add(qItem);

      QueueData alreadyQueueData = newQueueDataList.isNotNE ? newQueueDataList.firstWhere((element) => compareQueueData(e, element), orElse: () => null) : null;
      if (alreadyQueueData.isNull) {
        QueueData newQueueData = QueueData(
          shippointManage: queueData.shippointManage,
          queueStyle: e.queueStyle,
          prdNo: e.prdNo,
          patType: e.patType,
          jobType: e.jobType,
          jobNo: e.jobNo,
          dateIntoStock: e.readyDateInStock,
          isCanReserveQueue: _salesCartReserve.isReserveSingleTime,
          isSameDay: _salesCartReserve.isSameDay,
          queueDataItems: qItemList,
          selectedTimeType: e.selectedTimeType,
          selectedTimeNo: e.selectedTimeNo,
          selectedDate: e.selectedDate,
          appointmentType: ConfType.SMS,
          contactName: e.contactName,
          contactTel: e.contactTel,
          spacialOrderText: e.spacialOrderText,
          isPending: e.isPending,
        );

        newQueueDataList.add(newQueueData);
      } else {
        alreadyQueueData.queueDataItems.addAll(qItemList);
      }
    });

    _salesCartReserve.queueDataList = newQueueDataList;

    if (_salesCartReserve.isReserveSingleTime) {
      _salesCartReserve.queueDataList.forEach((e) {
        e.queueReserveSingleTimeGroup = newQueueDataList;
      });
    }

    widget.inquiryReserveBloc.add(ReserveQueueEvent());
    //widget.orderBloc.add(OrderReserveQueueEvent());
  }

  bool compareQueueData(QueueDataItemDto a, QueueData b) {
    return a.shippointManage == b.shippointManage && a.queueStyle == b.queueStyle && a.prdNo == b.prdNo && a.patType == b.patType && a.jobType == b.jobType && a.jobNo == b.jobNo && a.selectedTimeType == b.selectedTimeType && a.selectedTimeNo == b.selectedTimeNo && a.selectedDate == b.selectedDate && a.isPending == b.isPending;
  }

  @override
  Widget build(BuildContext context) {
    return _buildSummaryPrice(context);
  }

  Widget _buildSummaryPrice(BuildContext context) {
    return BlocBuilder<CalculatePromotionBloc, CalculatePromotionState>(
        bloc: widget.calProBloc,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'text.total_price'.tr(),
                style: Theme.of(context).textTheme.large.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    'text.total_price'.tr(),
                    style: Theme.of(context).textTheme.normal,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        StringUtil.getDefaultCurrencyFormat(_salesCartDto.totalPrice),
                        style: Theme.of(context).textTheme.normal,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  Text(
                    'text.baht'.tr(),
                    style: Theme.of(context).textTheme.normal,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              Column(
                children: _salesCartReserve.articleDeliveryFees.isNotNE
                    ? _salesCartReserve.articleDeliveryFees.map((e) => _buildDeliveryFee(e.artDesc, e.totalPrice)).toList()
                    : [
                        _buildDeliveryFee('text.delivery_fee'.tr(), 0),
                      ],
              ),
              Row(
                children: [
                  Text(
                    'text.total_discount'.tr(),
                    style: Theme.of(context).textTheme.normal,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        StringUtil.getDefaultCurrencyFormat(_salesCartDto.totalDiscount),
                        style: Theme.of(context).textTheme.normal,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  Text(
                    'text.baht'.tr(),
                    style: Theme.of(context).textTheme.normal,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      'text.net_amount'.tr(),
                      style: Theme.of(context).textTheme.normal,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        StringUtil.getDefaultCurrencyFormat(_salesCartDto.netAmount),
                        style: Theme.of(context).textTheme.large.copyWith(
                              color: colorGreen2,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  Text(
                    'text.baht'.tr(),
                    style: Theme.of(context).textTheme.normal.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              Divider(),
              if (widget.orderBloc.state is InquiryQueueCompleteState)
                BlocBuilder<DeliveryInquiryReserveBloc, DeliveryInquiryReserveState>(
                    bloc: widget.inquiryReserveBloc,
                    builder: (context, state) {
                      bool isPayable = true;
                      if (state is InquiryQueueSuccessState) isPayable = state.isAllCanReserve;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  primary: colorBlue7,
                                  padding: const EdgeInsets.all(18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: isPayable ? () => onShowPopUpConfirmAppointment(true) : null,
                                child: Text(
                                  'text.next'.tr(),
                                  style: Theme.of(context).textTheme.normal.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              if (widget.orderBloc.state is QueueReservedState || widget.orderBloc.state is CalculatePromotionCompleteState)
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => onShowPopUpConfirmAppointment(false),
                        child: Text(
                          'text.delivery_address_view'.tr(),
                          style: Theme.of(context).textTheme.normal.copyWith(
                                color: colorBlue7,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        });
  }

  Widget _buildDeliveryFee(String desc, num amount) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            desc,
            style: Theme.of(context).textTheme.normal,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              StringUtil.getDefaultCurrencyFormat(amount),
              style: Theme.of(context).textTheme.normal,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Text(
          'text.baht'.tr(),
          style: Theme.of(context).textTheme.normal,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

class _PopupConfirmReserveQueue extends StatefulWidget {
  final OrderBloc orderBloc;
  final List<QueueDataItemDto> queueDataItemDtoList;
  final bool isEdit;

  _PopupConfirmReserveQueue(this.orderBloc, this.queueDataItemDtoList, {this.isEdit = true});

  @override
  _PopupConfirmReserveQueueState createState() => _PopupConfirmReserveQueueState();
}

class _PopupConfirmReserveQueueState extends State<_PopupConfirmReserveQueue> {

  double popupWidth;
  Map<DateTime, Map<String, TextEditingController>> confirmAppointmentData = Map<DateTime, Map<String, TextEditingController>>();

  GlobalKey<_BottomScreenPanelState> bottomScreenPanelKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  ScrollController scrollController;

  @override
  void initState() {
    List<QueueDataItemDto> sortedList = List<QueueDataItemDto>.from(widget.queueDataItemDtoList)
      ..sort((a, b) {
        if (a.selectedDate == null) return 1;
        if (b.selectedDate == null) return -1;
        return a.selectedDate.compareTo(b.selectedDate);
      });

    sortedList.forEach((element) {
      Map<String, TextEditingController> mapData = Map<String, TextEditingController>();
      mapData.putIfAbsent('name', () => TextEditingController(text: element.contactName));
      mapData.putIfAbsent('tel', () => TextEditingController(text: widget.isEdit ? element.contactTel : BlocProvider.of<ApplicationBloc>(context).state.getCensorPhoneNo(element.contactTel)));
      mapData.putIfAbsent('remark', () => TextEditingController(text: element.spacialOrderText));

      confirmAppointmentData.putIfAbsent(element.selectedDate, () => mapData);
    });

    scrollController = ScrollController();

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  void onConfirmAppointmentData() {
    if (_formKey.currentState.validate()) {
      widget.queueDataItemDtoList.forEach((e) {
        Map<String, TextEditingController> mapData = confirmAppointmentData[e.selectedDate];
        e.contactName = mapData['name'].text;
        e.contactTel = mapData['tel'].text;
        e.spacialOrderText = mapData['remark'].text;
      });

      Navigator.of(context).pop(true);
    }
  }

  bool checkKeyboardScrollUp(bool value, GlobalKey key){
    if(!value) return value;

    RenderBox box = key.currentContext.findRenderObject();
    num bottomY = box.localToGlobal(Offset.zero).dy + box.size.height + 200;

    return bottomY > MediaQuery.maybeOf(context).size.height;
  }

  Future<void> onViewItemThisDay(DateTime date) async {
    final List<QueueDataItemDto> queueDataItemDtoThisDay = widget.queueDataItemDtoList.where((e) => e.selectedDate == null || date == null ? e.selectedDate == date : e.selectedDate.compareTo(date) == 0).toList();
    List<QueueDataItemDto> allQueueDataItemThisDay = <QueueDataItemDto>[];
    queueDataItemDtoThisDay.forEach((element) {
      allQueueDataItemThisDay.add(element);
      if (element.queueItemInstallServices.isNotNE) allQueueDataItemThisDay.addAll(element.queueItemInstallServices);
    });
    await DialogUtil.showCustomDialog(context, child: _PopupItemOnThisDay(date, allQueueDataItemThisDay));
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeOf(context).size.width < VERTICAL_WIDTH || MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width) {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.75;
    } else {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.5;
    }

    return Container(
      width: popupWidth,
      height: MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width ? MediaQuery.maybeOf(context).size.height * 0.5 : popupWidth = MediaQuery.maybeOf(context).size.height * 0.8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: popupWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'text.delivery_address'.tr(),
              style: Theme.of(context).textTheme.larger.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: Form(
                key: _formKey,
                child: ListView.separated(
                    controller: scrollController,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) => Divider(),
                    itemCount: confirmAppointmentData.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      //Divider For Last Item
                      if (index == confirmAppointmentData.length) {
                        return Container();
                      }

                      DateTime date = confirmAppointmentData.keys.toList()[index];
                      return _buildInputConfirmQueue(context, date, confirmAppointmentData[date]);
                    }),
              ),
            ),
            SizedBox(height: 10),
            BottomScreenPanel(
              key: bottomScreenPanelKey,
              scrollController: scrollController,
            ),
            if (widget.isEdit)
              Container(
                width: popupWidth * 0.4,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      colorBlue7,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    )),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 20.0),
                    ),
                  ),
                  onPressed: onConfirmAppointmentData,
                  child: Text(
                    'text.payment'.tr(),
                    style: Theme.of(context).textTheme.normal.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            if (widget.isEdit) SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildInputConfirmQueue(BuildContext context, DateTime date, Map inputDataMap) {
    TextEditingController _name = inputDataMap['name'];
    TextEditingController _tel = inputDataMap['tel'];
    TextEditingController _remark = inputDataMap['remark'];
    GlobalKey inputBoxKey = GlobalKey();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              date == null ? 'text.pending_date'.tr() : '${DateTimeUtil.toDateTimeString(date, 'dd/MM/yyyy')}',
              style: Theme.of(context).textTheme.larger.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () => onViewItemThisDay(date),
              child: Text(
                'text.view_items_on_this_day'.tr(),
                style: Theme.of(context).textTheme.small.copyWith(
                      color: colorBlue7,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'text.contact_name'.tr(),
                style: Theme.of(context).textTheme.small.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorDark,
                    ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Text(
                'common.telephone'.tr(),
                style: Theme.of(context).textTheme.small.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorDark,
                    ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Text(
                'text.spacial_order_text'.tr(),
                style: Theme.of(context).textTheme.small.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorDark,
                    ),
              ),
            ),
          ],
        ),
        Container(
          key: inputBoxKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Focus(
                  onFocusChange: (value) {
                    bottomScreenPanelKey.currentState.setBottomVisible(checkKeyboardScrollUp(value, inputBoxKey));
                  },
                  child: VirtualKeyboardWrapper(
                    textController: _name,
                    maxLength: 50,
                    isAllowSpecialCharacter: false,
                    builder: (textEditingController, focusNode, inputFormatters) {
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        inputFormatters: inputFormatters,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'common.msg.please_enter_input'.tr(args: ['text.contact_name'.tr()]);
                          }
                          return null;
                        },
                        enabled: widget.isEdit,
                        style: Theme.of(context).textTheme.normal.copyWith(),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Focus(
                  onFocusChange: (value) {
                    bottomScreenPanelKey.currentState.setBottomVisible(checkKeyboardScrollUp(value, inputBoxKey));
                  },
                  child: VirtualKeyboardWrapper(
                    textController: _tel,
                    keyboardType: VirtualKeyboardType.Numeric,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    builder: (textEditingController, focusNode, inputFormatters) {
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        inputFormatters: inputFormatters,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'common.msg.please_enter_input'.tr(args: ['common.telephone'.tr()]);
                          } else if (value != null && value.length < 10) {
                            return 'text.please_specify_phone_ten_digits'.tr();
                          }
                          return null;
                        },
                        enabled: widget.isEdit,
                        keyboardType: TextInputType.number,
                        style: Theme.of(context).textTheme.normal.copyWith(),
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Focus(
                  onFocusChange: (value) {
                    bottomScreenPanelKey.currentState.setBottomVisible(checkKeyboardScrollUp(value, inputBoxKey));
                  },
                  child: VirtualKeyboardWrapper(
                    textController: _remark,
                    maxLength: 50,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(RegularExpression.CHARACTER_WITH_SPACE)),
                    ],
                    builder: (textEditingController, focusNode, inputFormatters) {
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        inputFormatters: inputFormatters,
                        enabled: widget.isEdit,
                        style: Theme.of(context).textTheme.normal,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: colorGrey3)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}

class _PopupItemOnThisDay extends StatefulWidget {
  final DateTime date;
  final List<QueueDataItemDto> itemList;

  _PopupItemOnThisDay(
    this.date,
    this.itemList,
  );

  @override
  _PopupItemOnThisDayState createState() => _PopupItemOnThisDayState();
}

class _PopupItemOnThisDayState extends State<_PopupItemOnThisDay> {
  double popupWidth;
  double popupHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  num getListViewHeight() {
    final num heightPerItem = 150;
    final num defaultHeight = MathUtil.multiple(heightPerItem, 3);

    num numOfItem = widget.itemList.length;
    num listviewHeight = MathUtil.multiple(heightPerItem, numOfItem);

    if (listviewHeight > defaultHeight && listviewHeight <= MediaQuery.maybeOf(context).size.height - 500) {
      return listviewHeight;
    }

    return defaultHeight;
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeOf(context).size.width < VERTICAL_WIDTH || MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width) {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.75;
    } else {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.5;
    }

    return Container(
      width: popupWidth,
      height: MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width ? MediaQuery.maybeOf(context).size.height * 0.5 : MediaQuery.maybeOf(context).size.height * 0.8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: popupWidth * 0.05),
        child: Column(
          children: [
            Text(
              'text.view_items_on_select_day'.tr(args: [widget.date == null ? 'text.pending_date'.tr() : '${DateTimeUtil.toDateTimeString(widget.date, 'dd/MM/yyyy')}']),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) => Divider(),
                itemCount: widget.itemList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == widget.itemList.length) {
                    return Container();
                  }

                  QueueDataItemDto item = widget.itemList[index];

                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                    child: _buildListItem(context, item, index),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: popupWidth * 0.4,
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
                  'common.dialog_button_close'.tr(),
                  style: Theme.of(context).textTheme.normal.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, QueueDataItemDto item, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemImage(context, item),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: _buildItemDetail(context, item),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemImage(BuildContext context, QueueDataItemDto item) {
    String imgUrl;
    if (item.basketItem?.article?.imageList?.isNotNE ?? false) {
      imgUrl = item.basketItem.getImageUrl();
    }

    if (item.basketItem?.isShowImage() ?? true) {
      return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: Container(
          width: 100.0,
          height: 100.0,
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
        width: 108.0,
      );
    }
  }

  Widget _buildItemDetail(BuildContext context, QueueDataItemDto item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.basketItem?.getArticleDesc() ?? item.salesCartItem.itemDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.normal,
        ),
        if (item.basketItem?.isShowArticleId() ?? true)
          Text(
            'text.sku.colon'.tr(args: ['${item.basketItem?.getArticleId() ?? item.salesCartItem.articleNo}']),
            style: Theme.of(context).textTheme.small.copyWith(color: Colors.grey),
          ),
        Text(
          'text.qty.colon'.tr(args: ['${item.basketItem?.qty ?? item.salesCartItem.qty}']),
          style: Theme.of(context).textTheme.small.copyWith(color: Colors.grey),
        ),
        _buildPrice(context, item),
      ],
    );
  }

  Widget _buildPrice(BuildContext context, QueueDataItemDto item) {
    bool showPromotionPrice = false;
    String priceText = '';
    Color txtColor = colorDark;

    if (item.basketItem?.isFreeItem ?? false) {
      txtColor = Colors.red;
      priceText = 'text.free'.tr();
    } else if (item.basketItem?.getPromotionPrice() != null) {
      showPromotionPrice = true;
      txtColor = Colors.red;
      priceText = StringUtil.getDefaultCurrencyFormat(item.basketItem?.getPromotionPrice() ?? 0);
    } else {
      priceText = StringUtil.getDefaultCurrencyFormat(item.basketItem?.getNormalPrice() ?? item.salesCartItem.unitPrice);
    }

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          if (showPromotionPrice)
            TextSpan(
              text: '${StringUtil.getDefaultCurrencyFormat(item.basketItem?.getNormalPrice() ?? item.salesCartItem.unitPrice)}',
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
          TextSpan(
            text: ' ',
          ),
          if (!(item.basketItem?.isFreeItem ?? false))
            TextSpan(
              text: 'บาท',
              style: Theme.of(context).textTheme.small,
            ),
        ],
      ),
    );
  }
}
