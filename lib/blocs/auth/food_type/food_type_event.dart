part of 'food_type_bloc.dart';

@immutable
abstract class FoodTypeEvent {}

class AddFoodTypeEvent extends FoodTypeEvent {
  final String name;

  AddFoodTypeEvent({
    required this.name,
  });
}

class DeleteFoodTypeEvent extends FoodTypeEvent {
  final int id;

  DeleteFoodTypeEvent({
    required this.id,
  });
}

class GetAllFoodTypeEvent extends FoodTypeEvent {
  final String? query;

  GetAllFoodTypeEvent({
    this.query,
  });
}
