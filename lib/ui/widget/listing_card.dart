import 'package:flutter/material.dart';
import 'package:restaurant_user/ui/widget/custom_card.dart';

import '../screens/food_details_screen.dart';

class ListingCard extends StatefulWidget {
  final Map<String, dynamic> foodDetails;
  const ListingCard({
    super.key,
    required this.foodDetails,
  });

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodDetailsScreen(
              foodDetails: widget.foodDetails,
            ),
          ),
        );
      },
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
                  widget.foodDetails['image_url'],
                  fit: BoxFit.cover,
                  height: 150,
                  width: 150,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.foodDetails['category']['category'],
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  widget.foodDetails['type']['type'],
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
            Text(
              widget.foodDetails['name'],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '₹${widget.foodDetails['discounted_price'].toString()}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.end,
                ),
                const SizedBox(width: 5),
                Text(
                  '₹${widget.foodDetails['price'].toString()}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.red[800],
                        decoration: TextDecoration.lineThrough,
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
