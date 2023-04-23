import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc() : super(FoodInitialState()) {
    on<FoodEvent>((event, emit) async {
      emit(FoodLoadingState());
      SupabaseClient supabaseClient = Supabase.instance.client;
      SupabaseQueryBuilder queryTable = supabaseClient.from('food_items');
      SupabaseQueryBuilder categoryTable =
          supabaseClient.from('food_categories');
      SupabaseQueryBuilder typeTable = supabaseClient.from('food_types');
      try {
        if (event is GetAllFoodEvent) {
          List<dynamic> temp = [];

          if (event.query != null &&
              event.categoryId != null &&
              event.typeId != null) {
            temp = await queryTable
                .select('*')
                .ilike('name', '%${event.query}%')
                .eq('food_category_id', event.categoryId)
                .eq('food_type_id', event.typeId)
                .order('name', ascending: true);
          } else if (event.query != null) {
            temp = await queryTable
                .select('*')
                .ilike('name', '%${event.query}%')
                .order('name', ascending: true);
          } else if (event.categoryId != null) {
            temp = await queryTable
                .select('*')
                .eq('food_category_id', event.categoryId)
                .order('name', ascending: true);
          } else if (event.typeId != null) {
            temp = await queryTable
                .select('*')
                .eq('food_type_id', event.typeId)
                .order('name', ascending: true);
          } else {
            temp = await queryTable.select('*').order('name', ascending: true);
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

          emit(
            FoodSuccessState(
              foods: foods,
            ),
          );
        } else if (event is AddFoodEvent) {
          String path = await supabaseClient.storage.from('docs').uploadBinary(
                'categories/${DateTime.now().millisecondsSinceEpoch.toString()}${event.file.name}',
                event.file.bytes!,
              );

          path = path.replaceRange(0, 5, '');

          await queryTable.insert({
            'name': event.name,
            'description': event.description,
            'calories': event.calorie,
            'food_category_id': event.foodCategoryId,
            'food_type_id': event.foodTypeId,
            'serves_count': event.servesCount,
            'price': event.price,
            'discounted_price': event.discountedPrice,
            'time': event.time,
            'image_url': supabaseClient.storage.from('docs').getPublicUrl(path),
          });
          add(GetAllFoodEvent());
        } else if (event is EditFoodEvent) {
          if (event.file != null) {
            String path =
                await supabaseClient.storage.from('docs').uploadBinary(
                      'categories/${DateTime.now().millisecondsSinceEpoch.toString()}${event.file!.name}',
                      event.file!.bytes!,
                    );

            path = path.replaceRange(0, 5, '');
            await queryTable.update({
              'name': event.name,
              'description': event.description,
              'calories': event.calorie,
              'food_category_id': event.foodCategoryId,
              'food_type_id': event.foodTypeId,
              'serves_count': event.servesCount,
              'price': event.price,
              'discounted_price': event.discountedPrice,
              'time': event.time,
              'image_url':
                  supabaseClient.storage.from('docs').getPublicUrl(path),
            }).eq('id', event.foodId);
          } else {
            await queryTable.update({
              'name': event.name,
              'description': event.description,
              'calories': event.calorie,
              'food_category_id': event.foodCategoryId,
              'food_type_id': event.foodTypeId,
              'serves_count': event.servesCount,
              'price': event.price,
              'discounted_price': event.discountedPrice,
              'time': event.time,
            }).eq('id', event.foodId);
          }

          add(GetAllFoodEvent());
        } else if (event is DeleteFoodEvent) {
          await queryTable.delete().eq('id', event.id);
          add(GetAllFoodEvent());
        }
      } catch (e, s) {
        Logger().wtf('$e,$s');
        emit(FoodFailureState());
      }
    });
  }
}
