import 'dart:convert';

import 'package:platform_device_id/platform_device_id.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:tpmapp/models/device_list.dart';
import 'package:tpmapp/models/fetch_token.dart';

import 'preferences_service.dart';

class APICall {
  static String baseURL = "http://198.71.55.128/";
  var client = http.Client();

 // static String baseURL = 'http://192.168.1.115/';
  getMillList(PreferencesService pref) async {
    String device_id = await PlatformDeviceId.getDeviceId;

    Response response = await client.get(Uri.parse(baseURL + "TPM_Forms_Test/API/mac_address_add.php"), headers: {
      "Accept": "application/json",
    });

    print('response from the getMillList ${response.body}');
    final deviceList = deviceListFromJson(response.body);
    int index =
        deviceList.indexWhere((element) => (element.macAddress == device_id));
    if (index != -1) pref.millName = deviceList[index].device;
    pref.deviceList = deviceList;
  }

  setDeviceMAC(PreferencesService pref, String mill) async {

    String device_id = await PlatformDeviceId.getDeviceId;

    String path = 'TPM_Forms_Test/API/mac_address_add.php?device=' + mill + '&MAC_address=' + device_id;
    Response response = await client.get(Uri.parse(baseURL + path), headers: {
      "Accept": "application/json",
    });
    pref.millName = mill;
    print('response from the setDeviceMAC ${response.body}');
    return json.decode(response.body);
  }

  getJSONToken(PreferencesService pref, String userid) async {
    if (userid == "") userid = "1";
    try {

      String path = "TPM_Forms_Test/API/createJWT.php?userID=$userid";
      Response response = await client.get(Uri.parse(baseURL + path), headers: {
        "Accept": "application/json",
      });

      print('response from the getJSONToken ${response.body} ${response.headers} ');
      var res = jsonDecode( response.body );
      if (res == null || res.length == 0){
        res = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJsb2NhbGhvc3QiLCJpYXQiOjE1OTc4MzE0OTAsIm5iZiI6MTU5NzgzMTQ5MCwiYXVkIjoibXl1c2VycyIsInVzZXJfZGF0YSI6eyJ1c2VybmFtZSI6IlByZXN0b24iLCJwYXNzd29yZCI6IkhhcnRwcmUxMyJ9fQ.MuIJ9S0rGpdMEs3w8UYCr98c-AqaKpgnYovubl52gEmPgJ08vMSBV1kdKprNLYIzEwU2M3uOoMaCW27zflmbCg";
      }else if (!response.body.contains("User not Found!")) {

        final fetchToken = fetchTokenFromJson(response.body);
        await deviceInfo(fetchToken.token);
        pref.token = fetchToken.token;
        pref.userDetails = fetchToken;
      }

    } catch (e) {
      print(' exception on getJSONToken xxx $e');
    }
  }

  deviceInfo(String token) async {
    try {
      String device_id = await PlatformDeviceId.getDeviceId;

      print(
          "${APICall.baseURL + 'TPM_Forms_Test/API/millToken.php?token=$token&station=$device_id'}");

      String path = "TPM_Forms_Test/API/millToken.php?token=$token&station=$device_id";
      Response response = await client.get(Uri.parse(baseURL + path), headers: {
        "Accept": "application/json",
      });
      print(
          'response from the deviceInfo ${response.body} ${response.headers} ');
    } catch (e) {
      print(' exception on deviceInfo');
    }
  }

  notifyMe(String token) async {
    try {
      print("${APICall.baseURL + 'test_notification/index.php?id=$token'}");
      Response response =
          await get( Uri.http(baseURL, 'test_notification/index.php?id=$token'));
      print('response from the notifyMe ${response.body} ${response.headers} ');
    } catch (e) {
      print(' exception on getJSONToken');
    }
  }

