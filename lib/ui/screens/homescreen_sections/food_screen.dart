import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_user/ui/screens/food_details_screen.dart';
import 'package:restaurant_user/ui/widget/categories_item.dart';
import 'package:restaurant_user/ui/widget/custom_search.dart';
import 'package:restaurant_user/ui/widget/listing_card.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                'explore food',
                style: GoogleFonts.pacifico(
                  textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.green[900],
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomSearch(
              onSearch: (search) {},
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Categories',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (context, index) => CategoriesItem(
                  label: 'Meal',
                  onTap: () {},
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
            ),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              childAspectRatio: 1 / 1.5,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: List<Widget>.generate(
                10,
                (index) => ListingCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FoodDetailsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
