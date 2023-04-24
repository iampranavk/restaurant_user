import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'plan_meal_event.dart';
part 'plan_meal_state.dart';

class PlanMealBloc extends Bloc<PlanMealEvent, PlanMealState> {
  PlanMealBloc() : super(PlanMealInitialState()) {
    on<PlanMealEvent>((event, emit) async {
      emit(PlanMealLoadingState());
      SupabaseClient supabaseClient = Supabase.instance.client;
      SupabaseQueryBuilder queryTable = supabaseClient.from('food_items');
      SupabaseQueryBuilder categoryTable =
          supabaseClient.from('food_categories');
      SupabaseQueryBuilder typeTable = supabaseClient.from('food_types');
      try {
        List<dynamic> temp = [];

        if (event.categoryId != null && event.foodTypeId != null) {
          temp = await queryTable
              .select('*')
              .eq('food_category_id', event.categoryId)
              .eq('food_type_id', event.foodTypeId)
              .lte('serves_count', event.people)
              .lte('discounted_price', event.budget)
              .order('name', ascending: true);
        } else if (event.categoryId != null) {
          temp = await queryTable
              .select('*')
              .eq('food_category_id', event.categoryId)
              .lte('serves_count', event.people)
              .lte('discounted_price', event.budget)
              .order('name', ascending: true);
        } else if (event.foodTypeId != null) {
          temp = await queryTable
              .select('*')
              .eq('food_type_id', event.foodTypeId)
              .lte('serves_count', event.people)
              .lte('discounted_price', event.budget)
              .order('name', ascending: true);
        } else {
          temp = await queryTable
              .select('*')
              .lte('serves_count', event.people)
              .lte('discounted_price', event.budget)
              .order('name', ascending: true);
        }

        List<Map<String, dynamic>> foods =
            temp.map((e) => e as Map<String, dynamic>).toList();

        for (int i = 0; i < foods.length; i++) {
          Map<String, dynamic> category = await categoryTable
              .select()
              .eq('id', foods[i]['food_category_id'])
              .single();
          Map<String, dynamic> type = await typeTable
              .select()
              .eq('id', foods[i]['food_type_id'])
              .single();
          foods[i]['category'] = category;
          foods[i]['type'] = type;
        }

        foods.shuffle();

        List<dynamic> suggestedItems = [];

        int calculatedMemberCount = 0, calculatedPrice = 0;

        for (int i = 0; i < foods.length; i++) {
          if (calculatedMemberCount < event.people &&
              calculatedPrice < event.budget) {
            calculatedMemberCount += foods[i]['serves_count'] as int;
            calculatedPrice += foods[i]['discounted_price'] as int;
            suggestedItems.add(foods[i]);
          }
        }
        emit(
          PlanMealSuccessState(
            items: suggestedItems,
          ),
        );
      } catch (e, s) {
        Logger().wtf('$e,$s');
        emit(PlanMealFailureState());
      }
    });
  }
}
