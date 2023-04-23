part of 'food_bloc.dart';

@immutable
abstract class FoodState {}

class FoodInitialState extends FoodState {}

class FoodLoadingState extends FoodState {}

class FoodSuccessState extends FoodState {
  final List<Map<String, dynamic>> foods;

  FoodSuccessState({required this.foods});
}

class FoodFailureState extends FoodState {
  final String message;
  FoodFailureState({
    this.message =
        'Something went wrong, Please check your connection and try again!.',
  });
}
