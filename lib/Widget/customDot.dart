import 'package:flutter/material.dart';

class StatusDot extends StatelessWidget {
  Color? color;
  double? size = 10;
  StatusDot({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}
