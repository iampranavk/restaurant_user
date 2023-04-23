part of 'manage_cart_bloc.dart';

@immutable
abstract class ManageCartEvent {}

class AddManageCartEvent extends ManageCartEvent {
  final int itemId, quantity;

  AddManageCartEvent({
    required this.itemId,
    required this.quantity,
  });
}

class DeleteManageCartEvent extends ManageCartEvent {
  final int cartItemId;

  DeleteManageCartEvent({required this.cartItemId});
}

class GetAllManageCartEvent extends ManageCartEvent {}
