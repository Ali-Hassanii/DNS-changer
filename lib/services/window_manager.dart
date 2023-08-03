import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart' show Size;

Future<void> initWindowManager() async {
  await windowManager.ensureInitialized();
  const Size windowSize = Size(270, 430); // Window static size
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
}
