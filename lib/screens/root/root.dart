import 'package:dns_changer/blocs/connection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dns_changer/widgets/app_bar_popup.dart';

ConnectionCubit connection = ConnectionCubit();

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionCubit, bool>(
      bloc: connection,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(connection.state ? "Running" : "Not set"),
            leading: const AppBarPopup(),
          ),
          body: const RootBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (connection.state) {
                connection.disconnect();
              } else {
                connection.connect();
              }
            },
            child: Icon(
              Icons.power_settings_new,
              color: connection.state ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }
}

class RootBody extends StatelessWidget {
  const RootBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: null, // TODO: Server list page
            child: Text("Select server"),
          ),
        ],
      ),
    );
  }
}
