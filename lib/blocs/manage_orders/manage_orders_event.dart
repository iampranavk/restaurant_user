part of 'manage_orders_bloc.dart';

@immutable
abstract class ManageOrdersEvent {}

class CreateOrdersEvent extends ManageOrdersEvent {
  final int tableId;

  CreateOrdersEvent({required this.tableId});
}

class HandleOrdersEvent extends ManageOrdersEvent {
  final int orderId;
  final String status;

  HandleOrdersEvent({
    required this.orderId,
    required this.status,
  });
}

class GetAllManageOrdersEvent extends ManageOrdersEvent {
  final String status;

  GetAllManageOrdersEvent({required this.status});
}
