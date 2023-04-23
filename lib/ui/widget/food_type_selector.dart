import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_user/blocs/auth/food_type/food_type_bloc.dart';
import 'package:restaurant_user/ui/widget/custom_progress_indicator.dart';

import 'custom_alert_dialog.dart';

class FoodTypeSelector extends StatefulWidget {
  final Function(int) onSelect;
  final int? selectedCategory;
  const FoodTypeSelector({
    super.key,
    required this.onSelect,
    this.selectedCategory = 0,
  });

  @override
  State<FoodTypeSelector> createState() => _FoodTypeSelectorState();
}

class _FoodTypeSelectorState extends State<FoodTypeSelector> {
  final FoodTypeBloc foodTypeBloc = FoodTypeBloc();

  int selectedId = 0;

  @override
  void initState() {
    foodTypeBloc.add(GetAllFoodTypeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FoodTypeBloc>.value(
      value: foodTypeBloc,
      child: BlocConsumer<FoodTypeBloc, FoodTypeState>(
        listener: (context, state) {
          if (state is FoodTypeFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failed!',
                message: state.message,
                primaryButtonLabel: 'Retry',
                primaryOnPressed: () {
                  foodTypeBloc.add(GetAllFoodTypeEvent());
                  Navigator.pop(context);
                },
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FoodTypeSuccessState) {
            return Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(20),
                          color: selectedId == 0
                              ? Colors.green[50]
                              : Colors.grey[200],
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              selectedId = 0;
                              setState(() {});
                              widget.onSelect(0);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: Center(
                                child: Text(
                                  'All Types',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                          color: selectedId == 0
                                              ? Colors.green[700]
                                              : Colors.grey[800]),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => Material(
                            borderRadius: BorderRadius.circular(20),
                            color: selectedId == state.types[index]['id']
                                ? Colors.green.withOpacity(0.1)
                                : Colors.grey[200],
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                selectedId = state.types[index]['id'];
                                setState(() {});
                                widget.onSelect(state.types[index]['id']);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                child: Center(
                                  child: Text(
                                    state.types[index]['type'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            color: selectedId ==
                                                    state.types[index]['id']
                                                ? Colors.green[700]
                                                : Colors.grey[800]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemCount: state.types.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is FoodTypeFailureState) {
            return const SizedBox();
          } else {
            return const Center(child: CustomProgressIndicator());
          }
        },
      ),
    );
  }
}
