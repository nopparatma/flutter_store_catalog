import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomLengthLimitingTextInputFormatter extends TextInputFormatter {
  CustomLengthLimitingTextInputFormatter(this.maxLength) : assert(maxLength == null || maxLength == -1 || maxLength > 0);

  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (maxLength != null && maxLength > 0 && newValue.text.length > maxLength) {
      TextEditingValue editValue = truncate(newValue, maxLength);
      return editValue;
    }
    return newValue;
  }

  static TextEditingValue truncate(TextEditingValue value, int maxLength) {
    final String truncated = value.text.substring(0, maxLength);

    return TextEditingValue(
      text: truncated,
      selection: value.selection.copyWith(
        baseOffset: min(value.selection.start, truncated.length),
        extentOffset: min(value.selection.end, truncated.length),
      ),
      composing: !value.composing.isCollapsed && truncated.length > value.composing.start
          ? TextRange(
              start: value.composing.start,
              end: min(value.composing.end, truncated.length),
            )
          : TextRange.empty,
    );
  }
}

class CustomRangeTextInputFormatter extends TextInputFormatter {

  final num min;
  final num max;

  CustomRangeTextInputFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '' || num.parse(newValue.text) < min) return TextEditingValue().copyWith(text: '$min');
    return num.parse(newValue.text) > max ? TextEditingValue().copyWith(text: '$max') : newValue;
  }
}
