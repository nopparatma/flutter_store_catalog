
import 'package:flutter/material.dart';

class CustomVericalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            blurRadius: 3.0,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: VerticalDivider(
        color: Colors.grey[400],
        width: 1,
        thickness: 1,
      ),
    );
  }
}