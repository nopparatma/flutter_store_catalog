part of 'order.dart';

class PaymentPanel extends StatefulWidget {
  final SalesCartDto salesCartDto;
  final OrderBloc orderBloc;
  final CalculatePromotionBloc calProBloc;
  final CreateSalesBloc createSalesBloc;
  final HirePurchaseBloc hirePurchaseBloc;
  final bool isPortrait;

  PaymentPanel({
    this.salesCartDto,
    this.orderBloc,
    this.calProBloc,
    this.createSalesBloc,
    this.hirePurchaseBloc,
    this.isPortrait = false,
  });

  @override
  PaymentPanelState createState() => PaymentPanelState();
}

class PaymentPanelState extends State<PaymentPanel> with TickerProviderStateMixin {
  List<MstBank> hirePurcBankList;

  MstBank _selectedHirePurcBank;

  TabController _payTypeTabController;
  TabController _payNowByTabController;
  TabController _payCashierByTabController;

  num _unpaidAmt = 0;

  SalesCartDto _salesCartDto;
  CalculatePromotionCARs calcRs;
  CalculatePromotionCARs selectTenderCalcRs;
  CalculatePromotionCARs hirePurchaseCalcRs;

  bool get isPayNowTab => _payTypeTabController.index == 0 && widget.orderBloc.state.isValidateCanPayNow(_salesCartDto.salesCart.customer);

  bool get isPayCashierTab => _payTypeTabController.index == 1 || !widget.orderBloc.state.isValidateCanPayNow(_salesCartDto.salesCart.customer);

  bool get isHirePurchaseTab => _payCashierByTabController.index == 1;

  @override
  void initState() {
    _salesCartDto = BlocProvider.of<SalesCartBloc>(context).state.salesCartDto;

    _payTypeTabController = TabController(length: widget.orderBloc.state.isValidateCanPayNow(_salesCartDto.salesCart.customer) ? 2 : 1, vsync: this);
    _payNowByTabController = TabController(length: 2, vsync: this);
    _payCashierByTabController = TabController(length: _salesCartDto.hirePurchaseList.isNotNE ? 2 : 1, vsync: this);

    if (_salesCartDto.hirePurchaseList.isNotNE) {
      hirePurcBankList = _salesCartDto.hirePurchaseList.map((e) => e.mstBank).toList();
      hirePurcBankList.sort((a, b) => a.bankName.compareTo(b.bankName));
    }

    _unpaidAmt = _salesCartDto.unpaid;

    if (widget.calProBloc.state is CalculatedState) {
      calcRs = (widget.calProBloc.state as CalculatedState).calcRs;
    }

    super.initState();
  }

  @override
  dispose() {
    _payTypeTabController.dispose();
    _payNowByTabController.dispose();
    _payCashierByTabController.dispose();
    super.dispose();
  }

  void onSelectedTender(SuggestTender suggestTender) {
    setState(() {
      _salesCartDto.selectedTender = suggestTender;
    });
    widget.calProBloc.add(SelectCalculatePromotionEvent(
      appId: isPayNowTab ? CalPromotionCAAppId.SCAT_ONLINE : CalPromotionCAAppId.SCAT_POS,
      totalAmount: MathUtil.add(_salesCartDto.totalPrice, _salesCartDto.totalDeliveryFee),
      suggestTender: suggestTender,
    ));
  }

  void onSelectedDiscountCard(MstMbrCardGroupDet discountCard) {
    widget.calProBloc.add(StartCalculatePromotionEvent(
      isPayNowTab ? CalPromotionCAAppId.SCAT_ONLINE : CalPromotionCAAppId.SCAT_POS,
      discountCard: discountCard,
    ));
  }

  void onClearAllHirePurchase() {
    setState(() {
      _selectedHirePurcBank = null;
      _salesCartDto.selectPromotionMap = null;
      _salesCartDto.populateSalesItemForPay = null;
    });
  }

  Future<void> onSelectedHirePurchaseBank(MstBank bank) async {
    HirePurchaseDto hirePurchaseDto = _salesCartDto.hirePurchaseList.firstWhere((e) => e.mstBank == bank);
    CalculatePromotionCARs result = await DialogUtil.showCustomDialog(
      context,
      child: _PopupHirePurchase(_salesCartDto, bank, hirePurchaseDto, widget.hirePurchaseBloc, calcRs),
    );

    if (result.isNotNE) {
      setState(() {
        hirePurchaseCalcRs = null;
        _selectedHirePurcBank = null;
        if (_salesCartDto.selectPromotionMap.isNotNE) {
          hirePurchaseCalcRs = result;
          _selectedHirePurcBank = bank;
        }
      });
    }
  }

