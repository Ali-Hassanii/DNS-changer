import 'package:dns_changer/blocs/storage/storage_bloc.dart';
import 'package:dns_changer/screens/server_detail_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/server.dart';

class ServerBottomSheet extends StatelessWidget {
  const ServerBottomSheet({super.key, required this.server});

  final Server server;
  static const Radius radius = Radius.circular(20.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.only(topLeft: radius, topRight: radius),
        color: Theme.of(context).colorScheme.primary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const Divider(
            thickness: 3,
            indent: 80,
            endIndent: 80,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<StorageBloc>(context),
                  child: ServerDetailDialog(
                    server: server,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(100, 45)),
            child: const Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  color: Colors.greenAccent,
                ),
                SizedBox(width: 18),
                Text("Edit"),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<StorageBloc>(context)
                  .add(DeleteServer(server.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, minimumSize: const Size(100, 45)),
            child: const Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                SizedBox(width: 18),
                Text("Delete"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
