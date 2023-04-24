part of 'plan_meal_bloc.dart';

@immutable
abstract class PlanMealState {}

class PlanMealInitialState extends PlanMealState {}

class PlanMealSuccessState extends PlanMealState {
  final List<dynamic> items;

  PlanMealSuccessState({required this.items});
}

class PlanMealLoadingState extends PlanMealState {}

class PlanMealFailureState extends PlanMealState {
  final String message;

  PlanMealFailureState(
      {this.message =
          'Something went wrong, Please check your connection and try again!.'});
}
