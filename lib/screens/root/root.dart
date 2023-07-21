import 'dart:io';

import 'package:dns_changer/blocs/connection_cubit.dart';
import 'package:dns_changer/screens/screens.dart';
import 'package:dns_changer/services/network_channel.dart';
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
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ServerPage(),
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
                  child: const Text("Select server"),
                ),
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
                    onPressed: () {
                      if (Platform.isWindows) {
                        Process.run("cmd.exe", ["ipconfig /flushdns"]);
                      }
                    },
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
                      if (Platform.isWindows) {
                        NetworkAdapter network = NetworkAdapter();
                        network.getTest();
                      }
                    },
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
      },
    );
  }
}
