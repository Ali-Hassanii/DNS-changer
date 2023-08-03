import 'dart:ffi';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/server.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/open.dart';
import 'package:path/path.dart' as path;

part 'storage_event.dart';

part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  late Database database;

  List<Server> loadServers() {
    final List<Map<String, dynamic>> raw =
        database.select("SELECT * FROM servers;");
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

  DynamicLibrary _openOnWindows() {
    return DynamicLibrary.open(path.absolute("sqlite3.dll"));
  }

  StorageBloc() : super(StorageInitial()) {
    on<Initial>((event, emit) {
      emit(LoadingData());
      try {
        open.overrideFor(OperatingSystem.windows, _openOnWindows);

        database = sqlite3.open(
          path.absolute("dns_changer_data.db"),
        );
        emit(ServersList(loadServers()));
      } catch (E) {
        emit(GotError(where: "initialization", error: E.toString()));
      }
    });
    on<InsertServer>((event, emit) {
      emit(LoadingData());
      try {
        Server server = event.server;
        database.execute("""
          INSERT INTO servers (title, server1, server2) VALUES 
          ('${server.title}', '${server.address1}', '${server.address2}');
          """);
        emit(ServersList(loadServers()));
      } catch (E) {
        emit(GotError(where: "add new server", error: E.toString()));
      }
    });
    on<UpdateServer>((event, emit) {
      emit(LoadingData());
      try {
        Server server = event.server;
        database.execute("""
          UPDATE servers
          SET title='${server.title}', server1='${server.address1}', 
          server2='${server.address2}'
          WHERE id=${server.id};
          """);
        emit(ServersList(loadServers()));
      } catch (E) {
        emit(GotError(where: "update this server", error: E.toString()));
      }
    });
    on<DeleteServer>((event, emit) {
      emit(LoadingData());
      try {
        if (event.id != null) {
          database.execute("""
              DELETE FROM servers
              WHERE id=${event.id};
              """);
        } else {
          database.execute("DELETE FROM servers;");
        }
        emit(ServersList(loadServers()));
      } catch (E) {
        emit(GotError(where: "delete selected server(s)", error: E.toString()));
      }
    });
  }
}