  //get details for mill user job
  getJobDetails(PreferencesService pref) async {
    try {
      String device_id = await PlatformDeviceId.getDeviceId;
      if (pref.token == "") await getJSONToken(pref, "");

      String path = "TPM_Forms_Test/API/jobReturn.php?userToken=${pref.token}&mac_add=$device_id";
      print(Uri.parse(baseURL + path));

      Response response = await client.get(Uri.parse(baseURL + path), headers: {
        "Accept": "application/json",
      });
      print('response from the getJobDetails ${response.body} ${response.headers} ');
      var res = jsonDecode( response.body );
      return res["body"];
    } catch (e) {
      print('exception on getData $e');
    }
  }

  getJobDetailsStamping(PreferencesService pref) async {
    try {
      String device_id = await PlatformDeviceId.getDeviceId;
      if (pref.token == "") await getJSONToken(pref, "");

      String path = "TPM_Forms_Test/API/jobReturnStamping.php?userToken=${pref.token}&mac_add=$device_id";
      Response response = await client.get(Uri.parse(baseURL + path), headers: {
        "Accept": "application/json",
      });
      print('response from the getJobDetailsStamping ${response.body} ${response.headers} ');
      var res = response.body;
      res = (res.split("[body] => "))[1];
      res = (res.split(")"))[0];
      return json.decode(res);
    } catch (e) {
      print('exception on getData $e');
    }
  }

  getJobsStamping(PreferencesService pref) async {
    try {
      if (pref.token == "") await getJSONToken(pref, "");

      String path = "TPM_Forms_Test/API/getStampJobs.php?userToken=${pref.token}";
      Response response = await client.get(Uri.parse(baseURL + path), headers: {
        "Accept": "application/json",
      });

      var res = response.body;
      res = (res.split("[body] => "))[1];
      res = (res.split(")"))[0];
      pref.jobData = res;
    } catch (e) {
      print('exception on getJobsStamping $e');
    }
  }

  getCoilsStamp(PreferencesService pref) async {
    try {
      if (pref.token == "") await getJSONToken(pref, "");

      String path = "TPM_Forms_Test/API/getCoilsStamp.php?userToken=${pref.token}&job=${pref.jobId}";
      Response response = await client.get(Uri.parse(baseURL + path), headers: {
        "Accept": "application/json",
      });
      print(
          'response from the getJobsStamping ${response.body} ${response.headers} ');
      var res = response.body;
      res = (res.split("[body] => "))[1];
      res = (res.split(")"))[0];
      pref.jobData = res;
    } catch (e) {
      print('exception on getJobsStamping $e');
    }
  }

  getData(PreferencesService pref) async {
    try {
      if (pref.token == "") await getJSONToken(pref, "");
      if (pref.jobId == "") pref.jobId = '7791';
      print(APICall.baseURL +
          'TPM_Forms_Test/API/order_json_output.php?page1=tube_mill_setup&page3=worksheet&page4=cutoff_station_check_sheet&page5=geo_form_ring_concentric_inspection&page6=geo_form_ring_inspection&page7=inspection_rpt&page8=ring_station_check_list&page9=welding_station_check_list&page10=dp_inspection&page11=Mill_station_first_part&page12=first_part_drift_confirmation&page13=final_inspection_geo_form&userToken=${pref.token}&job=${pref.jobId}');

      String path = "TPM_Forms_Test/API/order_json_output.php?page1=tube_mill_setup&page3=worksheet&page4=cutoff_station_check_sheet&page5=geo_form_ring_concentric_inspection&page6=geo_form_ring_inspection&page7=inspection_rpt&page8=ring_station_check_list&page9=welding_station_check_list&page10=dp_inspection&page11=Mill_station_first_part&page12=first_part_drift_confirmation&page13=final_inspection_geo_form&page14=alloc&page15=alloc_mesh&userToken=${pref.token}&job=${pref.jobId}";
      Response response = await client.get(Uri.parse(baseURL + path), headers: {
        "Accept": "application/json",
      });
      print('response from the getData order_json ${response.body} ${response.headers} ');
      var res = jsonDecode(response.body);
      pref.jobData = jsonEncode(res['body']);
    } catch (e) {
      print('exception on getData $e');
    }
  }

