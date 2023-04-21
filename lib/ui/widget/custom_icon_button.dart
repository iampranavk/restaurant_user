import 'package:flutter/material.dart';
import 'package:restaurant_user/ui/widget/custom_card.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final Color color, iconColor;
  final Function() onPressed;
  const CustomIconButton({
    super.key,
    required this.iconData,
    this.color = Colors.pink,
    required this.onPressed,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: color,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: 10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
