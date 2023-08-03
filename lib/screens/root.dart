import 'dart:io';

import 'package:dns_changer/blocs/select_server_cubit.dart';
import 'package:dns_changer/screens/screens.dart';
import 'package:dns_changer/services/adapter_manager.dart';
import 'package:flutter/material.dart';
import 'package:dns_changer/widgets/app_bar_popup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/server.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    AdapterManager manager = AdapterManager();
    SnackBar successSnackBar = const SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.check,
            color: Colors.greenAccent,
          ),
          SizedBox(width: 10),
          Text("Success"),
        ],
      ),
      backgroundColor: Colors.green,
      duration: Duration(milliseconds: 200),
    );
    SnackBar failedSnackBar = const SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.close,
            color: Colors.redAccent,
          ),
          SizedBox(width: 10),
          Text("Failed"),
        ],
      ),
      backgroundColor: Colors.red,
      duration: Duration(milliseconds: 200),
    );
    return BlocProvider(
      create: (context) => SelectServerCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(leading: const AppBarPopup()),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Chose server button
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, animation, secondaryAnimation) =>
                          BlocProvider.value(
                        value: BlocProvider.of<SelectServerCubit>(context),
                        child: const ServerPage(),
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const curve = Curves.easeOut;

                        Animatable<Offset> posTween = Tween(
                          begin: const Offset(0.0, 0.3),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: curve));
                        Animatable<double> opacityTween = Tween(
                          begin: 0.0,
                          end: 1.0,
                        ).chain(CurveTween(curve: curve));

                        return FadeTransition(
                          opacity: animation.drive(opacityTween),
                          child: SlideTransition(
                            position: animation.drive(posTween),
                            child: child,
                          ),
                        );
                      },
                    ),
                  ),
                  child: BlocBuilder<SelectServerCubit, Server?>(
                    builder: (context, state) {
                      return Text(
                        state == null ? "Select server" : state.title,
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ),
                Tooltip(
                  message: "Obtain DNS address automatically",
                  child: ElevatedButton(
                      onPressed: () async {
                        String interface = await manager.activeInterface();
                        bool done = await manager.resetDns(interface);
                        if (done) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(successSnackBar);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(failedSnackBar);
                        }
                      },
                      child: Text(
                        "Enable DHCP",
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                )
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Tooltip(
                  message: "Clear system DNS records",
                  child: ElevatedButton(
                    onPressed: () async {
                      bool done = await manager.flushDns();
                      if (done) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(successSnackBar);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(failedSnackBar);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent),
                    child: Text(
                      "Clear cache",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                Tooltip(
                  message: "Apply this settings",
                  child: ElevatedButton(
                    onPressed: () async {
                      Server? state = context.read<SelectServerCubit>().state;
                      if (Platform.isWindows && state != null) {
                        String interface = await manager.activeInterface();
                        bool done = await manager
                            .setDns(interface, [state.address1, state.address2]);
                        if (done) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(successSnackBar);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(failedSnackBar);
                        }
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text(
                      "Apply",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
