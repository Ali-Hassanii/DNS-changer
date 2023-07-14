// Dart packages
import 'dart:developer';
import 'dart:io';

// Flutter packages
import 'package:flutter/material.dart';

// Window packages
import 'package:window_manager/window_manager.dart';
import 'package:system_tray/system_tray.dart';

// Import all screen
import 'package:dns_changer/pages/pages.dart';

const Size windowSize = Size(270, 430); // Window static size
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  // set window look
  WindowOptions windowOptions = const WindowOptions(
    title: "DNS changer",
    size: windowSize,
    minimumSize: windowSize,
    maximumSize: windowSize,
    center: true,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const AppLogic());
}

class AppLogic extends StatefulWidget {
  const AppLogic({super.key});

  @override
  State<AppLogic> createState() => _AppLogicState();
}

class _AppLogicState extends State<AppLogic> with WindowListener {
  final AppWindow appWindow = AppWindow();
  final SystemTray systemTray = SystemTray();

  Future<void> initSystemTray() async {
    String path =
        Platform.isWindows ? 'assets/app_icon.ico' : 'assets/app_icon.png';

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
            await windowManager.isVisible()
                ? appWindow.hide()
                : appWindow.show();
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

  @override
  void initState() {
    windowManager.addListener(this);
    initSystemTray();
    super.initState();
  }

  /// Log window state
  @override
  void onWindowEvent(String eventName) {
    log("Window event name: $eventName}", name: "WindowListener");
    super.onWindowEvent(eventName);
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "DNS changer",
      home: RootPage(),
    );
  }
}
