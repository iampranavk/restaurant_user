import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_user/blocs/manage_cart/manage_cart_bloc.dart';
import 'package:restaurant_user/ui/widget/counter.dart';
import 'package:restaurant_user/ui/widget/custom_alert_dialog.dart';
import 'package:restaurant_user/ui/widget/custom_button.dart';
import 'package:restaurant_user/ui/widget/custom_progress_indicator.dart';

class FoodDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> foodDetails;
  const FoodDetailsScreen({Key? key, required this.foodDetails})
      : super(key: key);

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  int quantity = 1;
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
                      widget.foodDetails['name'],
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
                          '₹${widget.foodDetails['discounted_price'].toString()}',
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
                          '₹${widget.foodDetails['price'].toString()}',
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
                        const SizedBox(
                          width: 2.5,
                        ),
                        Text(
                          "${widget.foodDetails['time'].toString()} min",
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
                        const SizedBox(
                          width: 2.5,
                        ),
                        Text(
                          '${widget.foodDetails['calories']} kcal',
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
                          Icons.people,
                          color: Colors.green[700],
                          size: 25,
                        ),
                        const SizedBox(
                          width: 2.5,
                        ),
                        Text(
                          '${widget.foodDetails['serves_count'].toString()} serves',
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
                      widget.foodDetails['description'],
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Counter(
                          onChange: (qty) {
                            quantity = qty;
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: CustomButton(
                            buttonColor: Colors.green[800],
                            labelColor: Colors.white,
                            label: "Add to Cart",
                            onTap: () async {
                              ManageCartBloc().add(
                                AddManageCartEvent(
                                  itemId: widget.foodDetails['id'],
                                  quantity: quantity,
                                ),
                              );
                              await showDialog(
                                context: context,
                                builder: (context) => CustomAlertDialog(
                                  title: 'Item Added',
                                  message:
                                      'Item added to cart, open cart section and complete the order.',
                                  content: Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      size: 150,
                                      color: Colors.green[900],
                                    ),
                                  ),
                                  primaryButtonLabel: 'Ok',
                                ),
                              );
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
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
                imageUrl: widget.foodDetails['image_url'],
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
