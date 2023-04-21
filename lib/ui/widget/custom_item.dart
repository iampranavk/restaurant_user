import 'package:flutter/material.dart';

class CustomItem extends StatefulWidget {
  final String image, title, subtitleOne, subtitleTwo;
  final Function() onTap;
  const CustomItem({
    super.key,
    required this.image,
    required this.title,
    required this.subtitleOne,
    required this.subtitleTwo,
    required this.onTap,
  });

  @override
  State<CustomItem> createState() => _CustomItemState();
}

class _CustomItemState extends State<CustomItem> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Material(
        color: Colors.white,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(widget.image),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.subtitleOne,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.subtitleTwo,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  isFavorite = !isFavorite;
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_outline,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
