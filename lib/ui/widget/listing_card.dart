import 'package:flutter/material.dart';
import 'package:restaurant_user/ui/widget/custom_card.dart';

class ListingCard extends StatefulWidget {
  final bool isOnListing;
  final Function() onTap;
  const ListingCard({
    super.key,
    required this.onTap,
    this.isOnListing = false,
  });

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onPressed: widget.isOnListing ? null : widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=481&q=80',
                  fit: BoxFit.fill,
                  height: 150,
                  width: 150,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Pizza',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Meal',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Fast Food',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '₹20000',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.red[800],
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 2.5,
                ),
                Expanded(
                  child: Text(
                    '₹15000',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.green[900],
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.end,
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
