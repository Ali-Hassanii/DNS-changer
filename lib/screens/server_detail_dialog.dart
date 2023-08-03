import 'package:dns_changer/blocs/storage/storage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/server.dart';

class ServerDetailDialog extends StatelessWidget {
  const ServerDetailDialog({super.key, this.server});

  final Server? server;

  String? validator(String? text) {
    if (text!.isNotEmpty) {
      RegExp pattern = RegExp(r"^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$");
      if (pattern.hasMatch(text)) {
        return null;
      } else {
        return "IP address is not valid";
      }
    } else {
      return "Do not leave it empty";
    }
  }

  InputDecoration decoration(String label) => InputDecoration(
        label: Text(label),
        hintText: "0.0.0.0",
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      );

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String title = "";
    String server1 = "";
    String server2 = "";
    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Server properties",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: server?.title,
                    validator: (String? text) {
                      if (text!.isEmpty) {
                        return "Do not leave it empty";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      label: Text("Name"),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    onChanged: (String value) => title = value,
                  ),
                  const Divider(
                    height: 25,
                  ),
                  TextFormField(
                    initialValue: server?.address1,
                    validator: validator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[\d.]"),
                      ),
                    ],
                    decoration: decoration("Preferred server"),
                    onChanged: (String value) => server1 = value,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: server?.address2,
                    validator: validator,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[\d.]"),
                      ),
                    ],
                    decoration: decoration("Alternative server"),
                    onChanged: (String value) => server2 = value,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: const Size(65, 25),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  "Cancel",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (server == null) {
                      BlocProvider.of<StorageBloc>(context).add(
                        InsertServer(
                          Server(
                            title: title,
                            address1: server1,
                            address2: server2,
                          ),
                        ),
                      );
                    } else {
                      BlocProvider.of<StorageBloc>(context).add(
                        UpdateServer(
                          Server(
                            id: server!.id,
                            title: title,
                            address1: server1,
                            address2: server2,
                          ),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  fixedSize: const Size(65, 25),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  "Save",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
