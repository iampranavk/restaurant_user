import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color? color;
  const CustomProgressIndicator({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: color ?? Colors.green,
        strokeWidth: 2,
        backgroundColor:
            color != null ? color!.withOpacity(0.1) : Colors.green[50],
      ),
    );
  }
}
