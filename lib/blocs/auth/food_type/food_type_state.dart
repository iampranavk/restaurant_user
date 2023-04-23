part of 'food_type_bloc.dart';

@immutable
abstract class FoodTypeState {}

class FoodTypeInitialState extends FoodTypeState {}

class FoodTypeLoadingState extends FoodTypeState {}

class FoodTypeSuccessState extends FoodTypeState {
  final List<Map<String, dynamic>> types;

  FoodTypeSuccessState({required this.types});
}

class FoodTypeFailureState extends FoodTypeState {
  final String message;
  FoodTypeFailureState({
    this.message =
        'Something went wrong, Please check your connection and try again!.',
  });
}
