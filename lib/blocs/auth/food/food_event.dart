part of 'food_bloc.dart';

@immutable
abstract class FoodEvent {}

class AddFoodEvent extends FoodEvent {
  final String name, description, calorie;
  final int foodCategoryId,
      foodTypeId,
      time,
      price,
      discountedPrice,
      servesCount;
  final PlatformFile file;

  AddFoodEvent(
      {required this.name,
      required this.file,
      required this.description,
      required this.calorie,
      required this.foodCategoryId,
      required this.foodTypeId,
      required this.time,
      required this.price,
      required this.discountedPrice,
      required this.servesCount});
}

class EditFoodEvent extends FoodEvent {
  final String name, description, calorie;
  final int foodCategoryId,
      foodTypeId,
      time,
      price,
      discountedPrice,
      servesCount,
      foodId;
  final PlatformFile? file;

  EditFoodEvent({
    required this.name,
    this.file,
    required this.description,
    required this.calorie,
    required this.foodCategoryId,
    required this.foodTypeId,
    required this.time,
    required this.price,
    required this.discountedPrice,
    required this.servesCount,
    required this.foodId,
  });
}

class DeleteFoodEvent extends FoodEvent {
  final int id;

  DeleteFoodEvent({
    required this.id,
  });
}

class GetAllFoodEvent extends FoodEvent {
  final String? query;
  final int? categoryId, typeId;

  GetAllFoodEvent({
    this.query,
    this.categoryId,
    this.typeId,
  });
}
