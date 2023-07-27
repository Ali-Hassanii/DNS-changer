import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/storage/storage_bloc.dart';

class ServerPage extends StatelessWidget {
  const ServerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final StorageBloc storageBloc = StorageBloc();
    storageBloc.add(Initial());
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<StorageBloc, StorageState>(
        bloc: storageBloc,
        builder: (context, state) {
          if (storageBloc.state is LoadingData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (storageBloc.state is ServersList) {
            return const Center(
              child: Text("Got server!"),
            );
          } else {
            return const Center(
              child: Text("SMTH went wrong!"),
            );
          }
        },
      ),
    );
  }
}
