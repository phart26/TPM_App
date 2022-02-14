import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/models/device_list.dart';
import 'package:tpmapp/models/fetch_token.dart';
import 'package:f_logs/model/flog/flog.dart';

class PreferencesService {
  final SharedPreferences _sharedPreferences;

  PreferencesService(this._sharedPreferences);

  //job started or not
  set isOrderStarted(bool val) {
    _sharedPreferences.setBool("isOrderStarted", val);
  }

  bool get isOrderStarted =>
      _sharedPreferences.getBool("isOrderStarted") ?? false;

  //mode 1- 2-
  set mode(int val) {
    _sharedPreferences.setInt("mode", val);
  }

  int get mode => _sharedPreferences.getInt("mode") ?? 0;

  //mode 1- 2-
  set ncount(int val) {
    _sharedPreferences.setInt("ncount", val);
  }

  int get ncount => _sharedPreferences.getInt("ncount") ?? 0;

  //token store
  set token(String val) {
    _sharedPreferences.setString("token", val);
  }

  String get token => _sharedPreferences.getString("token") ?? "";

  //connected mill
  set millName(String val) {
    _sharedPreferences.setString("millName", val);
  }

  String get millName => _sharedPreferences.getString("millName") ?? "";

  set coilNum(String val) {
    _sharedPreferences.setString("coilNum", val);
  }

  String get coilNum => _sharedPreferences.getString("coilNum") ?? "";

  //token store
  set jobId(String val) {
    _sharedPreferences.setString("jobId", val);
  }

  String get jobId => _sharedPreferences.getString("jobId") ?? "";

  set meshJobPo(String val) {
    _sharedPreferences.setString("meshJobPo", val);
  }

  String get meshJobPo => _sharedPreferences.getString("meshJobPo") ?? "";

  //token store
  set jobData(String val) {
    _sharedPreferences.setString("jobData", val);
  }

  String get jobData => _sharedPreferences.getString("jobData") ?? "";

  set meshData(String val) {
    _sharedPreferences.setString("meshData", val);
  }

  String get meshData => _sharedPreferences.getString("meshData") ?? "";

  set meshJobData(String val) {
    _sharedPreferences.setString("meshJobData", val);
  }

  String get meshJobData => _sharedPreferences.getString("meshJobData") ?? "";

  set geoJobData(String val) {
    _sharedPreferences.setString("geoJobData", val);
  }

  String get geoJobData => _sharedPreferences.getString("geoJobData") ?? "";

  set tubeListSheet(String val) {
    _sharedPreferences.setString("tubeListSheet", val);
  }

  String get tubeListSheet =>
      _sharedPreferences.getString("tubeListSheet") ?? "";

  set jobStarted(String val) {
    _sharedPreferences.setString("jobStarted", val);
  }

  String get jobStarted => _sharedPreferences.getString("jobStarted") ?? "";

  set currentTube(int val) {
    _sharedPreferences.setInt("currentTube", val);
  }

  int get currentTube => _sharedPreferences.getInt("currentTube") ?? 0;

  set currentTubeNo(String val) {
    _sharedPreferences.setString("currentTubeNo", val);
  }

  String get currentTubeNo =>
      _sharedPreferences.getString("currentTubeNo") ?? "0";

  set jobwisetubeDetails(String val) {
    _sharedPreferences.setString("jobwisetubeDetails", val);
  }

  String get jobwisetubeDetails =>
      _sharedPreferences.getString("jobwisetubeDetails") ?? "";

  set deviceList(List<DeviceList> val) {
    _sharedPreferences.setString(
        "deviceList", json.encode(List<DeviceList>.from(val.map((x) => x))));
  }

  List<DeviceList> get deviceList {
    var devices = _sharedPreferences.getString("deviceList");
    print('devices $devices');
    return (devices != null) ? deviceListFromJson(devices) : [];
  }

  set userDetails(FetchToken val) {
    _sharedPreferences.setString("userDetails", json.encode(val));
  }

  FetchToken get userDetails {
    var user = _sharedPreferences.getString("userDetails");
    print('user $user');
    return (user != null) ? FetchToken.fromJson(json.decode(user)) : null;
  }

  BuildContext context;

  void setContext(BuildContext buildContext) {
    print('build context called');
    this.context = buildContext;
  }
}
