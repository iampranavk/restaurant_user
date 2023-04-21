import 'package:flutter/material.dart';
import 'package:restaurant_user/ui/widget/custom_action_button.dart';
import 'package:restaurant_user/ui/widget/custom_card.dart';
import 'package:restaurant_user/ui/widget/custom_icon_button.dart';
import 'package:restaurant_user/ui/widget/label_with_text.dart';

class DoctorCard extends StatefulWidget {
  const DoctorCard({super.key});

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: LabelWithText(
                    label: 'Name',
                    text: 'Peter',
                  ),
                ),
                Expanded(
                  child: LabelWithText(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    label: 'Phone',
                    text: '9876152342',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: LabelWithText(
                    label: 'Address',
                    text: 'address line 1, address line 2',
                  ),
                ),
                Expanded(
                  child: LabelWithText(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    label: 'Place',
                    text: 'Kannur',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: LabelWithText(
                    label: 'District',
                    text: 'Kannur',
                  ),
                ),
                Expanded(
                  child: LabelWithText(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    label: 'State',
                    text: 'Kerala',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const LabelWithText(
              label: 'Pin',
              text: '670301',
            ),
            const Divider(
              color: Colors.black54,
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomIconButton(
                    iconData: Icons.call_outlined,
                    color: Colors.green[600]!,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: CustomActionButton(
                    iconData: Icons.map_outlined,
                    onPressed: () {},
                    label: 'Location',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
