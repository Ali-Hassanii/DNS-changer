import 'dart:developer';
import 'dart:io' show NetworkInterface, Platform, Process, ProcessResult;

class AdapterManager {
  Future<String> activeInterface() async {
    if (Platform.isWindows) {
      final List interfaces = await NetworkInterface.list();
      for (NetworkInterface interface in interfaces) {
        String address = interface.addresses.first.address;
        if (address.contains("192.168") && !address.endsWith(".1")) {
          return interface.name;
        }
      }
    }
    return "failed";
  }

  Future<bool> setDns(String interface, List<String> hosts) async {
    if (hosts.length > 2) {
      return false;
    } else {
      for (String host in hosts) {
        final ProcessResult result = await Process.run(
          "netsh",
          [
            "interface",
            "ipv4",
            "add",
            "dnsservers",
            '"$interface"',
            "address=$host",
          ],
        );
        if (result.exitCode == 0) {
          log("Success", name: "SetDNS");
        } else {
          log("Failed", name: "SetDNS");
          return false;
        }
      }
      return true;
    }
  }

  Future<bool> resetDns(String interface) async {
    ProcessResult result = await Process.run("netsh", [
      "interface",
      "ipv4",
      "set",
      "dns",
      '"$interface"',
      "source=dhcp",
    ]);
    if (result.exitCode == 0) {
      log("Success", name: "ResetDNS");
      return true;
    } else {
      log("Failed", name: "ResetDNS");
      return false;
    }
  }

  Future<bool> flushDns() async {
    ProcessResult result = await Process.run("ipconfig", ["/flushdns"]);
    if (result.exitCode == 0) {
      log("Success", name: "FlushDNS");
      return true;
    } else {
      log("Failed", name: "FlushDNS");
      return false;
    }
  }
}
