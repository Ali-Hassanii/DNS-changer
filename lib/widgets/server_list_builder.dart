import 'package:dns_changer/widgets/server_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/storage/storage_bloc.dart';
import '../models/server.dart';

class ServerListBuilder extends StatelessWidget {
  const ServerListBuilder({super.key, required this.servers});

  final List<Server> servers;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemBuilder: (context, index) {
        Server server = servers[index];
        return Card(
          key: ValueKey<int>(server.id),
          child: ListTile(
            onTap: () {
              // TODO: Create cubit to selecting server
            },

            onLongPress: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<StorageBloc>(context),
                  child: ServerBottomSheet(
                    id: server.id,
                  ),
                ),
              );
            },
            leading: const Icon(Icons.dns_outlined),
            title: Text(server.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(server.address1),
                // const SizedBox(height: 10.0),
                Text(server.address2),
              ],
            ),
          ),
        );
      },
      itemCount: servers.length,
      onReorder: (oldIndex, newIndex) {
        // TODO: Reorder the list and update it in database
      },
    );
  }
}
