//     final deviceList = deviceListFromJson(jsonString);

import 'dart:convert';

List<DeviceList> deviceListFromJson(String str) =>
    List<DeviceList>.from(json.decode(str).map((x) => DeviceList.fromJson(x)));

String deviceListToJson(List<DeviceList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeviceList {
  DeviceList({
    this.device,
    this.macAddress,
  });

  String device;
  String macAddress;

  factory DeviceList.fromJson(Map<String, dynamic> json) => DeviceList(
        device: json["device"],
        macAddress: json["MAC_address"],
      );

  Map<String, dynamic> toJson() => {
        "device": device,
        "MAC_address": macAddress,
      };
}
