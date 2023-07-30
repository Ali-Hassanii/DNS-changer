import 'package:dns_changer/models/popup_item_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

/// You can change items here
List items = [
  ItemContent(
    value: "about",
    label: "About this app",
    icon: Icons.info_outline,
  ),
  ItemContent(),
  ItemContent(
    value: "close",
    label: "Close the window",
    icon: Icons.transit_enterexit,
  ),
  ItemContent(
    value: "exit",
    label: "Exit the app",
    icon: Icons.close,
  ),
  ItemContent(),
  ItemContent(
    value: "donate",
    label: "Donate",
    icon: Icons.attach_money,
    enabled: false,
  ),
];

/// You can change look here
class AppBarPopup extends StatelessWidget {
  const AppBarPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu),
      tooltip: "Menu",
      /// change items' functionality here
      onSelected: (String item) {
        switch (item) {
          case "about":
            Uri link = Uri.parse("https://github.com/Ali-Hassanii/DNS-changer#dns-changer");
            launchUrl(link);
          case "close":
            windowManager.hide();
            break;
          case "exit":
            windowManager.close();
            break;
        }
      },
      itemBuilder: (context) => items.map<PopupMenuEntry<String>>((item) {
        if (item.value != null) {
          return PopupMenuItem<String>(
            value: item.value,
            enabled: item.enabled,
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 18),
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          );
        } else {
          return const PopupMenuDivider();
        }
      }).toList(),
    );
  }
}
