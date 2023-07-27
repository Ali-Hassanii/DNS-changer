import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/server.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

part 'storage_event.dart';

part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  late Database database;

  Future<List<Server>> loadServers() async {
    final List<Map<String, dynamic>> raw = await database.query("servers");
    final List<Server> data = List.generate(
      raw.length,
      (i) => Server(
        id: raw[i]["id"],
        title: raw[i]["title"],
        address1: raw[i]["server1"],
        address2: raw[i]["server2"],
      ),
    );
    return data;
  }

  StorageBloc() : super(StorageInitial()) {
    on<Initial>((event, emit) async {
      emit(LoadingData());
      try {
        database = await openDatabase(
          version: 1,
          join(await getDatabasesPath(), "dns_changer_data.db"),
          onCreate: (database, version) {
            return database.execute(
              "CREATE TABLE servers (id INTEGER PRIMARY KEY, title TEXT, "
              "server1 TEXT, server2 TEXT);",
            );
          },
        );
        emit(ServersList(await loadServers()));
      } catch (E) {
        emit(GotError(where: "initialization", error: E.toString()));
      }
    });
    on<InsertServer>((event, emit) async {
      emit(LoadingData());
      try {
        await database.insert(
          "server",
          event.server.toMap(),
        );
        emit(ServersList(await loadServers()));
      } catch (E) {
        emit(GotError(where: "add new server", error: E.toString()));
      }
    });
    on<UpdateServer>((event, emit) async {
      emit(LoadingData());
      try {
        await database.update(
          "servers",
          event.server.toMap(),
          where: "id = ?",
          whereArgs: [event.server.id],
        );
        emit(ServersList(await loadServers()));
      } catch (E) {
        emit(GotError(where: "update this server", error: E.toString()));
      }
    });
    on<DeleteServer>((event, emit) async {
      emit(LoadingData());
      try {
        if (event.ids.isNotEmpty) {
          for (int id in event.ids) {
            await database.delete(
              "servers",
              where: "id = ?",
              whereArgs: [id],
            );
          }
        } else {
          await database.execute("DELETE FROM servers;");
        }
        emit(ServersList(await loadServers()));
      } catch (E) {
        emit(GotError(where: "delete selected server(s)", error: E.toString()));
      }
    });
  }
}
