import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'manage_orders_event.dart';
part 'manage_orders_state.dart';

class ManageOrdersBloc extends Bloc<ManageOrdersEvent, ManageOrdersState> {
  ManageOrdersBloc() : super(ManageOrdersInitialState()) {
    on<ManageOrdersEvent>((event, emit) async {
      emit(ManageOrdersLoadingState());
      SupabaseClient supabaseClient = Supabase.instance.client;
      SupabaseQueryBuilder queryTable = supabaseClient.from('orders');
      SupabaseQueryBuilder orderItemsTable = supabaseClient.from('order_items');
      SupabaseQueryBuilder cartsTable = supabaseClient.from('carts');
      SupabaseQueryBuilder foodItemsTable = supabaseClient.from('food_items');
      SupabaseQueryBuilder foodCategoriesTable =
          supabaseClient.from('food_categories');
      SupabaseQueryBuilder foodTypesTable = supabaseClient.from('food_types');
      try {
        if (event is GetAllManageOrdersEvent) {
          List<dynamic> temp = await queryTable
              .select()
              .eq('user_id', supabaseClient.auth.currentUser!.id)
              .order('created_at');

          List<Map<String, dynamic>> orders =
              temp.map((e) => e as Map<String, dynamic>).toList();

          for (int i = 0; i < orders.length; i++) {
            orders[i]['items'] = await orderItemsTable
                .select('*')
                .eq('order_id', orders[i]['id']);

            for (int j = 0; j < orders[i]['items'].length; j++) {
              orders[i]['items'][i]['food_item'] = await foodItemsTable
                  .select('*')
                  .eq('id', orders[i]['items'][i]['food_item_id'])
                  .single();
              orders[i]['items'][i]['food_item']['category'] =
                  await foodCategoriesTable
                      .select('*')
                      .eq(
                          'id',
                          orders[i]['items'][i]['food_item']
                              ['food_category_id'])
                      .single();

              orders[i]['items'][i]['food_item']['type'] = await foodTypesTable
                  .select('*')
                  .eq('id', orders[i]['items'][i]['food_item']['food_type_id'])
                  .single();
            }
          }

          emit(ManageOrdersSuccessState(orders: orders));
        } else if (event is CreateOrdersEvent) {
          List<dynamic> cartItems = await cartsTable
              .select('*')
              .eq('user_id', supabaseClient.auth.currentUser!.id);

          int total = 0;

          for (int i = 0; i < cartItems.length; i++) {
            cartItems[i]['food_item'] = await foodItemsTable
                .select('*')
                .eq('id', cartItems[i]['food_item_id'])
                .single();

            total += (cartItems[i]['food_item']['discounted_price'] *
                cartItems[i]['quantity']) as int;
          }

          Map<String, dynamic> orderDetails = await queryTable
              .insert({
                'user_id': supabaseClient.auth.currentUser!.id,
                'total': total,
                'table_id': event.tableId
              })
              .select()
              .single();

          List<Map<String, dynamic>> orderItems = [];

          for (int i = 0; i < cartItems.length; i++) {
            orderItems.add({
              'order_id': orderDetails['id'],
              'food_item_id': cartItems[i]['food_item_id'],
              'quantity': cartItems[i]['quantity'],
              'price': cartItems[i]['food_item']['discounted_price'],
            });
          }

          await orderItemsTable.insert(orderItems);

          await cartsTable
              .delete()
              .eq('user_id', supabaseClient.auth.currentUser!.id);

          add(GetAllManageOrdersEvent(status: 'pending'));
        } else if (event is HandleOrdersEvent) {
          await queryTable
              .update({'status': event.status}).eq('id', event.orderId);

          //TODO:change according to received status
          add(GetAllManageOrdersEvent(status: 'pending'));
        }
      } catch (e, s) {
        Logger().wtf('$e,$s');
        emit(ManageOrdersFailureState());
      }
    });
  }
}
