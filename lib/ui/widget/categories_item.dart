import 'package:flutter/material.dart';

class CategoriesItem extends StatelessWidget {
  final String? label;
  final Function() onTap;
  const CategoriesItem({
    super.key,
    this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=481&q=80',
              height: 80,
              width: 80,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            label ?? '',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
