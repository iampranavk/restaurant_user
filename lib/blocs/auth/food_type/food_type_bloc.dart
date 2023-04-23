import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'food_type_event.dart';
part 'food_type_state.dart';

class FoodTypeBloc extends Bloc<FoodTypeEvent, FoodTypeState> {
  FoodTypeBloc() : super(FoodTypeInitialState()) {
    on<FoodTypeEvent>((event, emit) async {
      emit(FoodTypeLoadingState());
      SupabaseClient supabaseClient = Supabase.instance.client;
      SupabaseQueryBuilder queryTable = supabaseClient.from('food_types');
      try {
        if (event is GetAllFoodTypeEvent) {
          List<dynamic> temp = event.query != null
              ? await queryTable
                  .select()
                  .ilike('type', '%${event.query}%')
                  .order("type", ascending: true)
              : await queryTable.select().order(
                    'created_at',
                  );

          List<Map<String, dynamic>> types =
              temp.map((e) => e as Map<String, dynamic>).toList();

          emit(
            FoodTypeSuccessState(
              types: types,
            ),
          );
        } else if (event is AddFoodTypeEvent) {
          await queryTable.insert({
            'type': event.name,
          });
          add(GetAllFoodTypeEvent());
        } else if (event is DeleteFoodTypeEvent) {
          await queryTable.delete().eq('id', event.id);
          add(GetAllFoodTypeEvent());
        }
      } catch (e, s) {
        Logger().wtf('$e,$s');
        emit(FoodTypeFailureState());
      }
    });
  }
}
