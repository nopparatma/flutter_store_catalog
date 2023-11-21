import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 4.0,
            offset: Offset(0, 2.5),
          ),
        ],
      ),
      child: Divider(
        color: Colors.black38,
        height: 1,
        thickness: 1,
      ),
    );
  }
}
