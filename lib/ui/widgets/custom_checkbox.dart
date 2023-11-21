import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/widgets/nova_line_icon_icons.dart';

class CustomCheckbox extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final double size;
  bool value;
  Widget customChild;
  bool isCheckIcon;

  CustomCheckbox({Key key, this.onChanged, this.size = 30, this.value = false, this.customChild, this.isCheckIcon = true}) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool get enabled => widget.onChanged != null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () => widget.onChanged(!widget.value)
          : null,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutExpo,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
            color: enabled
                ? widget.value
                    ? colorBlue7
                    : Colors.white
                : colorGrey3,
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            border: Border.all(
              color: enabled ? colorGrey3 : colorGrey1,
            )),
        child: widget.value
            ? Center(
                child: widget.customChild != null
                    ? widget.customChild
                    : widget.isCheckIcon
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : Icon(
                            NovaLineIcon.keyboard_key_empty,
                            color: Colors.white,
                          ),
              )
            : null,
      ),
    );
  }
}
