import 'package:flutter/services.dart';
class NetworkAdapter {
  MethodChannel channel = const MethodChannel("network");
  Future<void> getTest() async {
    var result = await channel.invokeMethod("active_adapter");
    print(result);
  }

  // Future<String> getActiveNetworkAdapter() async {
  //   try {
  //     print(await platform.invokeMethod('getPrimaryAdapter'));
  //     final String adapter = "";
  //     return adapter;
  //   } on PlatformException catch (e) {
  //     print('Error: ${e.message}');
  //     return e.message.toString();
  //   }
  // }

  // static Future<bool> updateDnsSettings(String adapterName, List<String> dnsServers) async {
  //   try {
  //     final bool success = await platform.invokeMethod('updateDnsSettings', {'adapterName': adapterName, 'dnsServers': dnsServers});
  //     return success;
  //   } on PlatformException catch (e) {
  //     print('Error: ${e.message}');
  //     return false;
  //   }
  // }
}
