import 'package:flutter/material.dart';
import 'package:restaurant_user/util/truncate_string.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoriesItem extends StatelessWidget {
  final dynamic categoryDetails;
  final Function(int) onSelect;
  final bool isSelected;
  const CategoriesItem({
    super.key,
    this.categoryDetails,
    required this.onSelect,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Material(
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                onSelect(categoryDetails['id']);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: categoryDetails['image_url'],
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  if (isSelected)
                    Container(
                      height: 80,
                      width: 80,
                      color: Colors.green.withOpacity(.5),
                    ),
                  if (isSelected)
                    const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          truncateString(categoryDetails['category'] ?? '', 14),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: isSelected ? Colors.green : Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