  getDataStamping(PreferencesService pref) async {
    try {
      print(APICall.baseURL + 'TPM_Forms_Test/API/getStampingJobData.php?userToken=${pref.token}&job=${pref.jobId}');

      String path = "TPM_Forms_Test/API/getStampingJobData.php?userToken=${pref.token}&job=${pref.jobId}";
      Response response = await client.get(Uri.parse(baseURL + path), headers: {
        "Accept": "application/json",
      });
      print('response from the getData ${response.body} ${response.headers} ');
      var res = response.body;
      res = (res.split("[body] => "))[1];
      res = (res.split(")"))[0];
      debugPrint('after process res $res', wrapWidth: 4000);
      pref.jobData = res;
    } catch (e) {
      print('exception on getData $e');
    }
  }

  getGeoJobData(PreferencesService pref) async {
    try {
      if (pref.token == "") await getJSONToken(pref, "");

      String path = "TPM_Forms_Test/API/geoJobs.php?userToken=${pref.token}";
      Response response = await client.get(Uri.parse(baseURL + path), headers: {
        "Accept": "application/json",
      });
      print('response from the getData ${response.body} ${response.headers} ');
      var res = response.body;
      res = (res.split("[body] => "))[1];
      res = (res.split(")"))[0];
      // debugPrint('after process res $res', wrapWidth: 4000);
      pref.geoJobData = res;
    } catch (e) {
      print('exception on getData $e');
    }
  }

  getGeoTubes(PreferencesService pref, String sheet) async {
    try {
      if (pref.token == "") await getJSONToken(pref, "");

      String path = "TPM_Forms_Test/API/geoTubes.php?userToken=${pref.token}&sheet=${sheet}&job=${pref.jobId}";
      Response response = await client.get(Uri.parse(baseURL + path), headers: {
        "Accept": "application/json",
      });
      print('response from the getData ${response.body} ${response.headers} ');
      var res = response.body;
      res = (res.split("[body] => "))[1];
      res = (res.split(")"))[0];
      // debugPrint('after process res $res', wrapWidth: 4000);
      return json.decode(res);
    } catch (e) {
      print('exception on getData $e');
    }
  }

  getMeshJobData(PreferencesService pref) async {
    try {
      if (pref.token == "") await getJSONToken(pref, "");

      String path = "TPM_Forms_Test/API/meshJobs.php?userToken=${pref.token}";
      Response response = await client.get(Uri.parse(baseURL + path), headers: {
        "Accept": "application/json",
      });
      print('response from the getData ${response.body} ${response.headers} ');
      var res = response.body;
      res = (res.split("[body] => "))[1];
      res = (res.split(")"))[0];
      // debugPrint('after process res $res', wrapWidth: 4000);
      pref.meshJobData = res;
    } catch (e) {
      print('exception on getData $e');
    }
  }

  getMeshData(PreferencesService pref) async {
    try {
      if (pref.token == "") await getJSONToken(pref, "");

      String path = "TPM_Forms_Test/API/getMeshCoil.php?userToken=${pref.token}&po=${pref.meshJobPo}";
      Response response = await client.get(Uri.parse(baseURL + path), headers: {
        "Accept": "application/json",
      });
      var res = response.body;
      res = (res.split("[body] => "))[1];
      res = (res.split(")"))[0];
      pref.meshData = res;
      debugPrint('after process res ${pref.meshData}', wrapWidth: 4000);
    } catch (e) {
      print('exception on getData $e');
    }
  }

