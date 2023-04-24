part of 'plan_meal_bloc.dart';

class PlanMealEvent {
  final int people, budget;
  final int? categoryId, foodTypeId;

  PlanMealEvent({
    required this.people,
    required this.budget,
    this.categoryId,
    this.foodTypeId,
  });
}
