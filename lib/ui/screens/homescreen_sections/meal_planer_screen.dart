import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_user/ui/widget/counter.dart';
import 'package:restaurant_user/ui/widget/custom_button.dart';

import '../../../blocs/auth/food_category/food_category_bloc.dart';
import '../../../blocs/plan_meal/plan_meal_bloc.dart';
import '../../widget/categories_item.dart';
import '../../widget/custom_alert_dialog.dart';
import '../../widget/custom_progress_indicator.dart';
import '../../widget/food_type_selector.dart';
import '../../widget/listing_card.dart';
import 'food_screen.dart';

class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  double _value = 0;
  int memberCount = 1;
  int? selectedCategoryId, selectedFoodTypeId;
  FoodCategoryBloc foodCategoryBloc = FoodCategoryBloc();

  @override
  void initState() {
    super.initState();
    foodCategoryBloc.add(GetAllFoodCategoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<PlanMealBloc>(
        create: (context) => PlanMealBloc(),
        child: BlocProvider<FoodCategoryBloc>.value(
          value: foodCategoryBloc,
          child: BlocConsumer<PlanMealBloc, PlanMealState>(
            listener: (context, mealState) {
              if (mealState is PlanMealFailureState) {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    title: 'Failure',
                    message: mealState.message,
                    primaryButtonLabel: 'Ok',
                  ),
                );
              }
            },
            builder: (context, mealState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Meal Planner',
                        style: GoogleFonts.mavenPro(
                          textStyle:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Plan your meal with ease',
                        style: GoogleFonts.mavenPro(
                          textStyle:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ),
                      const Divider(
                        height: 30,
                      ),
                      Text(
                        'Number of people',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Counter(
                        onChange: (count) {
                          memberCount = count;
                        },
                        size: 50,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Your Budget',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '₹${_value.toInt().toString()}',
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Slider(
                        thumbColor: Colors.green,
                        activeColor: Colors.green[900],
                        min: 0,
                        max: 10000,
                        value: _value,
                        onChanged: (value) {
                          _value = value;
                          setState(() {});
                        },
                        label: _value.toString(),
                        divisions: 20,
                        inactiveColor: Colors.green[50],
                      ),
                      //
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Select Category & Type (Optional)',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocConsumer<FoodCategoryBloc, FoodCategoryState>(
                        listener: (context, state) {
                          if (state is FoodCategoryFailureState) {
                            showDialog(
                              context: context,
                              builder: (context) => CustomAlertDialog(
                                title: 'Failed',
                                message: state.message,
                                primaryButtonLabel: 'Ok',
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                            height: 100,
                            child: state is FoodCategorySuccessState
                                ? state.categories.isNotEmpty
                                    ? ListView(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        children: [
                                          AllCategory(
                                            isSelected:
                                                selectedCategoryId == null,
                                            onPressed: () {
                                              selectedCategoryId = null;
                                              setState(() {});
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: state.categories.length,
                                            itemBuilder: (context, index) =>
                                                CategoriesItem(
                                              isSelected: selectedCategoryId ==
                                                  state.categories[index]['id'],
                                              categoryDetails:
                                                  state.categories[index],
                                              onSelect: (id) {
                                                selectedCategoryId = id;
                                                setState(() {});
                                              },
                                            ),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(width: 10),
                                          ),
                                        ],
                                      )
                                    : const Text('Nothing')
                                : const Center(
                                    child: CustomProgressIndicator(),
                                  ),
                          );
                        },
                      ),
                      const Divider(
                        height: 20,
                      ),
                      FoodTypeSelector(
                        onSelect: (id) {
                          selectedFoodTypeId = id == 0 ? null : id;
                        },
                      ),
                      const Divider(
                        height: 20,
                      ),
                      CustomButton(
                        label: 'Get Items',
                        buttonColor: Colors.green,
                        labelColor: Colors.white,
                        isLoading: mealState is PlanMealLoadingState,
                        onTap: () {
                          if (_value > 0) {
                            BlocProvider.of<PlanMealBloc>(context).add(
                              PlanMealEvent(
                                people: memberCount,
                                budget: _value.toInt(),
                                categoryId: selectedCategoryId,
                                foodTypeId: selectedFoodTypeId,
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => const CustomAlertDialog(
                                title: 'No Budget',
                                message: 'Set a budget to get suggestions',
                                primaryButtonLabel: 'Ok',
                              ),
                            );
                          }
                        },
                      ),
                      if (mealState is PlanMealSuccessState)
                        const Divider(
                          height: 20,
                        ),
                      if (mealState is PlanMealSuccessState)
                        const SizedBox(
                          height: 20,
                        ),
                      if (mealState is PlanMealSuccessState)
                        Text(
                          'Items',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      if (mealState is PlanMealSuccessState)
                        const SizedBox(
                          height: 20,
                        ),
                      if (mealState is PlanMealSuccessState &&
                          mealState.items.isEmpty)
                        const Text(
                          'No Items Found',
                        ),
                      if (mealState is PlanMealSuccessState &&
                          mealState.items.isNotEmpty)
                        GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          childAspectRatio: 1 / 1.5,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          children: List<Widget>.generate(
                            mealState.items.length,
                            (index) => ListingCard(
                              foodDetails: mealState.items[index],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
