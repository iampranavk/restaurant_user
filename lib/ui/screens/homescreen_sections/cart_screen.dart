import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:restaurant_user/blocs/manage_cart/manage_cart_bloc.dart';
import 'package:restaurant_user/blocs/manage_orders/manage_orders_bloc.dart';
import 'package:restaurant_user/ui/widget/counter.dart';
import 'package:restaurant_user/ui/widget/custom_alert_dialog.dart';
import 'package:restaurant_user/ui/widget/custom_progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widget/custom_button.dart';
import '../../widget/custom_card.dart';
import '../../widget/table_selector.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ManageCartBloc manageCartBloc = ManageCartBloc();
  final ManageOrdersBloc manageOrdersBloc = ManageOrdersBloc();
  int selectedTableId = 0, total = 0;

  final Razorpay _razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await showDialog(
      context: context,
      builder: (context) => const CustomAlertDialog(
        title: 'Payment Success',
        message:
            'Thank you for the payment, you can see your orders in the orders sections',
        primaryButtonLabel: 'Ok',
      ),
    );

    manageOrdersBloc.add(CreateOrdersEvent(tableId: selectedTableId));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Logger().e(response.error);
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Payment Failed',
        message: response.message ?? 'Something went wrong, Please try again',
        primaryButtonLabel: 'Ok',
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  void makePayment() async {
    // String orderId = await createOrder(widget.testDetails['total_price']);

    var options = {
      'key': 'rzp_test_j07YpjyCexi5xr',
      'amount': total * 100,
      'name': 'Resto',
      // 'order_id': orderId,
      'description': 'Order',
      'prefill': {
        'contact': '9999999999',
        'email': Supabase.instance.client.auth.currentUser!.email,
      }
    };
    Logger().w(options);
    _razorpay.open(options);
  }

  @override
  void initState() {
    super.initState();
    manageCartBloc.add(GetAllManageCartEvent());
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<ManageCartBloc>.value(
        value: manageCartBloc,
        child: BlocProvider<ManageOrdersBloc>.value(
          value: manageOrdersBloc,
          child: BlocConsumer<ManageOrdersBloc, ManageOrdersState>(
            listener: (context, orderState) {
              if (orderState is ManageOrdersFailureState) {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    title: 'Failure',
                    message: orderState.message,
                    primaryButtonLabel: 'Try Again',
                    primaryOnPressed: () {},
                  ),
                );

                manageCartBloc.add(GetAllManageCartEvent());
              } else if (orderState is ManageOrdersSuccessState) {
                manageCartBloc.add(GetAllManageCartEvent());
              }
            },
            builder: (context, orderState) {
              return orderState is ManageOrdersLoadingState
                  ? const Center(child: CustomProgressIndicator())
                  : BlocConsumer<ManageCartBloc, ManageCartState>(
                      listener: (context, state) {
                        if (state is ManageCartFailureState) {
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              title: 'Failure',
                              message: state.message,
                              primaryButtonLabel: 'Try Again',
                              primaryOnPressed: () {
                                manageCartBloc.add(GetAllManageCartEvent());
                              },
                            ),
                          );
                        } else if (state is ManageCartSuccessState) {
                          total = state.total;
                        }
                      },
                      builder: (context, state) {
                        return state is ManageCartSuccessState
                            ? state.cartItems.isNotEmpty
                                ? Column(
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
                                          itemCount: state.cartItems.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ShopItem(
                                              cartItemDetails:
                                                  state.cartItems[index],
                                              manageCartBloc: manageCartBloc,
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                          top: 10,
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: Material(
                                          color: Colors.white,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 20,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Total Price",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        "₹${state.total.toString()}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: CustomButton(
                                                    buttonColor:
                                                        Colors.green[800],
                                                    labelColor: Colors.white,
                                                    label: 'Place Order',
                                                    onTap: () async {
                                                      await showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            CustomAlertDialog(
                                                          title: 'Select Table',
                                                          message:
                                                              'Select the table youre sitting in',
                                                          content: Column(
                                                            children: [
                                                              Icon(
                                                                Icons.table_bar,
                                                                size: 150,
                                                                color: Colors
                                                                    .green[900],
                                                              ),
                                                              const SizedBox(
                                                                  height: 20),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        TableSelector(
                                                                      label:
                                                                          'Table',
                                                                      onSelect:
                                                                          (id) {
                                                                        selectedTableId =
                                                                            id;
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );

                                                      if (selectedTableId !=
                                                          0) {
                                                        makePayment();
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Center(child: Text('No Items'))
                            : const Center(child: CustomProgressIndicator());
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}

class ShopItem extends StatelessWidget {
  final dynamic cartItemDetails;
  final ManageCartBloc manageCartBloc;
  const ShopItem({
    super.key,
    required this.cartItemDetails,
    required this.manageCartBloc,
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
                  cartItemDetails['food_item']['image_url'],
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
                      cartItemDetails['food_item']['name'],
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 2.5),
                    Text(
                      cartItemDetails['food_item']['category']['category'],
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2.5),
                    Text(
                      cartItemDetails['food_item']['type']['type'],
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 2.5),
                    Text(
                      cartItemDetails['quantity'].toString(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      manageCartBloc.add(
                        DeleteManageCartEvent(
                          cartItemId: cartItemDetails['id'],
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '₹${cartItemDetails['food_item']['discounted_price'].toString()}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
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
