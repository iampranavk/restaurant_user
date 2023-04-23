part of 'manage_cart_bloc.dart';

@immutable
abstract class ManageCartState {}

class ManageCartInitialState extends ManageCartState {}

class ManageCartSuccessState extends ManageCartState {
  final List<Map<String, dynamic>> cartItems;
  final int total;

  ManageCartSuccessState({
    required this.cartItems,
    required this.total,
  });
}

class ManageCartLoadingState extends ManageCartState {}

class ManageCartFailureState extends ManageCartState {
  final String message;

  ManageCartFailureState(
      {this.message =
          'Something went wrong, Please check your connection and try again!.'});
}
