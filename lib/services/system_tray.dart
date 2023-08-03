import 'dart:io';
import 'dart:developer';

import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

final AppWindow appWindow = AppWindow();
final SystemTray systemTray = SystemTray();

Future<void> initSystemTray() async {
  String path = Platform.isWindows
      ? 'assets/images/app_icon.ico'
      : 'assets/images/app_icon.png';

  // initial system tray
  await systemTray.initSystemTray(
    title: "system tray",
    toolTip: "Change dns",
    iconPath: path,
  );

  // create context menu
  final Menu menu = Menu();
  await menu.buildFrom([
    MenuItemLabel(
        label: "Show/Hide",
        onClicked: (menuItem) async {
          await windowManager.isVisible() ? appWindow.hide() : appWindow.show();
        }),
    MenuSeparator(),
    MenuItemLabel(label: 'Exit', onClicked: (menuItem) => appWindow.close()),
  ]);
  await systemTray.setContextMenu(menu);

  // handle system tray event
  systemTray.registerSystemTrayEventHandler((eventName) async {
    log("SysTray event name: $eventName", name: "SystemTray");
    if (eventName == kSystemTrayEventClick) {
      await windowManager.isVisible() ? appWindow.hide() : appWindow.show();
    } else if (eventName == kSystemTrayEventRightClick) {
      systemTray.popUpContextMenu();
    } else if (eventName == kSystemTrayEventDoubleClick) {
      await windowManager.isVisible() ? appWindow.hide() : appWindow.show();
    }
  });
}
