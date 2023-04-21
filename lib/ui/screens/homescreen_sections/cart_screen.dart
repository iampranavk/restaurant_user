import 'package:flutter/material.dart';
import 'package:restaurant_user/ui/widget/counter.dart';

import '../../widget/custom_button.dart';
import '../../widget/custom_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 50,
                top: 20,
              ),
              shrinkWrap: true,
              itemCount: 5,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return const ShopItem();
              },
            ),
          ),
          Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
              side: const BorderSide(color: Colors.green, width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Price",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          "₹440",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      buttonColor: Colors.green[800],
                      labelColor: Colors.white,
                      label: 'Place Order',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShopItem extends StatelessWidget {
  const ShopItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=481&q=80',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meal',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 2.5),
                    Text(
                      'Pizza',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2.5),
                    Text(
                      'Fast Food',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 2.5),
                    Counter(
                      size: 24,
                      onChange: (count) {},
                    ),
                  ],
                ),
              ),
              Text(
                '₹2000',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
