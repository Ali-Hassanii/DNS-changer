part of 'storage_bloc.dart';

@immutable
abstract class StorageEvent {}

@immutable
class Initial extends StorageEvent {}

@immutable
class InsertServer extends StorageEvent {
  final Server server;

  InsertServer(this.server);
}

@immutable
class FetchServer extends StorageEvent {}

@immutable
class UpdateServer extends StorageEvent {
  final Server server;

  UpdateServer(this.server);
}

@immutable
class DeleteServer extends StorageEvent {
  final List<int> ids;

  DeleteServer(this.ids);
}