  postTestResults(PreferencesService pref) async {
    Map<String, dynamic> map = {
      "testData": {
        "bend_result": "P",
        "drift_test": 1,
        "drift_result": "P",
        "job": "${pref.jobId}"
      }
    };
    try {
      print('postTestResults $map ${jsonEncode(map)}');

      String path = "TPM_Forms_Test/API/bend_drift.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));
      print('postTestResults ${response.body}');
    } catch (e) {
      print('exception on post Test Results $e');
    }
  }

  postScarp(PreferencesService pref, String reason, String coil, String length, String millOrInsp, {String millData = ""}) async {
      Map<String, dynamic> map = {
        "scrapData": {
          "tube_id": "${pref.currentTubeNo}",
          "job": "${pref.jobId}",
          "reason": '$reason',
          "coil": '$coil',
          "tube_length": '$length',
          "millOrInsp": '$millOrInsp',
          "millReadings": millData
        }
      };
    try {
      print('postScarp $map ${jsonEncode(map)}');

      String path = "TPM_Forms_Test/API/scrap.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));

      print('postScarp ${response.body}');

    } catch (e) {
      print('exception on  postScarp $e');
    }
  }

  postBadStamp(PreferencesService pref, String currentCycle, String reason,
      String coil, String length) async {
    Map<String, dynamic> map = {
      "badStampData": {
        "cycle_id": '$currentCycle',
        "job": "${pref.jobId}",
        "reason": '$reason',
        "coil": '$coil',
        "length": '$length'
      }
    };
    try {
      print('postScarp $map ${jsonEncode(map)}');

      String path = "TPM_Forms_Test/API/badStamp.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));

      print('postBadStamp ${response.body}');

    } catch (e) {
      print('exception on  postBadStamp $e');
    }
  }

  postEndCoilStamping(Map map) async {
    try {
      print('postEndCoil $map ${jsonEncode(map)}');

      String path = "TPM_Forms_Test/API/endCoilStamping.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));
      print('postEndCoil ${response.body}');

    } catch (e) {
      print('exception on  postEndCoil $e');
    }
  }

  postCoilCheckIn(Map map) async {
    try {
      print('postCoilCheckIn $map ${jsonEncode(map)}');
      // Response response = await post(
      //     Uri.http(baseURL, "TPM_Forms_Test/API/coilCheckIn.php"),
      //   body: json.encode(map),
      //   headers: {"Content-Type": "application/json"},
      // );

      String path = "TPM_Forms_Test/API/coilCheckIn.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));

      print('postCoilCheckIn ${response.body}');

    } catch (e) {
      print('exception on  postCoilCheckIn $e');
    }
  }

  postWeight(PreferencesService pref, String weight, String coil) async {
    Map<String, dynamic> map = {
      "weightData": {
        "job": "${pref.jobId}",
        "weight": '$weight',
        "coil": '$coil'
      }
    };
    try {
      // Response response = await post(
      //     Uri.http(baseURL, "TPM_Forms_Test/API/updateWeight.php"),
      //   body: json.encode(map),
      //   headers: {"Content-Type": "application/json"},
      // );

      String path = "TPM_Forms_Test/API/updateWeight.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));

      print('postCoilCheckIn ${response.body}');

    } catch (e) {
      print('exception on  postScarp $e');
    }
  }

