import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color? color;
  const CustomProgressIndicator({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color ?? Colors.pink,
      backgroundColor:
          color != null ? color!.withOpacity(0.1) : Colors.pink[50],
    );
  }
}
