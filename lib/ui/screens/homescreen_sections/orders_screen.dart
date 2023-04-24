import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_user/blocs/manage_orders/manage_orders_bloc.dart';
import 'package:restaurant_user/ui/widget/custom_button.dart';
import 'package:restaurant_user/ui/widget/custom_card.dart';
import 'package:restaurant_user/ui/widget/custom_progress_indicator.dart';
import 'package:restaurant_user/ui/widget/label_with_text.dart';

import '../../widget/custom_alert_dialog.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final ManageOrdersBloc manageOrdersBloc = ManageOrdersBloc();
  String groupValue = 'pending';

  void getOrders() {
    manageOrdersBloc.add(GetAllManageOrdersEvent(status: groupValue));
  }

  @override
  void initState() {
    super.initState();

    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ManageOrdersBloc>.value(
      value: manageOrdersBloc,
      child: BlocConsumer<ManageOrdersBloc, ManageOrdersState>(
        listener: (context, state) {
          if (state is ManageOrdersFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                message: state.message,
                primaryButtonLabel: 'Try Again',
                primaryOnPressed: () {
                  getOrders();
                },
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                'My Orders',
                style: GoogleFonts.oswald(
                  textStyle:
                      Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: Colors.green[800],
                            fontWeight: FontWeight.w600,
                          ),
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.green[900]!,
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CupertinoSlidingSegmentedControl<String>(
                      backgroundColor: Colors.white60,
                      thumbColor: Colors.green[200]!,
                      groupValue: groupValue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      children: {
                        'pending': Text(
                          'Ordered',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        'complete': Text(
                          'Completed',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      },
                      onValueChanged: (value) {
                        groupValue = value!;
                        setState(() {});
                        getOrders();
                      },
                    ),
                    const Divider(
                      color: Colors.black54,
                      height: 20,
                    ),
                    Expanded(
                      child: state is ManageOrdersSuccessState
                          ? state.orders.isNotEmpty
                              ? ListView.separated(
                                  itemBuilder: (context, index) => OrderItem(
                                    orderDetails: state.orders[index],
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10),
                                  itemCount: state.orders.length,
                                )
                              : const Center(
                                  child: Text("No Orders"),
                                )
                          : const Center(
                              child: CustomProgressIndicator(),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final dynamic orderDetails;
  const OrderItem({
    super.key,
    required this.orderDetails,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#12',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  'Ordered',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const Divider(
              height: 30,
              color: Colors.black54,
            ),
            Wrap(
              runSpacing: 10,
              children: List<Widget>.generate(
                orderDetails['items'].length,
                (index) => ProductListItem(
                  orderItemDetails: orderDetails['items'][index],
                ),
              ),
            ),
            const Divider(
              height: 30,
              color: Colors.black54,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                ),
                Text(
                  '₹${orderDetails['total'].toString()}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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

class ProductListItem extends StatelessWidget {
  final dynamic orderItemDetails;
  const ProductListItem({
    super.key,
    required this.orderItemDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            orderItemDetails['food_item']['image_url'],
            width: 50,
            height: 50,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderItemDetails['food_item']['name'],
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              orderItemDetails['quantity'].toString(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '₹${orderItemDetails['price'].toString()}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
