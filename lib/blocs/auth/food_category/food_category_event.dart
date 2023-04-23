part of 'food_category_bloc.dart';

@immutable
abstract class FoodCategoryEvent {}

class AddFoodCategoryEvent extends FoodCategoryEvent {
  final String name;
  final PlatformFile file;

  AddFoodCategoryEvent({
    required this.name,
    required this.file,
  });
}

class DeleteFoodCategoryEvent extends FoodCategoryEvent {
  final int id;

  DeleteFoodCategoryEvent({
    required this.id,
  });
}

class GetAllFoodCategoryEvent extends FoodCategoryEvent {
  final String? query;

  GetAllFoodCategoryEvent({
    this.query,
  });
}
