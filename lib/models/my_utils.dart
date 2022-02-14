import 'dart:convert';

import 'package:tpmapp/services/preferences_service.dart';

class MyUtils {
  static String generateTubeNumber(int qty, String jobId, int index) {
    String ret = "";
    print('$jobId  $qty');
    ret = "$jobId-" + index.toString().padLeft(qty.toString().length, "0");
    print('generated number $ret');
    return ret;
  }

  static int calRemainingJob(var data, var details, var form) {
    var jobId = data['formData']['job'];
    int i = details
        .indexWhere((element) => element.jobId == data['formData']['job']);
    int len = 0;
    switch (form) {
      case "dPI":
        len = details[i]
            .dPI
            .tubes
            .where((ele) => ele.isCompleted == false)
            .length;
        break;
      case "iSCs":
        len = details[i]
            .iSCs
            .tubes
            .where((ele) => ele.isCompleted == false)
            .length;
        break;
      case "fIGf":
        len = details[i]
            .fIGf
            .tubes
            .where((ele) => ele.isCompleted == false)
            .length;
        break;
      case "cSCs":
        len = details[i]
            .cSCs
            .tubes
            .where((ele) => ele.isCompleted == false)
            .length;
        break;
      case "gFRI":
        len = details[i]
            .gFRI
            .tubes
            .where((ele) => ele.isCompleted == false)
            .length;
        break;
      case "rSCs":
        len = details[i]
            .rSCs
            .tubes
            .where((ele) => ele.isCompleted == false)
            .length;
        break;
    }
    return len;
  }

  static void updateTubeNumber(
      var details, var data, PreferencesService pref, var form, int qty) {
    var jobId = data['formData']['job'];
    int i = details
        .indexWhere((element) => element.jobId == data['formData']['job']);

//    calRemainingJob(data, details, form);
    int nextInd = 0;
    switch (form) {
      case "dPI":
        details[i].dPI.tubes[pref.currentTube].isCompleted = true;

        pref.jobwisetubeDetails = json.encode(details);
        nextInd = details[i].dPI.tubes.indexWhere(
            (element) => element.isCompleted == false,
            (pref.currentTube == qty - 1) ? 0 : pref.currentTube);
        if (nextInd != -1) {
          pref.currentTube = nextInd;
          pref.currentTubeNo = details[i].dPI.tubes[nextInd].tubeNo;
        } else {}
        break;
      case "iSCs":
        details[i].iSCs.tubes[pref.currentTube].isCompleted = true;

        pref.jobwisetubeDetails = json.encode(details);
        nextInd = details[i].iSCs.tubes.indexWhere(
            (element) => element.isCompleted == false,
            (pref.currentTube == qty - 1) ? 0 : pref.currentTube);
        if (nextInd != -1) {
          pref.currentTube = nextInd;
          pref.currentTubeNo = details[i].iSCs.tubes[nextInd].tubeNo;
        } else {}
        break;
      case "fIGf":
        details[i].fIGf.tubes[pref.currentTube].isCompleted = true;

        pref.jobwisetubeDetails = json.encode(details);
        nextInd = details[i].fIGf.tubes.indexWhere(
            (element) => element.isCompleted == false,
            (pref.currentTube == qty - 1) ? 0 : pref.currentTube);
        if (nextInd != -1) {
          pref.currentTube = nextInd;
          pref.currentTubeNo = details[i].fIGf.tubes[nextInd].tubeNo;
        } else {}
        break;
      case "cSCs":
        details[i].cSCs.tubes[pref.currentTube].isCompleted = true;

        pref.jobwisetubeDetails = json.encode(details);
        nextInd = details[i].cSCs.tubes.indexWhere(
            (element) => element.isCompleted == false,
            (pref.currentTube == qty - 1) ? 0 : pref.currentTube);
        if (nextInd != -1) {
          pref.currentTube = nextInd;
          pref.currentTubeNo = details[i].cSCs.tubes[nextInd].tubeNo;
        } else {}
        break;
      case "gFRI":
        details[i].gFRI.tubes[pref.currentTube].isCompleted = true;

        pref.jobwisetubeDetails = json.encode(details);
        nextInd = details[i].gFRI.tubes.indexWhere(
            (element) => element.isCompleted == false,
            (pref.currentTube == qty - 1) ? 0 : pref.currentTube);
        if (nextInd != -1) {
          pref.currentTube = nextInd;
          pref.currentTubeNo = details[i].gFRI.tubes[nextInd].tubeNo;
        } else {}
        break;
      case "rSCs":
        details[i].rSCs.tubes[pref.currentTube].isCompleted = true;

        pref.jobwisetubeDetails = json.encode(details);
        nextInd = details[i].rSCs.tubes.indexWhere(
            (element) => element.isCompleted == false,
            (pref.currentTube == qty - 1) ? 0 : pref.currentTube);
        if (nextInd != -1) {
          pref.currentTube = nextInd;
          pref.currentTubeNo = details[i].rSCs.tubes[nextInd].tubeNo;
        } else {}
        break;
    }

//    int nextInd = details[i].iSCs.tubes.indexWhere(
//        (element) => element.isCompleted == false,
//        (pref.currentTube == qty - 1) ? 0 : pref.currentTube);
//    if (nextInd != -1) {
//      pref.currentTube = nextInd;
//      pref.currentTubeNo = details[i].iSCs.tubes[nextInd].tubeNo;
//    } else {}

    print('saved called $jobId $i ${pref.currentTube}');
  }
}