  postTubeData(Map map) async {
    try {
      print('postTubeData $map ${jsonEncode(map)}');

      String path = "TPM_Forms_Test/API/tube_data.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: { "Accept": "application/json" },
          body: json.encode(map));

      print('postTubeData ${response.body}');

      return json.decode(response.body);
    } catch (e) {
      print('exception on  postScarp $e');
    }
  }

  postCycleData(Map map) async {
    try {
      // Response response = await post(
      //     Uri.http(baseURL, "TPM_Forms_Test/API/cycle_data.php"),
      //   body: json.encode(map),
      //   headers: {"Content-Type": "application/json"},
      // );

      String path = "TPM_Forms_Test/API/cycle_data.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));
      print('postTubeData ${response.body}');
    } catch (e) {
      print('exception on postCycle $e');
    }
  }

  postSetupOp(Map map) async {
    try {
      // Response response = await post(
      //     Uri.http(baseURL, "TPM_Forms_Test/API/setupOp.php"),
      //   body: json.encode(map),
      //   headers: {"Content-Type": "application/json"},
      // );
      String path = "TPM_Forms_Test/API/setupOp.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));
      print('postTubeData ${response.body}');
    } catch (e) {
      print('exception on postCycle $e');
    }
  }

  postMaterialData(Map map) async {
    try {
      print('postTubeData $map ${jsonEncode(map)}');
      // Response response = await post(
      //     Uri.http(baseURL, "TPM_Forms_Test/API/coilDeallocation.php"),
      //   body: json.encode(map),
      //   headers: {"Content-Type": "application/json"},
      // );
      String path = "TPM_Forms_Test/API/coilDeallocation.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));
      print('postTubeData ${response.body}');
    } catch (e) {
      print('exception on  postScarp $e');
    }
  }

  postMeshData(Map map) async {
    try {
      print('postMeshData $map ${jsonEncode(map)}');
      // Response response = await post(
      //     Uri.http(baseURL, "TPM_Forms_Test/API/meshData.php"),
      //   body: json.encode(map),
      //   headers: {"Content-Type": "application/json"},
      // );
      String path = "TPM_Forms_Test/API/meshData.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));
      print('postMeshData ${response.body}');
    } catch (e) {
      print('exception on  postScarp $e');
    }
  }

  postStartJob(PreferencesService pref, String typeJob) async {
    Map<String, dynamic> map = {
      "startData": {"job": "${pref.jobId}", "type": "$typeJob"}
    };
    try {
      // Response response = await post(
      //     Uri.http(baseURL, "TPM_Forms_Test/API/startJob.php"),
      //   body: json.encode(map),
      //   headers: {"Content-Type": "application/json"},
      // );
      String path = "TPM_Forms_Test/API/startJob.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));
    } catch (e) {
      print('exception on start job $e');
    }
  }

  postEndJob(Map map) async {
    try {
      // Response response = await post(
      //     Uri.http(baseURL, "TPM_Forms_Test/API/endOfJob.php"),
      //   body: json.encode(map),
      //   headers: {"Content-Type": "application/json"},
      // );
      String path = "TPM_Forms_Test/API/endOfJob.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));
    } catch (e) {}
  }

  endJobStamping(PreferencesService pref) async {
    Map<String, dynamic> map = {
      "endJobData": {"job": "${pref.jobId}"}
    };
    try {
      // Response response = await post(
      //     Uri.http(baseURL, "TPM_Forms_Test/API/endJobStamping.php"),
      //   body: json.encode(map),
      //   headers: {"Content-Type": "application/json"},
      // );
      String path = "TPM_Forms_Test/API/endJobStamping.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));
    } catch (e) {}
  }

  postEndMesh(Map map) async {
    try {
      // Response response = await post(
      //     Uri.http(baseURL, "TPM_Forms_Test/API/endMesh.php"),
      //   body: json.encode(map),
      //   headers: {"Content-Type": "application/json"},
      // );
      String path = "TPM_Forms_Test/API/endMesh.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));
    } catch (e) {}
  }

  postDimData(Map map) async {
    try {
      print('postTubeData $map ${jsonEncode(map)}');
      // Response response = await post(
      //     Uri.http(baseURL, "TPM_Forms_Test/API/dimStuff.php"),
      //   body: json.encode(map),
      //   headers: {"Content-Type": "application/json"},
      // );
      String path = "TPM_Forms_Test/API/dimStuff.php";
      Response response = await client.post(Uri.parse(baseURL + path),
          headers: {
            "Accept": "application/json",
          },
          body: json.encode(map));
    } catch (e) {
      print('exception on  postScarp $e');
    }
  }
}
