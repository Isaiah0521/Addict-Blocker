import 'package:flutter/services.dart';

class VpnServices {
  static const MethodChannel _channel = MethodChannel('vpn_services/channel');

  static Future<void> startVpn() async {
    await _channel.invokeMethod('startVpn');
  }

  static Future<void> blockWebsite(String domain) async {
    await _channel.invokeMethod('blockWebsite', {'domain': domain});
  }

  static Future<void> requestDeviceAdmin() async {
    await _channel.invokeMethod('requestDeviceAdmin');
  }
}
