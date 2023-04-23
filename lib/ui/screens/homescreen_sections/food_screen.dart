import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_user/blocs/auth/food/food_bloc.dart';
import 'package:restaurant_user/blocs/auth/food_category/food_category_bloc.dart';
import 'package:restaurant_user/ui/screens/food_details_screen.dart';
import 'package:restaurant_user/ui/widget/categories_item.dart';
import 'package:restaurant_user/ui/widget/custom_alert_dialog.dart';
import 'package:restaurant_user/ui/widget/custom_progress_indicator.dart';
import 'package:restaurant_user/ui/widget/custom_search.dart';
import 'package:restaurant_user/ui/widget/food_type_selector.dart';
import 'package:restaurant_user/ui/widget/listing_card.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  FoodBloc foodBloc = FoodBloc();
  FoodCategoryBloc foodCategoryBloc = FoodCategoryBloc();

  String? query;
  int? typeId;
  int selectedCategoryId = 0;

  void getFood() {
    foodBloc.add(GetAllFoodEvent(
      query: query,
      categoryId: selectedCategoryId == 0 ? null : selectedCategoryId,
      typeId: typeId,
    ));
  }

  @override
  void initState() {
    getFood();

    foodCategoryBloc.add(GetAllFoodCategoryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FoodBloc>.value(
          value: foodBloc,
        ),
        BlocProvider<FoodCategoryBloc>.value(
          value: foodCategoryBloc,
        ),
      ],
      child: BlocConsumer<FoodBloc, FoodState>(
        listener: (context, state) {
          if (state is FoodFailureState) {
            showDialog(
              context: context,
              builder: (_) => CustomAlertDialog(
                title: 'Failure',
                message: state.message,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'explore food',
                      style: GoogleFonts.pacifico(
                        textStyle:
                            Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomSearch(
                    onSearch: (search) {
                      query = search;
                      getFood();
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 8,
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
                                        isSelected: selectedCategoryId == 0,
                                        onPressed: () {
                                          selectedCategoryId = 0;
                                          setState(() {});
                                          getFood();
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
                                            getFood();
                                          },
                                        ),
                                        separatorBuilder: (context, index) =>
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
                      typeId = id == 0 ? null : id;
                      getFood();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: state is FoodLoadingState ? 10 : 1,
                  ),
                  state is FoodLoadingState
                      ? const Center(
                          child: CustomProgressIndicator(),
                        )
                      : state is FoodSuccessState
                          ? state.foods.isNotEmpty
                              ? GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  childAspectRatio: 1 / 1.5,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  children: List<Widget>.generate(
                                    state.foods.length,
                                    (index) => ListingCard(
                                      foodDetails: state.foods[index],
                                    ),
                                  ),
                                )
                              : const Center(child: Text('No foods found'))
                          : const SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AllCategory extends StatelessWidget {
  final Function() onPressed;
  final bool isSelected;
  const AllCategory({
    super.key,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          borderRadius: BorderRadius.circular(100),
          color: isSelected ? Colors.green : Colors.green[50],
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: onPressed,
            child: SizedBox(
              height: 80,
              width: 80,
              child: Center(
                child: Icon(
                  Icons.restaurant_menu_outlined,
                  color: isSelected ? Colors.green[50] : Colors.green,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          'All',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: isSelected ? Colors.green : Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
