import 'package:bloc/bloc.dart';

class ConnectionCubit extends Cubit<bool> {
  ConnectionCubit() : super(false);

  void connect() {
    emit(true);
  }

  void disconnect() {
    emit(false);
  }
}
