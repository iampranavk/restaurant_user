import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'food_category_event.dart';
part 'food_category_state.dart';

class FoodCategoryBloc extends Bloc<FoodCategoryEvent, FoodCategoryState> {
  FoodCategoryBloc() : super(FoodCategoryInitialState()) {
    on<FoodCategoryEvent>((event, emit) async {
      emit(FoodCategoryLoadingState());

      SupabaseClient supabaseClient = Supabase.instance.client;
      SupabaseQueryBuilder queryTable = supabaseClient.from('food_categories');
      try {
        if (event is GetAllFoodCategoryEvent) {
          List<dynamic> temp = event.query != null
              ? await queryTable
                  .select()
                  .ilike('category', '%${event.query}%')
                  .order("category", ascending: true)
              : await queryTable.select().order(
                    'created_at',
                  );

          List<Map<String, dynamic>> categories =
              temp.map((e) => e as Map<String, dynamic>).toList();

          emit(
            FoodCategorySuccessState(
              categories: categories,
            ),
          );
        } else if (event is AddFoodCategoryEvent) {
          String path = await supabaseClient.storage.from('docs').uploadBinary(
                'categories/${DateTime.now().millisecondsSinceEpoch.toString()}${event.file.name}',
                event.file.bytes!,
              );

          path = path.replaceRange(0, 5, '');
          await queryTable.insert({
            'category': event.name,
            'image_url': supabaseClient.storage.from('docs').getPublicUrl(path),
          });
          add(GetAllFoodCategoryEvent());
        } else if (event is DeleteFoodCategoryEvent) {
          await queryTable.delete().eq('id', event.id);
          add(GetAllFoodCategoryEvent());
        }
      } catch (e, s) {
        Logger().wtf('$e,$s');
        emit(FoodCategoryFailureState());
      }
    });
  }
}
