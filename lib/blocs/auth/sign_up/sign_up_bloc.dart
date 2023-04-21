import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitialState()) {
    on<SignUpEvent>((event, emit) async {
      emit(SignUpLoadingState());
      SupabaseClient supabaseClient = Supabase.instance.client;
      SupabaseQueryBuilder queryTable = supabaseClient.from('profiles');
      try {
        UserResponse userResponse =
            await Supabase.instance.client.auth.admin.createUser(
          AdminUserAttributes(
            email: event.email,
            password: event.password,
            phone: event.phone,
            emailConfirm: true,
            userMetadata: {
              'status': 'active',
            },
          ),
        );

        if (userResponse.user != null) {
          await queryTable.insert(
            {
              'name': event.name,
              'phone': userResponse.user!.phone,
              'user_id': userResponse.user!.id,
            },
          );
        }

        await Supabase.instance.client.auth.signInWithPassword(
          email: event.email,
          password: event.password,
        );

        emit(SignUpSuccessState());
      } on AuthException catch (e, s) {
        Logger().wtf("$e\n$s");
        if (e.statusCode == '422') {
          emit(SignUpFailureState(
            message: e.message,
          ));
        } else {
          emit(SignUpFailureState());
        }
      }
    });
  }
}
