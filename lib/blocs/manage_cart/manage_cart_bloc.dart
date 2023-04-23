import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'manage_cart_event.dart';
part 'manage_cart_state.dart';

class ManageCartBloc extends Bloc<ManageCartEvent, ManageCartState> {
  ManageCartBloc() : super(ManageCartInitialState()) {
    on<ManageCartEvent>((event, emit) async {
      emit(ManageCartLoadingState());
      SupabaseClient supabaseClient = Supabase.instance.client;
      SupabaseQueryBuilder queryTable = supabaseClient.from('carts');
      SupabaseQueryBuilder foodItemsTable = supabaseClient.from('food_items');
      SupabaseQueryBuilder foodCategoriesTable =
          supabaseClient.from('food_categories');
      SupabaseQueryBuilder foodTypesTable = supabaseClient.from('food_types');
      try {
        if (event is GetAllManageCartEvent) {
          List<dynamic> temp = await queryTable
              .select('*')
              .eq('user_id', supabaseClient.auth.currentUser!.id)
              .order('created_at');

          List<Map<String, dynamic>> cartItems =
              temp.map((e) => e as Map<String, dynamic>).toList();

          int total = 0;

          for (int i = 0; i < cartItems.length; i++) {
            cartItems[i]['food_item'] = await foodItemsTable
                .select('*')
                .eq('id', cartItems[i]['food_item_id'])
                .single();
            cartItems[i]['food_item']['category'] = await foodCategoriesTable
                .select('*')
                .eq('id', cartItems[i]['food_item']['food_category_id'])
                .single();
            cartItems[i]['food_item']['type'] = await foodTypesTable
                .select('*')
                .eq('id', cartItems[i]['food_item']['food_type_id'])
                .single();

            total += (cartItems[i]['food_item']['discounted_price'] *
                cartItems[i]['quantity']) as int;
          }
          emit(ManageCartSuccessState(
            cartItems: cartItems,
            total: total,
          ));
        } else if (event is AddManageCartEvent) {
          await queryTable
              .delete()
              .eq('user_id', supabaseClient.auth.currentUser!.id)
              .eq('food_item_id', event.itemId);

          await queryTable.upsert(
            {
              'user_id': supabaseClient.auth.currentUser!.id,
              'food_item_id': event.itemId,
              'quantity': event.quantity,
            },
          );

          add(GetAllManageCartEvent());
        } else if (event is DeleteManageCartEvent) {
          await queryTable.delete().eq('id', event.cartItemId);
          add(GetAllManageCartEvent());
        }
      } catch (e, s) {
        Logger().wtf('$e,$s');
        emit(ManageCartFailureState());
      }
    });
  }
}
