import 'package:flutter/material.dart';

class LabelWithText extends StatelessWidget {
  final String label, text;
  final CrossAxisAlignment crossAxisAlignment;
  const LabelWithText({
    super.key,
    required this.label,
    required this.text,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.black38,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
