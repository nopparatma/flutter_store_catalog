import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';

class CustomCloseDialogButton extends StatelessWidget {
  final bool isInkStyle;
  final Function onTap;
  final Color closeButtonColor;
  const CustomCloseDialogButton({Key key, this.onTap, this.isInkStyle = true, this.closeButtonColor = colorDark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isInkStyle ? _buildInkStyle() : _buildContainerStyle();
  }

  _buildInkStyle() {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: closeButtonColor, width: 1.5),
          borderRadius: BorderRadius.circular(4),
          shape: BoxShape.rectangle,
        ),
        child: _buildCloseButton(),
      ),
    );
  }

  _buildContainerStyle() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: closeButtonColor, width: 1.5),
        borderRadius: BorderRadius.circular(4),
        shape: BoxShape.rectangle,
      ),
      child: _buildCloseButton(),
    );
  }

  _buildCloseButton() {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Icon(
          Icons.close,
          size: 20,
          color: closeButtonColor,
        ),
      ),
      onTap: onTap,
    );
  }
}
