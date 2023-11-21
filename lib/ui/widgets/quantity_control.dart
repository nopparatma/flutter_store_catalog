import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_store_catalog/core/utilities/math_util.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:flutter_store_catalog/ui/widgets/text_formatter.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard.dart';
import 'package:flutter_store_catalog/ui/widgets/virtual_keyboard_wrapper.dart';

import 'nova_line_icon_icons.dart';

class QuantityControl extends StatefulWidget {
  TextEditingController editController;
  Function callBackIncr;
  Function callBackDecr;
  Function callBackChange;
  num minValue;
  num maxValue;
  num incrValue;
  bool enable;
  bool isDecimal;
  FocusNode focusNode;

  QuantityControl({
    this.editController,
    this.callBackIncr,
    this.callBackDecr,
    this.callBackChange,
    this.minValue = 1,
    this.maxValue = 9999,
    this.incrValue = 1,
    this.enable = true,
    this.isDecimal = false,
    this.focusNode,
  });

  @override
  _QuantityControl createState() => _QuantityControl();
}

class _QuantityControl extends State<QuantityControl> {
  TextEditingController editController;
  FocusNode focusNode;

  static const String INTEGER_FORMAT = r'^\d+';
  static const String DECIMAL_FORMAT = r'^\d+\.?\d{0,2}';

  num height = 40;

  @override
  void initState() {
    super.initState();
    editController = widget.editController ?? TextEditingController();
    if (!StringUtil.isNullOrEmpty(editController.text)) {
      editController.text = num.parse(editController.text).toStringAsFixed(widget.isDecimal ? 2 : 0);
    } else {
      editController.text = widget.minValue.toStringAsFixed(0);
    }

    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus && editController.text == '0') {
        if (widget.callBackChange != null) {
          widget.callBackChange(1);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode?.dispose();
  }

  onChangeValue(String value) {
    num qty;
    if (StringUtil.isNullOrEmpty(value)) {
      qty = widget.minValue;
    } else {
      qty = num.parse(value);
    }
    qty = qty > widget.maxValue ? widget.maxValue : qty;
    if (widget.callBackChange != null) {
      widget.callBackChange(qty);
    }
    if (!value.endsWith('.')) {
      setState(() {
        editController.text = qty.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    editController.selection = TextSelection.fromPosition(TextPosition(offset: editController.text.length));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 170,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey[400],
                blurRadius: 2,
                offset: Offset(0.0, 2.0),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                width: height,
                height: height,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: Material(
                  type: MaterialType.button,
                  color: widget.enable ? Colors.white : Colors.grey[400],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(5.0),
                    bottomLeft: const Radius.circular(5.0),
                  ),
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        NovaLineIcon.subtract_2,
                        color: widget.enable ? Colors.blue : Colors.grey,
                      ),
                    ),
                    onTap: !widget.enable
                        ? null
                        : () {
                            num txtVal = num.parse(editController.text);

                            if (txtVal <= widget.minValue) return;

                            num val = MathUtil.subtract(txtVal, widget.incrValue);

                            val = val < widget.minValue ? widget.minValue : val;
                            if (widget.callBackDecr != null) {
                              widget.callBackDecr(val);
                            }
                            setState(() {
                              editController.text = val.toString();
                            });
                          },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: widget.enable ? Colors.white : Colors.grey[400],
                  child: VirtualKeyboardWrapper(
                    textController: editController,
                    keyboardType: VirtualKeyboardType.Numeric,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(widget.isDecimal ? DECIMAL_FORMAT : INTEGER_FORMAT)),
                      CustomRangeTextInputFormatter(widget.minValue, widget.maxValue),
                    ],
                    maxLength: 50,
                    onKeyPress: (key) {
                      onChangeValue(editController.text);
                    },
                    focusNode: focusNode,
                    builder: (textEditingController, focusNode, inputFormatters) {
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        inputFormatters: inputFormatters,
                        enabled: widget.enable,
                        style: Theme.of(context).textTheme.larger.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                        // keyboardType: TextInputType.numberWithOptions(decimal: true),
                        // inputFormatters: [FilteringTextInputFormatter.allow(RegExp(widget.isDecimal ? DECIMAL_FORMAT : INTEGER_FORMAT))],
                        decoration: InputDecoration(
                          labelStyle: null,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          fillColor: widget.enable ? Colors.white : Colors.grey[400],
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                        ),
                        onChanged: (value) {
                          onChangeValue(value);
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: height,
                height: height,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: Material(
                  type: MaterialType.button,
                  color: widget.enable ? Colors.white : Colors.grey[400],
                  borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(5.0),
                    bottomRight: const Radius.circular(5.0),
                  ),
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        NovaLineIcon.add_2,
                        color: widget.enable ? Colors.blue : Colors.grey,
                      ),
                    ),
                    onTap: !widget.enable
                        ? null
                        : () {
                            num txtVal = num.parse(editController.text);

                            if (txtVal >= widget.maxValue) return;

                            num val = MathUtil.add(txtVal, widget.incrValue);

                            if (val == 0) return;

                            val = val > widget.maxValue ? widget.maxValue : val;
                            if (widget.callBackIncr != null) {
                              widget.callBackIncr(val);
                            }
                            setState(() {
                              editController.text = val.toString();
                            });
                          },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
