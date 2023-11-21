import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/core/constant/constant.dart';
import 'package:flutter_store_catalog/core/models/view/queue_data.dart';
import 'package:flutter_store_catalog/core/utilities/date_time_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';

class CustomTableCalendar extends StatefulWidget {
  final String soMode;
  final Map<DateTime, QueueDateMap> queueDateMap;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime readyDateInStock;
  final DateTime selectedDate;
  final DateTime focusDate;
  final OnDaySelected onDaySelected;
  final String lang;
  final bool useSelectStyle;
  final bool isSameDay; 
  final EdgeInsets headerMagin;

  final double _rowHeight = 40;
  final String _headerFormat = 'MMMM yyyy';

  @override
  _CustomTableCalendarState createState() => _CustomTableCalendarState();

  CustomTableCalendar({
    this.soMode,
    this.queueDateMap,
    this.startDate,
    this.focusDate,
    this.endDate,
    this.readyDateInStock,
    this.selectedDate,
    this.onDaySelected,
    this.lang,
    this.useSelectStyle = true,
    this.isSameDay = false,
    this.headerMagin,
  });
}

class _CustomTableCalendarState extends State<CustomTableCalendar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, QueueDateMap> queueDateMap = widget.queueDateMap;
    return TableCalendar(
      rowHeight: widget._rowHeight,
      locale: widget.lang,
      firstDay: widget.startDate,
      lastDay: widget.endDate,
      focusedDay: widget.focusDate,
      calendarFormat: CalendarFormat.month,
      calendarStyle: new CalendarStyle(
        outsideDaysVisible: true,
        isTodayHighlighted: false,
      ),
      availableGestures: AvailableGestures.horizontalSwipe,
      headerStyle: HeaderStyle(
        headerMargin: widget.headerMagin ?? EdgeInsets.all(0),
        headerPadding: EdgeInsets.all(0.0),
        formatButtonVisible: false,
        titleCentered: true,
        titleTextFormatter: (date, locale) {
          DateFormat dateFormat = new DateFormat(widget._headerFormat, widget.lang);
          return '${dateFormat.format(date)}';
        },
        leftChevronIcon: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1.5)),
          child: Icon(Icons.chevron_left),
        ),
        rightChevronIcon: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1.5)),
          child: Icon(Icons.chevron_right),
        ),
      ),
      weekendDays: [DateTime.sunday],
      daysOfWeekHeight: 50,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: Theme.of(context).textTheme.normal.copyWith(
              fontWeight: FontWeight.bold,
              color: colorBlue2,
            ),
        weekendStyle: Theme.of(context).textTheme.normal.copyWith(
              fontWeight: FontWeight.bold,
              color: colorBlue2,
            ),
      ),
      startingDayOfWeek: StartingDayOfWeek.sunday,
      selectedDayPredicate: (day) {
        return isSameDay(widget.selectedDate, day);
      },
      onDayLongPressed: widget.onDaySelected,
      onDaySelected: widget.onDaySelected,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, events) {
          date = DateTimeUtil.toDate(date);

          bool isStockReadyCustomerReceive = (widget.soMode == SOMode.CUST_RECEIVE && widget.readyDateInStock.compareTo(date) <= 0);

          if(isStockReadyCustomerReceive || widget.queueDateMap.containsKey(date) && widget.queueDateMap[date].status == DateStatus.Available) {
            return buildAvailableBox(date);
          } else {
            return buildDefaultBox(date);
          }
        },
        selectedBuilder: (context, date, focusedDay) {
          if(focusedDay.month == date.month) {
            return buildSelectedDateBox(date);
          } else {
            return buildOutsideMonthBox(date);
          }
        },
        disabledBuilder: (context, date, focusedDay) {
          date = DateTimeUtil.toDate(date);

          if(focusedDay.month == date.month) {
            return buildUnavailableBox(date);
          } else {
            return buildOutsideMonthBox(date);
          }
        },
        outsideBuilder: (context, date, focusedDay) {
          return buildOutsideMonthBox(date);
        },
      ),
      enabledDayPredicate: (date) {
        date = DateTimeUtil.toDate(date);

        if(widget.isSameDay) return widget.selectedDate.compareTo(date) == 0;

        bool isAvailable = (widget.queueDateMap.containsKey(date) && widget.queueDateMap[date].status == DateStatus.Available);
        bool isAfterInquiry = (!widget.queueDateMap.containsKey(date) && widget.startDate.compareTo(date) <= 0);
        bool isStockReadyCustomerReceive = (widget.soMode == SOMode.CUST_RECEIVE && widget.readyDateInStock.compareTo(date) <= 0);

        return isAvailable || isAfterInquiry || isStockReadyCustomerReceive;
      },
    );
  }

  AnimatedContainer buildDefaultBox(DateTime date){
    return buildAnimatedContainer(date, null, null, colorBlue2);
  }

  AnimatedContainer buildAvailableBox(DateTime date){
    return buildAnimatedContainer(date, colorGreen3, null, colorBlue2);
  }

  AnimatedContainer buildUnavailableBox(DateTime date){
    return  buildAnimatedContainer(date, colorGrey3, null, colorBlue2);
  }

  AnimatedContainer buildOutsideMonthBox(DateTime date){
    return buildAnimatedContainer(date, colorGrey4, null, colorGrey3);
  }

  AnimatedContainer buildSelectedDateBox(DateTime date){
    return buildAnimatedContainer(date, colorBlue4, colorBlue7, colorBlue2);
  }

  AnimatedContainer buildAnimatedContainer(DateTime date, Color boxColor, Color borderColor, Color textColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: buildBoxDecoration(boxColor, borderColor),
      alignment: Alignment.center,
      child: Text(
        '${date.day}',
        style: buildDayTextStyle(textColor),
      ),
    );
  }

  BoxDecoration buildBoxDecoration(Color color, Color borderColor) {
    return BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colors.grey,
          width: 0.2,
        ),
        color: color);
  }

  TextStyle buildDayTextStyle(Color color) {
    return Theme.of(context).textTheme.large.copyWith(
          fontWeight: FontWeight.bold,
          color: color,
        );
  }
}
