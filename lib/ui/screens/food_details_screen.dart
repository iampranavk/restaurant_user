import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_user/ui/widget/custom_button.dart';
import 'package:restaurant_user/ui/widget/custom_progress_indicator.dart';

class FoodDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> foodDetails;
  const FoodDetailsScreen({Key? key, required this.foodDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.green[200],
      body: Stack(children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: SizedBox(
              height: ((MediaQuery.of(context).size.height / 3) * 2) + 50,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    Text(
                      foodDetails['name'],
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          '₹${foodDetails['discounted_price'].toString()}',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          '₹${foodDetails['price'].toString()}',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.yellow[700]!,
                          size: 25,
                        ),
                        Text(
                          "${foodDetails['time'].toString()} min",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.bloodtype,
                          color: Colors.red[700],
                          size: 25,
                        ),
                        Text(
                          '${foodDetails['calories']} kcal',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      foodDetails['description'],
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      buttonColor: Colors.green[800],
                      labelColor: Colors.white,
                      label: "Add to Cart",
                      onTap: () {},
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 7.5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: CachedNetworkImage(
                imageUrl: foodDetails['image_url'],
                fit: BoxFit.cover,
                height: 250,
                width: 250,
                progressIndicatorBuilder: (context, url, progress) =>
                    const Center(
                  child: CustomProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
