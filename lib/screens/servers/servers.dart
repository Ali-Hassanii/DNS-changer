import 'package:dns_changer/widgets/server_list_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/storage/storage_bloc.dart';

class ServerPage extends StatelessWidget {
  const ServerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final StorageBloc storageBloc = StorageBloc();
        storageBloc.add(Initial());
        return storageBloc;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Add server page
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: BlocBuilder<StorageBloc, StorageState>(
          builder: (context, state) {
            if (state is LoadingData) {
              /// Loading state
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ServersList) {
              /// Got server
              return BlocProvider.value(
                value: BlocProvider.of<StorageBloc>(context),
                child: ServerListBuilder(servers: state.servers),
              );
            } else {
              /// Got error
              return const Center(
                child: Text("SMTH went wrong!"),
              );
            }
          },
        ),
      ),
    );
  }
}
