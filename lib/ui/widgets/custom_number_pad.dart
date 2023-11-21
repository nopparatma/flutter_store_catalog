import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/core/utilities/string_util.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';

class CustomNumberPad extends StatefulWidget{
  final String text;
  final IconData icon;
  final bool haveBorder;
  final Function onPressed;
  final Color backgroundColor;
  final TextStyle style;

  const CustomNumberPad({Key key, this.text, this.icon, this.haveBorder = true, this.onPressed, this.backgroundColor, this.style}) : super(key: key);

  _CustomNumberPad createState() => _CustomNumberPad();
}

class _CustomNumberPad extends State<CustomNumberPad>{

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: widget.backgroundColor == null ? colorPrimary : colorGrey3,
          elevation: 4,
          primary: widget.backgroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: Container(
          width: 65,
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.icon != null)
                Icon(
                  widget.icon,
                  size: 40,
                  color: colorDark,
                ),
              if (StringUtil.isNotEmpty(widget.text)) Text(widget.text, style: widget.style),
            ],
          ),
        ),
        onPressed: widget.onPressed,

      ),
    );
  }
  
}