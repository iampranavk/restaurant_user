part of 'manage_orders_bloc.dart';

@immutable
abstract class ManageOrdersState {}

class ManageOrdersInitialState extends ManageOrdersState {}

class ManageOrdersSuccessState extends ManageOrdersState {
  final List<Map<String, dynamic>> orders;

  ManageOrdersSuccessState({required this.orders});
}

class ManageOrdersLoadingState extends ManageOrdersState {}

class ManageOrdersFailureState extends ManageOrdersState {
  final String message;

  ManageOrdersFailureState(
      {this.message =
          'Something went wrong, Please check your connection and try again!.'});
}