  void onResetAfterPaymentComplete() {
    BlocProvider.of<BasketBloc>(context).add(ResetBasketEvent());
    BlocProvider.of<SalesCartBloc>(context).add(SalesCartResetEvent());
    BlocProvider.of<AppTimerBloc>(context).add(AppTimerReset());
    Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CalculatePromotionBloc, CalculatePromotionState>(
          bloc: widget.calProBloc,
          condition: (prevState, currentState) {
            return true;
          },
          listener: (context, state) async {
            if (state is SelectedTenderState) {
              selectTenderCalcRs = state.calcRs;
            } else if (state is CalculatedState) {
              if (_salesCartDto.hirePurchaseList.isNotNE) {
                hirePurcBankList = _salesCartDto.hirePurchaseList.map((e) => e.mstBank).toList();
                hirePurcBankList.sort((a, b) => a.bankName.compareTo(b.bankName));
              }

              calcRs = state.calcRs;
              _payCashierByTabController = TabController(length: _salesCartDto.hirePurchaseList.isNotNE ? 2 : 1, vsync: this);
            } else if (state is ErrorCalculatePromotionState) {
              setState(() {
                _salesCartDto.selectedTender = null;
              });
            } else if (state is ErrorFreeGoodsNotHaveStockState) {
              bool isFreeGoods = await DialogUtil.showConfirmDialog(context, isShowCloseButton: false, title: 'common.dialog_title_warning'.tr(), message: 'text.free_goods_tender_not_have_stock'.tr(), textOk: 'text.get_free_goods'.tr(), textCancel: 'text.no_free_goods'.tr());

              if (isFreeGoods ?? false) {
                _salesCartDto.exceptLackFreeGoods = null;
                _payTypeTabController.index = 1;
                widget.calProBloc.add(StartCalculatePromotionEvent(CalPromotionCAAppId.SCAT_POS));
              } else {
                widget.calProBloc.add(SelectCalculatePromotionEvent(
                  appId: CalPromotionCAAppId.SCAT_ONLINE,
                  totalAmount: MathUtil.add(_salesCartDto.totalPrice, _salesCartDto.totalDeliveryFee),
                  suggestTender: _salesCartDto.selectedTender,
                ));
              }
            }
          },
        ),
        BlocListener<CreateSalesBloc, CreateSalesState>(
          bloc: widget.createSalesBloc,
          condition: (prevState, currentState) {
            if (prevState is LoadingCreateSalesState) {
              DialogUtil.hideLoadingDialog(context);
            }

            return true;
          },
          listener: (context, state) async {
            if (state is ErrorCreateSalesState) {
              await DialogUtil.showErrorDialog(context, state.error);
            } else if (state is LoadingCreateSalesState) {
              DialogUtil.showLoadingDialog(context);
            } else if (state is SuccessCreateCollectSalesState) {
              await DialogUtil.showCustomDialog(
                context,
                child: _PopupPayAtCashier(widget.salesCartDto),
              );
              onResetAfterPaymentComplete();
            }
          },
        ),
      ],
      child: widget.isPortrait ? _buildPaymentPortrait(context) : _buildPaymentLandscape(context),
    );
  }

  Widget _buildPaymentLandscape(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: _buildPaymentContent(context),
      ),
    );
  }

  Widget _buildPaymentPortrait(BuildContext context) {
    return Column(
      children: _buildPaymentContent(context),
    );
  }

  List<Widget> _buildPaymentContent(BuildContext context) {
    return [
      Row(
        children: [
          Container(
            width: 350,
            child: TabBar(
              controller: _payTypeTabController,
              indicatorColor: Colors.transparent,
              labelColor: colorBlue7,
              unselectedLabelColor: colorGrey2,
              labelPadding: EdgeInsets.all(0),
              tabs: [
                if (widget.orderBloc.state.isValidateCanPayNow(_salesCartDto.salesCart.customer))
                  Tab(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            NovaLineIcon.credit_card,
                            size: 35,
                          ),
                          Icon(
                            NovaLineIcon.qr_code,
                            size: 25,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'text.pay_now'.tr(),
                            style: Theme.of(context).textTheme.normal.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                Tab(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          NovaLineIcon.register_machine,
                          size: 25,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'text.pay_at_cashier'.tr(),
                          style: Theme.of(context).textTheme.normal.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
              onTap: (value) {
                _selectedHirePurcBank = null;
                widget.calProBloc.add(StartCalculatePromotionEvent(value == 0 && widget.orderBloc.state.isValidateCanPayNow(_salesCartDto.salesCart.customer) ? CalPromotionCAAppId.SCAT_ONLINE : CalPromotionCAAppId.SCAT_POS));
              },
            ),
          ),
        ],
      ),
      SizedBox(height: 20),
      if (isPayNowTab) _buildPayNowTab(context),
      if (isPayCashierTab) _buildPayCashierTab(context),
    ];
  }

  Widget _buildPayNowTab(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomToggleTab(
              tabController: _payNowByTabController,
              width: 600,
              names: ['text.pay_by_credit'.tr(), 'text.pay_by_qr'.tr()],
              selection: (value) {
                setState(() {
                  _salesCartDto.selectedTender = null;
                });
              },
              selectedTextStyle: Theme.of(context).textTheme.small.copyWith(
                    color: colorBlue7,
                    fontWeight: FontWeight.bold,
                  ),
              unSelectedTextStyle: Theme.of(context).textTheme.small.copyWith(
                    color: colorGrey2,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        SizedBox(height: 20),
        if (_payNowByTabController.index == 0) _buildPayCreditCardTab(context),
        if (_payNowByTabController.index == 1) _buildPayQRTab(context),
        SizedBox(height: 20),
        Row(
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
                onPressed: _salesCartDto.selectedTender.isNull
                    ? null
                    : () async {
                        if (_payNowByTabController.index == 0) {
                          bool backToHome = await DialogUtil.showCustomDialog(
                            context,
                            backgroundColor: Colors.white,
                            child: _PopupPayNowByCredit(widget.createSalesBloc, _salesCartDto, selectTenderCalcRs),
                          );

                          if ((backToHome ?? false) || widget.createSalesBloc.state is SuccessSmsCreateSalesState) {
                            onResetAfterPaymentComplete();
                          }
                        } else {
                          widget.createSalesBloc.add(ResetEvent());
                          bool backToHome = await DialogUtil.showCustomDialog(
                            context,
                            backgroundColor: Colors.white,
                            onTapClose: () async {
                              if(widget.createSalesBloc.state is SuccessQRCreateSalesState){
                                bool result = await DialogUtil.showConfirmDialog(context, title: 'text.confirm_cancel_payment'.tr(), message: 'text.confirm_cancel_payment_message'.tr(namedArgs: {"doubleQuote": "\u0022"}));
                                if(!(result ?? false)){
                                  return;
                                }
                              }

                              Navigator.pop(context);
                            },
                            child: _PopupPayNowByQR(widget.createSalesBloc, BlocProvider.of<InquiryTransactionBloc>(context), _salesCartDto, selectTenderCalcRs),
                          );

                          if (backToHome == null && widget.createSalesBloc.state is! SuccessQRPaymentState) {
                            BlocProvider.of<InquiryTransactionBloc>(context).add(CancelInquiryTransactionEvent());
                          }
                          if ((backToHome ?? false) || widget.createSalesBloc.state is SuccessQRPaymentState) {
                            onResetAfterPaymentComplete();
                          }
                        }
                      },
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
          ],
        ),
      ],
    );
  }

  Widget _buildPayCreditCardTab(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'text.select_credit_card_bank'.tr(),
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.normal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        TenderList(
          tenderList: _salesCartDto.creditTenderList,
          totalAmount: _unpaidAmt,
          isBigFirst: true,
          value: _salesCartDto.selectedTender,
          onSelected: (val) {
            if (_salesCartDto.selectedTender != val) {
              onSelectedTender(val);
            }
          },
        ),
        if (_salesCartDto.otherTenderList.isNotNE) _buildOtherCredit(context),
        if (isPayNowTab) SizedBox(height: 20),
        if (isPayNowTab)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0),
            child: HomeProCare(),
          ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildOtherCredit(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Text(
              'text.select_other_credit'.tr(),
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.normal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        TenderList(
          tenderList: _salesCartDto.otherTenderList,
          totalAmount: _unpaidAmt,
          value: _salesCartDto.selectedTender,
          onSelected: (val) {
            onSelectedTender(val);
          },
        ),
      ],
    );
  }

  Widget _buildPayQRTab(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'text.select_credit_card_bank'.tr(),
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.normal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        TenderList(
          tenderList: _salesCartDto.qrTenderList,
          totalAmount: _unpaidAmt,
          isBigFirst: true,
          value: _salesCartDto.selectedTender,
          onSelected: (val) {
            if (_salesCartDto.selectedTender != val) {
              onSelectedTender(val);
            }
          },
        ),
      ],
    );
  }

  Widget _buildPayCashierTab(BuildContext context) {
    MstMbrCardGroupDet selectedDiscountCard = _salesCartDto.selectedDiscountCard;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'text.pay_at_cashier_remark_first'.tr(),
          style: Theme.of(context).textTheme.normal.copyWith(
                color: colorRed1,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          'text.pay_at_cashier_remark_second'.tr(namedArgs: {"doubleQuote": "\u0022"}),
          style: Theme.of(context).textTheme.normal.copyWith(
                color: colorRed1,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            CustomCheckbox(
              value: selectedDiscountCard != null,
              onChanged: (value) async {
                if (!value) return onSelectedDiscountCard(null);
                var discountCard = await DialogUtil.showCustomDialog(context, child: _PopupDiscountCard(selectedCard: selectedDiscountCard));
                if (discountCard == null)
                  return setState(() {
                    value = false;
                  });
                onSelectedDiscountCard(discountCard);
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'text.discount_card'.tr(),
                          style: Theme.of(context).textTheme.normal.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (selectedDiscountCard != null)
                          SizedBox(
                            width: 10.0,
                          ),
                        if (selectedDiscountCard != null)
                          InkWell(
                            onTap: () async {
                              var discountCard = await DialogUtil.showCustomDialog(context, child: _PopupDiscountCard(selectedCard: selectedDiscountCard));
                              if (discountCard == null) return;
                              onSelectedDiscountCard(discountCard);
                            },
                            child: Text(
                              'text.change'.tr(),
                              style: Theme.of(context).textTheme.small.copyWith(color: colorBlue7),
                            ),
                          ),
                      ],
                    ),
                    if (selectedDiscountCard != null)
                      Text(
                        '${selectedDiscountCard.mbrCardGrpDetName} - ${selectedDiscountCard.mbrCardTypeBo.name}',
                        style: Theme.of(context).textTheme.small,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            CustomToggleTab(
              tabController: _payCashierByTabController,
              width: _salesCartDto.hirePurchaseList.isNotNE ? 600 : 300,
              names: _salesCartDto.hirePurchaseList.isNotNE ? ['text.pay_by_credit'.tr(), 'text.hire_purchase'.tr()] : ['text.pay_by_credit'.tr()],
              selection: (value) {
                setState(() {
                  _salesCartDto.selectedTender = null;
                });
              },
              selectedTextStyle: Theme.of(context).textTheme.small.copyWith(
                    color: colorBlue7,
                    fontWeight: FontWeight.bold,
                  ),
              unSelectedTextStyle: Theme.of(context).textTheme.small.copyWith(
                    color: colorGrey2,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        SizedBox(height: 20),
        if (_payCashierByTabController.index == 0) _buildPayCreditCardTab(context),
        if (_payCashierByTabController.index == 1) _buildHirePurchaseTab(context),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  primary: colorBlue7,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => widget.createSalesBloc.add(
                  CreateCollectSalesEvent(
                    isHirePurchaseTab && _salesCartDto.selectPromotionMap.isNotNE
                        ? hirePurchaseCalcRs
                        : _salesCartDto.selectedTender.isNotNull
                            ? selectTenderCalcRs
                            : calcRs,
                    isHirePurchaseTab,
                  ),
                ),
                child: Text(
                  'text.pay_at_cashier'.tr(),
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
      ],
    );
  }

  Widget _buildHirePurchaseTab(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'text.select_credit_card_bank'.tr(),
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.normal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        HirePurchaseBankList(
          value: _selectedHirePurcBank,
          onSelected: (val) async {
            onSelectedHirePurchaseBank(val);
          },
          bankList: hirePurcBankList,
        ),
        SizedBox(height: 20),
        if (_salesCartDto.selectPromotionMap.isNotNE)
          Row(
            children: [
              Text(
                'text.hire_purchase'.tr(),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.normal.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(width: 10),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    'text.clear_all'.tr(),
                    style: Theme.of(context).textTheme.smaller.copyWith(
                          color: colorBlue7,
                          decoration: TextDecoration.underline,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  onClearAllHirePurchase();
                },
              ),
            ],
          ),
        if (_salesCartDto.selectPromotionMap.isNotNE) SizedBox(height: 10),
        if (_salesCartDto.selectPromotionMap.isNotNE) _buildSelectedHirePurchase(context),
      ],
    );
  }

  Widget _buildSelectedHirePurchase(BuildContext context) {
    List<HirePurchasePromotion> promotionList = _salesCartDto.selectPromotionMap.values.toSet().toList();

    return Column(
      children: promotionList.map((e) {
        List<String> artcIdList = _salesCartDto.selectPromotionMap.keys.where((key) => _salesCartDto.selectPromotionMap[key] == e).toList();

        if (e.group.hierarchyType == HirePurchaseLevel.ART) {
          return Column(
            children: artcIdList.map((artc) => _buildSelectedHirePurchasePromotion(context, e, [artc])).toList(),
          );
        }

        return _buildSelectedHirePurchasePromotion(context, e, artcIdList);
      }).toList(),
    );
  }

  Widget _buildSelectedHirePurchasePromotion(BuildContext context, HirePurchasePromotion promotion, List<String> artcIdList) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: [
            Text(
              '${'text.product'.tr()}:',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.small.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: artcIdList.map((val) {
                  SalesItem salesItem = _salesCartDto.populateSalesItem.firstWhere((e) => e.articleId == val);
                  return Text(
                    salesItem.articleDesc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.small.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            PromotionTile(
              isSelected: true,
              onSelected: null,
              promotion: promotion,
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class _PopupDiscountCard extends StatefulWidget {
  final MstMbrCardGroupDet selectedCard;

  _PopupDiscountCard({this.selectedCard});

  @override
  _PopupDiscountCardState createState() => _PopupDiscountCardState();
}

class _PopupDiscountCardState extends State<_PopupDiscountCard> {
  MstMbrCardGroupDet selectedCard;
  List<MemoryImage> imageList;
  List<MstMbrCardGroupDet> discountCardList;

  @override
  void initState() {
    super.initState();
    selectedCard = widget.selectedCard;

    GetMstMbrCardGroupRs mstDiscountCard = BlocProvider.of<ApplicationBloc>(context).state.getMstDiscountCardGroup;
    discountCardList = <MstMbrCardGroupDet>[];
    mstDiscountCard.mstMbrCardGroups.forEach((element) {
      element.mstMbrCardGroupDets.forEach((card) {
        card.mstMbrCardGroupBo = element;
      });
      discountCardList.addAll(element.mstMbrCardGroupDets);
    });

    imageList = discountCardList.map((e) {
      return MemoryImage(Base64Decoder().convert(e.image.split(',')[1]));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.maybeOf(context).size.width > MediaQuery.maybeOf(context).size.height;
    return Container(
      width: 800,
      height: MediaQuery.of(context).size.height * (isLandscape ? 0.8 : 0.5),
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'text.discount_card'.tr(),
              style: Theme.of(context).textTheme.xlarger.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Expanded(child: _buildDiscountCardList(discountCardList)),
          SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10),
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
                Navigator.pop(context, selectedCard);
              },
              child: Text(
                selectedCard == null ? 'common.dialog_button_close'.tr() : 'text.select'.tr(),
                style: Theme.of(context).textTheme.normal.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     style: ButtonStyle(
          //       backgroundColor: MaterialStateProperty.all<Color>(
          //         Colors.indigoAccent,
          //       ),
          //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10.0),
          //       )),
          //       padding: MaterialStateProperty.all<EdgeInsets>(
          //         EdgeInsets.symmetric(vertical: 15.0),
          //       ),
          //     ),
          //     onPressed: () {
          //       Navigator.pop(context, selectedCard);
          //     },
          //     child: Text(
          //       selectedCard == null ? 'common.dialog_button_close'.tr() : 'text.select'.tr(),
          //       style: Theme.of(context).textTheme.normal.copyWith(
          //             color: Colors.white,
          //             fontWeight: FontWeight.normal,
          //           ),
          //       textAlign: TextAlign.right,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildDiscountCardList(List<MstMbrCardGroupDet> discountCardList) {
    if (discountCardList.isNullOrEmpty) return SizedBox.shrink();
    return SingleChildScrollView(
      child: LayoutBuilder(builder: (context, constraints) {
        return StaggeredGridView.extentBuilder(
          key: ValueKey<double>(constraints.maxWidth),
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          maxCrossAxisExtent: 300,
          // crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: discountCardList.length,
          itemBuilder: (context, index) => _buildCard(discountCardList[index], imageList[index]),
          staggeredTileBuilder: (index) => StaggeredTile.fit(1),
        );
      }),
    );
  }

  Widget _buildCard(MstMbrCardGroupDet discountCard, MemoryImage cardImage) {
    BorderRadius imageRadius = BorderRadius.all(Radius.circular(10.0));
    return Container(
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: imageRadius,
              child: Image(
                image: cardImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: discountCard == selectedCard ? Colors.blueAccent.withOpacity(0.4) : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: imageRadius,
                side: BorderSide(
                  color: discountCard == selectedCard ? Colors.blueAccent : Colors.transparent,
                ),
              ),
              child: InkWell(
                borderRadius: imageRadius,
                onTap: () {
                  selectedCard = discountCard;
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopupPayNowByCredit extends StatefulWidget {
  final CreateSalesBloc createSalesBloc;
  final SalesCartDto salesCartDto;
  final CalculatePromotionCARs calcRs;

  _PopupPayNowByCredit(this.createSalesBloc, this.salesCartDto, this.calcRs);

  @override
  _PopupPayNowByCreditState createState() => _PopupPayNowByCreditState();
}

class _PopupPayNowByCreditState extends State<_PopupPayNowByCredit> {
  double popupWidth;
  double popupHeight;

  final _formKey = GlobalKey<FormState>();
  Customer _memberCustomer;

  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  GlobalKey<_BottomScreenPanelState> bottomScreenPanelKey = GlobalKey();
  ScrollController scrollController;

  @override
  void initState() {
    List<CustomerPartners> billToList = widget.salesCartDto.salesCart.customer.customerPartners.where((element) {
      return CustomerPartnerType.BILL_TO == element.partnerFunctionTypeId || CustomerPartnerType.BILL_TO == element.partnerCustomer.partnerFunctionTypeId || CustomerPartnerType.SOLD_TO == element.partnerFunctionTypeId;
    }).toList();

    widget.salesCartDto.billToCustomer = billToList.isNotNE ? billToList.last.partnerCustomer : null;
    _phoneNoController.text = widget.salesCartDto.billToCustomer?.phoneNumber1 ?? '';
    _emailController.text = widget.salesCartDto.billToCustomer?.email ?? '';

    if (!widget.salesCartDto.salesCart.customer.cardNumber.isNullEmptyOrWhitespace) {
      _memberCustomer = widget.salesCartDto.salesCart.customer;
    }

    scrollController = ScrollController();

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.maybeOf(context).size.width < VERTICAL_WIDTH || MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width;
    if (isPortrait) {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.75;
      popupHeight = MediaQuery.maybeOf(context).size.height * 0.5;
    } else {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.5;
      popupHeight = MediaQuery.maybeOf(context).size.height * 0.8;
    }

    return BlocBuilder<CreateSalesBloc, CreateSalesState>(
      bloc: widget.createSalesBloc,
      builder: (context, state) {
        if (state is SuccessSmsCreateSalesState) {
          return _buildCreateSuccess(context);
        }

        return _buildInputFormPanel(context);
      },
    );
  }

  Widget _buildInputFormPanel(BuildContext context) {
    return Container(
      width: popupWidth,
      height: popupHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: popupWidth * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Material(
                    child: Ink(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorDark,
                      ),
                      child: Container(
                        width: 25,
                        height: 25,
                        child: Center(
                          child: Text(
                            '4',
                            style: Theme.of(context).textTheme.normal.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'text.payment'.tr(),
                        style: Theme.of(context).textTheme.larger.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  children: [
                    SizedBox(height: 10.0),
                    HomeProCare(),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: Image.asset('assets/images/${context.locale.toString()}/credit.png'),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              'text.telephone'.tr(),
                              style: Theme.of(context).textTheme.small.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorDark,
                                  ),
                            ),
                            VirtualKeyboardWrapper(
                              textController: _phoneNoController,
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
                                      return 'common.msg.please_enter_input'.tr(args: ['text.telephone'.tr()]);
                                    } else if (value != null && value.length < 10) {
                                      return 'text.please_specify_phone_ten_digits'.tr();
                                    }
                                    return null;
                                  },
                                  style: Theme.of(context).textTheme.small.copyWith(),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    hintText: 'text.bill_to.phone.placeholder'.tr(),
                                  ),
                                  keyboardType: TextInputType.number,
                                );
                              },
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                Text(
                                  'text.bill_to.info'.tr(),
                                  style: Theme.of(context).textTheme.small.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorDark,
                                      ),
                                ),
                                SizedBox(width: 5.0),
                                InkWell(
                                  onTap: () async {
                                    final Customer customer = await DialogUtil.showCustomDialog(
                                      context,
                                      backgroundColor: Colors.white,
                                      isScrollView: false,
                                      child: PopupSearchBillToPanel(
                                        customer: widget.salesCartDto.salesCart.customer,
                                        billToOld: widget.salesCartDto.billToCustomer,
                                      ),
                                    );

                                    if (customer != null) {
                                      setState(() {
                                        widget.salesCartDto.billToCustomer = customer;
                                        _emailController.text = customer.email ?? '';
                                        _phoneNoController.text = customer.phoneNumber1 ?? '';
                                      });
                                    }
                                  },
                                  child: Text(
                                    'text.change'.tr(),
                                    style: Theme.of(context).textTheme.small.copyWith(
                                          color: colorBlue7,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              decoration: BoxDecoration(
                                color: colorGreyBlue,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: colorGreyBlueShadow,
                                    blurRadius: 3.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                                      child: Container(
                                        child: Icon(
                                          NovaSolidIcon.real_estate_information,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.salesCartDto.getBillToFullNameWithTitle(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.small.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            BlocProvider.of<ApplicationBloc>(context).state.getCensorIdCard(widget.salesCartDto.billToCustomer.taxId.isNullEmptyOrWhitespace ? CustomerTaxId.DEFAULT_TAX_ID : widget.salesCartDto.billToCustomer.taxId),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.smaller,
                                          ),
                                          Scrollbar(
                                            isAlwaysShown: false,
                                            child: Text(
                                              widget.salesCartDto.getBillToAddress(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.smaller,
                                            ),
                                          ),
                                          Text(
                                            BlocProvider.of<ApplicationBloc>(context).state.getCensorPhoneNo(widget.salesCartDto.billToCustomer.phoneNumber1),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.smaller,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'text.bill_to.email'.tr(),
                              style: Theme.of(context).textTheme.small.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorDark,
                                  ),
                            ),
                            SizedBox(height: 5.0),
                            VirtualKeyboardWrapper(
                              textController: _emailController,
                              maxLength: 50,
                              keyboardType: VirtualKeyboardType.Email,
                              builder: (textEditingController, focusNode, inputFormatters) {
                                return Focus(
                                  onFocusChange: (value) {
                                    bottomScreenPanelKey.currentState.setBottomVisible(value);
                                  },
                                  child: TextFormField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    inputFormatters: inputFormatters,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'common.msg.please_enter_input'.tr(args: ['text.bill_to.email'.tr()]);
                                      }

                                      if (value.isNotNE && !StringUtil.isValidEmail(value)) {
                                        return 'text.validate_input_format'.tr(args: ['text.email'.tr()]);
                                      }
                                      return null;
                                    },
                                    style: Theme.of(context).textTheme.small.copyWith(),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      hintText: 'text.bill_to.email.placeholder'.tr(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ]),
                        ),
                        Expanded(
                          child: _memberCustomer.isNull
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'text.home_card_member.collect_point'.tr(),
                                        style: Theme.of(context).textTheme.small.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colorDark,
                                            ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: colorGreyBlue,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: colorGreyBlueShadow,
                                              blurRadius: 3.0,
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                child: Container(
                                                  width: 70,
                                                  child: Image.asset('assets/images/home_card.png'),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          _memberCustomer.cardNumber,
                                                          style: Theme.of(context).textTheme.small.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Container(
                                                          height: 22,
                                                          child: FadeInImage.assetNetwork(
                                                            placeholder: '',
                                                            placeholderErrorBuilder: (context, error, stackTrace) => Container(),
                                                            image: ImageUtil.getFullURL(getIt<CustomerInformationService>().getTierImage(widget.salesCartDto.salesCart.customer.sapId)),
                                                            imageErrorBuilder: (context, error, stackTrace) => Container(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      widget.salesCartDto.getCustFullName(),
                                                      style: Theme.of(context).textTheme.smaller,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      BlocProvider.of<ApplicationBloc>(context).state.getCensorPhoneNo(_memberCustomer.phoneNumber1),
                                                      style: Theme.of(context).textTheme.smaller,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    BottomScreenPanel(
                      key: bottomScreenPanelKey,
                      scrollController: scrollController,
                    ),
                  ],
                ),
              ),
              Container(
                width: popupWidth * 0.4,
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
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState.validate()) {
                      widget.createSalesBloc.add(SmsCreateSalesEvent(QRPaymentType.PAYMENT_GATEWAY, widget.salesCartDto.billToCustomer.sapId, _phoneNoController.text, _emailController.text, widget.calcRs));
                    }
                  },
                  child: Text(
                    'text.send'.tr(),
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
        ),
      ),
    );
  }

  Widget _buildCreateSuccess(BuildContext context) {
    return Container(
      width: popupWidth,
      height: popupHeight,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: popupWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                NovaLineIcon.transfer_mobile_satellite,
                color: colorGreen2,
              ),
              SizedBox(height: 10.0),
              Text(
                'text.send_sms.complete'.tr(),
                style: Theme.of(context).textTheme.large.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 10.0),
              Text(
                'text.send_sms.please_check_mobile'.tr(),
                style: Theme.of(context).textTheme.small.copyWith(
                      color: colorGrey1,
                      fontWeight: FontWeight.normal,
                    ),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Image.asset('assets/images/${context.locale.toString()}/credit.png'),
                  )
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: 200,
                child: Image.asset('assets/images/thankyou.png'),
              ),
              SizedBox(height: 50),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'text.back_to_home'.tr(),
                  style: Theme.of(context).textTheme.small.copyWith(
                        color: colorBlue7,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopupPayNowByQR extends StatefulWidget {
  final CreateSalesBloc createSalesBloc;
  final InquiryTransactionBloc inquiryTransactionBloc;
  final SalesCartDto salesCartDto;
  final CalculatePromotionCARs calcRs;

  _PopupPayNowByQR(this.createSalesBloc, this.inquiryTransactionBloc, this.salesCartDto, this.calcRs);

  @override
  _PopupPayNowByQRState createState() => _PopupPayNowByQRState();
}

class _PopupPayNowByQRState extends State<_PopupPayNowByQR> {
  double popupWidth;
  double popupHeight;

  final _formKey = GlobalKey<FormState>();
  Customer _memberCustomer;

  TextEditingController _emailController = TextEditingController();
  CountdownTimerController _countdownController;
  GlobalKey<_BottomScreenPanelState> bottomScreenPanelKey = GlobalKey();
  ScrollController scrollController;

  String imagePath;

  @override
  void initState() {
    List<CustomerPartners> billToList = widget.salesCartDto.salesCart.customer.customerPartners.where((element) {
      return CustomerPartnerType.BILL_TO == element.partnerFunctionTypeId || CustomerPartnerType.BILL_TO == element.partnerCustomer.partnerFunctionTypeId || CustomerPartnerType.SOLD_TO == element.partnerFunctionTypeId;
    }).toList();

    widget.salesCartDto.billToCustomer = billToList.isNotNE ? billToList.last.partnerCustomer : null;
    _emailController.text = widget.salesCartDto.billToCustomer?.email ?? '';

    if (!widget.salesCartDto.salesCart.customer.cardNumber.isNullEmptyOrWhitespace) {
      _memberCustomer = widget.salesCartDto.salesCart.customer;
    }

    scrollController = ScrollController();

    super.initState();
  }

  @override
  dispose() {
    _countdownController?.dispose();
    super.dispose();
  }

  Future<void> onQRTimeOut() async {
    _countdownController.disposeTimer();
    widget.inquiryTransactionBloc.add(CancelInquiryTransactionEvent());
    bool isBackToNewPayment = await DialogUtil.showConfirmDialog(
      context,
      title: 'text.out_of_time'.tr(),
      message: 'text.qr_time_out.detail'.tr(),
      textCancel: 'text.back_to_home'.tr(),
      textOk: 'text.select_new_payment'.tr(),
      isShowCloseButton: false,
    );

    Navigator.of(context).pop(!isBackToNewPayment);
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.maybeOf(context).size.width < VERTICAL_WIDTH || MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width;
    if (isPortrait) {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.75;
      popupHeight = MediaQuery.maybeOf(context).size.height * 0.5;
    } else {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.5;
      popupHeight = MediaQuery.maybeOf(context).size.height * 0.8;
    }

    imagePath = 'assets/images/${context.locale.toString()}/qrcode_${widget.salesCartDto.selectedTender.tenderId}.png';

    return BlocListener(
      bloc: widget.createSalesBloc,
      condition: (previous, current) => current is SuccessQRCreateSalesState,
      listener: (context, state) {
        _countdownController = CountdownTimerController(
          endTime: DateTime.now().add(Duration(minutes: AppConfig.instance.qrPaymentTimeoutMin)).millisecondsSinceEpoch,
          onEnd: onQRTimeOut,
        );
      },
      child: BlocBuilder<CreateSalesBloc, CreateSalesState>(
        bloc: widget.createSalesBloc,
        condition: (previous, current) => current is! TimeoutQRCreateSalesState,
        builder: (context, state) {
          if (state is SuccessQRCreateSalesState && _countdownController != null) {
            return _buildShowQRCode(context, state.qrImage);
          } else if (state is SuccessQRPaymentState) {
            if (_countdownController?.isRunning ?? false) _countdownController?.disposeTimer();
            return _buildPaymentSuccess(context, state.posId, state.ticketNo);
          }
          return _buildInputFormPanel(context);
        },
      ),
    );
  }

  Widget _buildInputFormPanel(BuildContext context) {
    return Container(
      width: popupWidth,
      height: popupHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: popupWidth * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Material(
                    child: Ink(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorDark,
                      ),
                      child: Container(
                        width: 25,
                        height: 25,
                        child: Center(
                          child: Text(
                            '4',
                            style: Theme.of(context).textTheme.normal.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'text.payment'.tr(),
                        style: Theme.of(context).textTheme.larger.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  children: [
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: Image.asset(imagePath),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'text.bill_to.info'.tr(),
                                    style: Theme.of(context).textTheme.small.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorDark,
                                        ),
                                  ),
                                  SizedBox(width: 5.0),
                                  InkWell(
                                    onTap: () async {
                                      final Customer customer = await DialogUtil.showCustomDialog(
                                        context,
                                        backgroundColor: Colors.white,
                                        isScrollView: false,
                                        child: PopupSearchBillToPanel(
                                          customer: widget.salesCartDto.salesCart.customer,
                                          billToOld: widget.salesCartDto.billToCustomer,
                                        ),
                                      );

                                      if (customer != null) {
                                        setState(() {
                                          widget.salesCartDto.billToCustomer = customer;
                                          _emailController.text = customer.email ?? '';
                                        });
                                      }
                                    },
                                    child: Text(
                                      'text.change'.tr(),
                                      style: Theme.of(context).textTheme.small.copyWith(
                                            color: colorBlue7,
                                            decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                decoration: BoxDecoration(
                                  color: colorGreyBlue,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: colorGreyBlueShadow,
                                      blurRadius: 3.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                                        child: Container(
                                          child: Icon(
                                            NovaSolidIcon.real_estate_information,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.salesCartDto.getBillToFullNameWithTitle(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.small.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              BlocProvider.of<ApplicationBloc>(context).state.getCensorIdCard(widget.salesCartDto.billToCustomer.taxId.isNullEmptyOrWhitespace ? CustomerTaxId.DEFAULT_TAX_ID : widget.salesCartDto.billToCustomer.taxId),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.smaller,
                                            ),
                                            Scrollbar(
                                              isAlwaysShown: false,
                                              child: Text(
                                                widget.salesCartDto.getBillToAddress(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.smaller,
                                              ),
                                            ),
                                            Text(
                                              BlocProvider.of<ApplicationBloc>(context).state.getCensorPhoneNo(widget.salesCartDto.billToCustomer.phoneNumber1),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.smaller,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'text.bill_to.email'.tr(),
                                style: Theme.of(context).textTheme.small.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorDark,
                                    ),
                              ),
                              SizedBox(height: 5.0),
                              VirtualKeyboardWrapper(
                                textController: _emailController,
                                maxLength: 50,
                                keyboardType: VirtualKeyboardType.Email,
                                builder: (textEditingController, focusNode, inputFormatters) {
                                  return Focus(
                                    onFocusChange: (value) {
                                      bottomScreenPanelKey.currentState.setBottomVisible(value);
                                    },
                                    child: TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      inputFormatters: inputFormatters,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'common.msg.please_enter_input'.tr(args: ['text.bill_to.email'.tr()]);
                                        }

                                        if (value.isNotNE && !StringUtil.isValidEmail(value)) {
                                          return 'text.validate_input_format'.tr(args: ['text.email'.tr()]);
                                        }
                                        return null;
                                      },
                                      style: Theme.of(context).textTheme.small.copyWith(),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(8),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        hintText: 'text.bill_to.email.placeholder'.tr(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _memberCustomer.isNull
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'text.home_card_member.collect_point'.tr(),
                                        style: Theme.of(context).textTheme.small.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colorDark,
                                            ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: colorGreyBlue,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: colorGreyBlueShadow,
                                              blurRadius: 3.0,
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                child: Container(
                                                  width: 70,
                                                  child: Image.asset('assets/images/home_card.png'),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          _memberCustomer.cardNumber,
                                                          style: Theme.of(context).textTheme.small.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Container(
                                                          height: 22,
                                                          child: FadeInImage.assetNetwork(
                                                            placeholder: '',
                                                            placeholderErrorBuilder: (context, error, stackTrace) => Container(),
                                                            image: ImageUtil.getFullURL(getIt<CustomerInformationService>().getTierImage(widget.salesCartDto.salesCart.customer.sapId)),
                                                            imageErrorBuilder: (context, error, stackTrace) => Container(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      widget.salesCartDto.getCustFullName(),
                                                      style: Theme.of(context).textTheme.smaller,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      BlocProvider.of<ApplicationBloc>(context).state.getCensorPhoneNo(_memberCustomer.phoneNumber1),
                                                      style: Theme.of(context).textTheme.smaller,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    BottomScreenPanel(
                      key: bottomScreenPanelKey,
                      scrollController: scrollController,
                    ),
                  ],
                ),
              ),
              Container(
                width: popupWidth * 0.4,
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
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState.validate()) {
                      String qrPaymentType = QRPaymentType.PROMPT_PAY;

                      if (TenderIdOfCardNetwork.VISA == widget.salesCartDto.selectedTender.tenderId) {
                        qrPaymentType = QRPaymentType.CREDIT;
                      } else if (TenderIdOfCardNetwork.HPCD == widget.salesCartDto.selectedTender.tenderId) {
                        qrPaymentType = QRPaymentType.HOMEPRO_VISA;
                      }

                      widget.createSalesBloc.add(QRCreateSalesEvent(qrPaymentType, widget.salesCartDto.billToCustomer.sapId, _emailController.text, widget.calcRs));
                    }
                  },
                  child: Text(
                    'text.send'.tr(),
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
        ),
      ),
    );
  }

  Widget _buildShowQRCode(BuildContext context, String qrCodeImage) {
    return Container(
      width: popupWidth,
      height: popupHeight,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: popupWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 30.0,
                height: 30.0,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          NovaSolidIcon.mobile_phone_1,
                          size: 30,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          color: Colors.white,
                          child: Icon(
                            NovaSolidIcon.qr_code,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'text.please_payment'.tr(),
                style: Theme.of(context).textTheme.large.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'text.scan_this_for_payment'.tr(),
                style: Theme.of(context).textTheme.small.copyWith(
                      color: colorGrey1,
                      fontWeight: FontWeight.normal,
                    ),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: FadeInImage.assetNetwork(
                      height: 20,
                      placeholder: 'assets/images/non_article_image.png',
                      image: ImageUtil.getFullURL(widget.salesCartDto.selectedTender.imgUrl),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Container();
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 250.0,
                child: Image.memory(Base64Decoder().convert(qrCodeImage)),
              ),
              SizedBox(height: 10),
              CountdownTimer(
                controller: _countdownController,
                widgetBuilder: (_, CurrentRemainingTime time) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, color: colorGrey1),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${(time?.min ?? 0).toString().padLeft(2, '0')}:${(time?.sec ?? 0).toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.small.copyWith(color: colorGrey1),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(imagePath),
                  )
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentSuccess(BuildContext context, String posId, String ticketNo) {
    return Container(
      width: popupWidth,
      height: popupHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: popupWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              NovaLineIcon.check_circle_2,
              color: colorGreen2,
              size: 30,
            ),
            SizedBox(height: 10.0),
            Text(
              'text.payment_complete'.tr(),
              style: Theme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 10.0),
            Text(
              'text.homepro_will_send_bill'.tr(),
              style: Theme.of(context).textTheme.small.copyWith(
                    color: colorGrey1,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            Text(
              'text.pos_ticket.colon'.tr(args: [posId, ticketNo]),
              style: Theme.of(context).textTheme.small.copyWith(
                    color: colorGrey1,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 200,
              child: Image.asset('assets/images/thankyou.png'),
            ),
            Expanded(
              child: Container(),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'text.back_to_home'.tr(),
                style: Theme.of(context).textTheme.small.copyWith(
                      color: colorBlue7,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _PopupPayAtCashier extends StatefulWidget {
  final SalesCartDto salesCartDto;

  _PopupPayAtCashier(this.salesCartDto);

  @override
  _PopupPayAtCashierState createState() => _PopupPayAtCashierState();
}

class _PopupPayAtCashierState extends State<_PopupPayAtCashier> {
  double popupWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.maybeOf(context).size.width < VERTICAL_WIDTH || MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width;
    if (isPortrait) {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.75;
    } else {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.5;
    }

    return Container(
      width: popupWidth,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: popupWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  NovaLineIcon.register_machine,
                  color: colorBlue7,
                  size: 25,
                ),
                Text(
                  'text.pay_at_cashier'.tr(),
                  style: Theme.of(context).textTheme.large.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorBlue7,
                      ),
                ),
              ],
            ),
            Text(
              'text.pay_at_cashier.complete'.tr(),
              style: Theme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 10.0),
            Text(
              'text.pay_at_cashier.remark.first'.tr(),
              style: Theme.of(context).textTheme.small.copyWith(
                    fontWeight: FontWeight.normal,
                    color: colorGrey1,
                  ),
            ),
            Text(
              'text.pay_at_cashier.remark.second'.tr(),
              style: Theme.of(context).textTheme.small.copyWith(
                    fontWeight: FontWeight.normal,
                    color: colorGrey1,
                  ),
            ),
            SizedBox(height: 40.0),
            Container(
              decoration: BoxDecoration(
                color: colorGreyBlue,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colorGreyBlueShadow,
                    blurRadius: 3.0,
                  ),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: Text(
                  '${'text.telephone'.tr()} : ${BlocProvider.of<ApplicationBloc>(context).state.getCensorPhoneNo(widget.salesCartDto.getCustTelNo())}',
                  style: Theme.of(context).textTheme.xxlarger.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            SizedBox(height: 150),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'text.back_to_home'.tr(),
                style: Theme.of(context).textTheme.small.copyWith(
                      color: colorBlue7,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _PopupHirePurchase extends StatefulWidget {
  final SalesCartDto salesCartDto;
  final MstBank selectedHirePurcBank;
  final HirePurchaseDto hirePurchaseDto;
  final HirePurchaseBloc hirePurchaseBloc;
  final CalculatePromotionCARs calcRs;

  _PopupHirePurchase(this.salesCartDto, this.selectedHirePurcBank, this.hirePurchaseDto, this.hirePurchaseBloc, this.calcRs);

  @override
  _PopupHirePurchaseState createState() => _PopupHirePurchaseState();
}

class _PopupHirePurchaseState extends State<_PopupHirePurchase> {
  double popupWidth;
  double popupHeight;

  List<HirePurchasePromotion> promotionList;
  Map<String, List<HirePurchasePromotion>> groupPromotionMap = Map<String, List<HirePurchasePromotion>>();

  List<String> hirePurchaseLevelText = ['text.hire_purchase_level.art'.tr(), 'text.hire_purchase_level.mch'.tr(), 'text.hire_purchase_level.ait'.tr()];
  List<String> hirePurchaseLevel = [HirePurchaseLevel.ART, HirePurchaseLevel.MCH, HirePurchaseLevel.AIT];

  Map<String, HirePurchasePromotion> tmpSelectPromotionMap;

  String currentLevel = HirePurchaseLevel.ART;
  bool canNext = true;
  bool canBack = false;

  @override
  void initState() {
    super.initState();
    tmpSelectPromotionMap = Map<String, HirePurchasePromotion>();
    widget.hirePurchaseBloc.add(SelectBankHirePurchaseEvent(hirePurchaseDto: widget.hirePurchaseDto));
  }

  @override
  dispose() {
    super.dispose();
  }

  void onSelectPromotion(HirePurchasePromotion promotion) {
    setState(() {
      List<String> artcIds = promotion.lstArticle.map((e) => e.articleId).toSet().toList();
      artcIds.forEach((element) {
        if (tmpSelectPromotionMap.containsKey(element) && tmpSelectPromotionMap[element].promotion.promotionId == promotion?.promotion?.promotionId) {
          tmpSelectPromotionMap.remove(element);
        } else {
          tmpSelectPromotionMap.update(element, (value) => promotion, ifAbsent: () => promotion);
        }
      });
    });
    widget.hirePurchaseBloc.add(
      SelectPromotionEvent(
        hirePurchaseState: currentLevel,
        selectBank: widget.selectedHirePurcBank,
        selectPromotion: tmpSelectPromotionMap,
        groupPromotionMap: groupPromotionMap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.maybeOf(context).size.width < VERTICAL_WIDTH || MediaQuery.maybeOf(context).size.height > MediaQuery.maybeOf(context).size.width;
    if (isPortrait) {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.75;
      popupHeight = MediaQuery.maybeOf(context).size.height * 0.5;
    } else {
      popupWidth = MediaQuery.maybeOf(context).size.width * 0.5;
      popupHeight = MediaQuery.maybeOf(context).size.height * 0.8;
    }

    return BlocConsumer<HirePurchaseBloc, HirePurchaseState>(
      bloc: widget.hirePurchaseBloc,
      listener: (context, state) async {
        if (state is ShowPromotionHirePurchaseState) {
          groupPromotionMap = state.groupPromotionMap;
          currentLevel = state.hirePurchaseState;
          canNext = state.canNext ?? canNext;
          canBack = state.canBack ?? canBack;
        } else if (state is ConfirmedPromotionState) {
          if (state.notHavePromotionList.isNotNE) {
            await DialogUtil.showCustomDialog(context, child: buildDialogExceptHirePurchasePromotion(context), isShowCloseButton: false);
          }
          Navigator.of(context).pop(state.calcRs ?? CalculatePromotionCARs());
        }
      },
      builder: (context, state) {
        if (state is InitialHirePurchaseState) {
          return Container(
            width: popupWidth,
            height: popupHeight,
          );
        }

        return Container(
          width: popupWidth,
          height: popupHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: popupWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('text.hire_purchase'.tr(),
                    style: Theme.of(context).textTheme.larger.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                SizedBox(height: 20),
                Row(
                  children: hirePurchaseLevelText.map((e) {
                    num index = hirePurchaseLevelText.indexOf(e);
                    bool isCurrentState = index == hirePurchaseLevel.indexOf(currentLevel);
                    return Row(
                      children: [
                        Material(
                          child: Ink(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrentState ? colorBlue7 : colorGrey2,
                            ),
                            child: Container(
                              width: 20,
                              height: 20,
                              child: Center(
                                child: Text(
                                  (index + 1).toString(),
                                  style: Theme.of(context).textTheme.small.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            e,
                            style: Theme.of(context).textTheme.small.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isCurrentState ? colorBlue7 : colorGrey2,
                                ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      itemCount: groupPromotionMap.length,
                      itemBuilder: (BuildContext context, int index) {
                        String key = groupPromotionMap.keys.toList()[index];
                        List<String> artcIdList = key.split(',');

                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.ideographic,
                              children: [
                                Text(
                                  '${'text.product'.tr()}:',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.normal.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: artcIdList.map((val) {
                                      HirePurchasePromotion promotion = groupPromotionMap[key][0];
                                      SalesItem salesItem = promotion.lstArticle.firstWhere((e) => e.articleId == val);
                                      return Text(
                                        salesItem.articleDesc,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.normal.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            LayoutBuilder(builder: (context, constraints) {
                              return StaggeredGridView.extent(
                                key: ValueKey<double>(constraints.maxWidth),
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                maxCrossAxisExtent: 320,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                children: groupPromotionMap[key].map((e) {
                                  String artcId = e.lstArticle.first.articleId;
                                  HirePurchasePromotion promotion = tmpSelectPromotionMap[artcId];

                                  return PromotionTile(
                                    promotion: e,
                                    onSelected: onSelectPromotion,
                                    isSelected: e.promotion.promotionId == promotion?.promotion?.promotionId,
                                  );
                                }).toList(),
                                staggeredTiles: groupPromotionMap[key].map((e) {
                                  return StaggeredTile.fit(1);
                                }).toList(),
                              );
                            }),
                            SizedBox(height: 20),
                          ],
                        );
                      }),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          primary: colorAccent,
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: canBack
                            ? () => widget.hirePurchaseBloc.add(BackPageHirePurchaseEvent(
                                  selectBank: widget.selectedHirePurcBank,
                                  currentState: currentLevel,
                                  hirePurchaseDto: widget.hirePurchaseDto,
                                  selectPromotion: tmpSelectPromotionMap,
                                ))
                            : null,
                        child: Text(
                          'text.back'.tr(),
                          style: Theme.of(context).textTheme.normal.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          primary: colorBlue7,
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (canNext) {
                            widget.hirePurchaseBloc.add(NextPageHirePurchaseEvent(
                              selectBank: widget.selectedHirePurcBank,
                              currentState: currentLevel,
                              hirePurchaseDto: widget.hirePurchaseDto,
                              selectPromotion: tmpSelectPromotionMap,
                            ));
                          } else {
                            widget.hirePurchaseBloc.add(
                              ConfirmPromotionEvent(
                                hirePurchaseState: currentLevel,
                                selectBank: widget.selectedHirePurcBank,
                                selectPromotion: tmpSelectPromotionMap,
                                calculatePromotionCARs: widget.calcRs,
                              ),
                            );
                          }
                        },
                        child: Text(
                          canNext ? 'text.next'.tr() : 'common.button_confirm'.tr(),
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
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDialogExceptHirePurchasePromotion(BuildContext context) {
    return Container(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'common.dialog_title_warning'.tr(),
              style: Theme.of(context).textTheme.larger.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorDark,
                  ),
            ),
            SizedBox(height: 10),
            Text(
              'text.hire_purchase.not_have_promotion'.tr(),
              style: Theme.of(context).textTheme.normal.copyWith(
                    fontWeight: FontWeight.normal,
                    color: colorDark,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 80.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: colorBlue7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: Text('common.dialog_button_ok'.tr(), style: Theme.of(context).textTheme.normal.copyWith(color: Colors.white)),
                      onPressed: () {
                        Navigator.of(context).pop();
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
}

class PromotionTile extends StatelessWidget {
  final HirePurchasePromotion promotion;
  final bool isSelected;
  final Function onSelected;

  const PromotionTile({this.promotion, this.isSelected, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      child: Card(
        color: isSelected ? colorBlue5 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(
            color: isSelected ? colorBlue7 : Colors.white,
          ),
        ),
        elevation: 5,
        child: InkWell(
          onTap: onSelected != null ? () => onSelected(promotion) : null,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        promotion.promotion.month != 0 && promotion.promotion.month.isNotNull ? '${promotion.promotion.month.toString()}' : '-',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.xlarger.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'text.month'.tr(),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.small.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promotion.promotion.percentDiscount != null ? '${'text.discount'.tr()}: ${promotion.promotion.percentDiscount.toString()}%' : '',
                        style: Theme.of(context).textTheme.small.copyWith(),
                      ),
                      Text(
                        '${'text.card_type'.tr()}: ${promotion.group.creditCardType}',
                        style: Theme.of(context).textTheme.small.copyWith(),
                      ),
                      Text(
                        '${'text.end_date'.tr()}: ${DateTimeUtil.toDateTimeString(promotion.periodEnd, 'dd/MM/yyyy')}',
                        style: Theme.of(context).textTheme.small.copyWith(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
