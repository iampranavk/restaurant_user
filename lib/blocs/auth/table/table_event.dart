part of 'table_bloc.dart';

@immutable
abstract class TableEvent {}

class AddTableEvent extends TableEvent {
  final String name;

  AddTableEvent({
    required this.name,
  });
}

class DeleteTableEvent extends TableEvent {
  final int id;

  DeleteTableEvent({
    required this.id,
  });
}

class GetAllTableEvent extends TableEvent {
  final String? query;

  GetAllTableEvent({
    this.query,
  });
}
