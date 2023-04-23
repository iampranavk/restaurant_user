part of 'food_category_bloc.dart';

@immutable
abstract class FoodCategoryState {}

class FoodCategoryInitialState extends FoodCategoryState {}

class FoodCategoryLoadingState extends FoodCategoryState {}

class FoodCategorySuccessState extends FoodCategoryState {
  final List<Map<String, dynamic>> categories;

  FoodCategorySuccessState({required this.categories});
}

class FoodCategoryFailureState extends FoodCategoryState {
  final String message;
  FoodCategoryFailureState({
    this.message =
        'Something went wrong, Please check your connection and try again!.',
  });
}
