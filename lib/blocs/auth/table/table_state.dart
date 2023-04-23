part of 'table_bloc.dart';

@immutable
abstract class TableState {}

class TableInitialState extends TableState {}

class TableLoadingState extends TableState {}

class TableSuccessState extends TableState {
  final List<Map<String, dynamic>> tables;

  TableSuccessState({required this.tables});
}

class TableFailureState extends TableState {
  final String message;
  TableFailureState({
    this.message =
        'Something went wrong, Please check your connection and try again!.',
  });
}
