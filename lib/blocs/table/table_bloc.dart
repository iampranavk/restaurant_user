import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'table_event.dart';
part 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(TableInitialState()) {
    on<TableEvent>((event, emit) async {
      emit(TableLoadingState());
      SupabaseClient supabaseClient = Supabase.instance.client;
      SupabaseQueryBuilder queryTable = supabaseClient.from('tables');
      try {
        if (event is GetAllTableEvent) {
          List<dynamic> temp = event.query != null
              ? await queryTable
                  .select()
                  .ilike('name', '%${event.query}%')
                  .order("name", ascending: true)
              : await queryTable.select().order(
                    'created_at',
                  );

          List<Map<String, dynamic>> tables =
              temp.map((e) => e as Map<String, dynamic>).toList();

          emit(
            TableSuccessState(
              tables: tables,
            ),
          );
        } else if (event is AddTableEvent) {
          await queryTable.insert({
            'name': event.name,
          });
          add(GetAllTableEvent());
        } else if (event is DeleteTableEvent) {
          await queryTable.delete().eq('id', event.id);
          add(GetAllTableEvent());
        }
      } catch (e, s) {
        Logger().wtf('$e,$s');
        emit(TableFailureState());
      }
    });
  }
}
