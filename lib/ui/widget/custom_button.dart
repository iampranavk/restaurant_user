import 'package:flutter/material.dart';
import 'package:restaurant_user/ui/widget/custom_card.dart';
import 'package:restaurant_user/ui/widget/custom_progress_indicator.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function() onTap;
  final IconData? icon;
  final Color? buttonColor, iconColor, labelColor, hoverBorderColor;
  final double elevation;
  final bool isLoading;
  const CustomButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.icon,
    this.buttonColor,
    this.iconColor,
    this.labelColor,
    this.elevation = 0,
    this.isLoading = false,
    this.hoverBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: buttonColor ?? Colors.green[50],
      hoverBorderColor: hoverBorderColor ?? Colors.green,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: icon != null ? 10 : 20,
            top: 12.5,
            bottom: 12.5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: icon != null
                ? MainAxisAlignment.center
                : MainAxisAlignment.center,
            children: isLoading
                ? [
                    const CustomProgressIndicator(),
                  ]
                : [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: labelColor,
                          ),
                    ),
                    SizedBox(
                      width: icon != null ? 5 : 0,
                    ),
                    icon != null
                        ? Icon(
                            icon!,
                            color: iconColor,
                            size: 20,
                          )
                        : const SizedBox()
                  ],
          ),
        ),
      ),
    );
  }
}
