import 'package:bloc/bloc.dart';

import '../models/server.dart';

class SelectServerCubit extends Cubit<Server?> {
  SelectServerCubit() : super(null);

  void selectServer(Server server) => emit(server);
}
