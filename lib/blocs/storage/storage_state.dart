part of 'storage_bloc.dart';

@immutable
abstract class StorageState {}

class StorageInitial extends StorageState {}

class ServersList extends StorageState {
  final List<Server> servers;

  ServersList(this.servers);
}

class LoadingData extends StorageState {}

class GotError extends StorageState {
  final String where;
  final String error;

  GotError({required this.where, required this.error});
}
