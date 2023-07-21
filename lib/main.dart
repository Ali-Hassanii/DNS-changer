import 'package:flutter/material.dart';
import '/screens/screens.dart'; // Import all screen
import 'services/system_tray.dart';
import 'services/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initWindowManager();
  runApp(const AppLogic());
}

class AppLogic extends StatefulWidget {
  const AppLogic({super.key});

  @override
  State<AppLogic> createState() => _AppLogicState();
}

class _AppLogicState extends State<AppLogic> {
  @override
  void initState() {
    initSystemTray();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DNS changer",
      debugShowCheckedModeBanner: false,
      initialRoute: "/root",
      routes: {
        "/root": (BuildContext context) => const RootPage(),
        "/server": (BuildContext context) => const ServerPage(),
      },
    );
  }
}
