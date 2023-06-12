import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:googlesheet/model/diagnosis.dart';
import 'package:googlesheet/model/inTimeEntry.dart';
import 'package:googlesheet/model/patience.dart';
import 'package:googlesheet/model/receipt.dart';
import 'package:googlesheet/model/therepy.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/employeemodel.dart';
import 'gsheetConfiguration.dart';

class AppointementOperation extends ChangeNotifier {
  List<AppointemenetModel> appointmentData = [];
  List<AppointemenetModel> allAppointmentData = [];
  List<AppointemenetModel> currentAppointmentData = [];
  List<AppointemenetModel> waitingData = [];
  List<AppointemenetModel> receiptData = [];
  List<AppointemenetModel> diagnosisData = [];
  List<AppointemenetModel> therapyData = [];
  List<AppointemenetModel> Data = [];
  int index = 0;
  List<AppointemenetModel> appointmentDetailList = [];
  late AppointemenetModel selectedAppointment;

  late final void Function(String) callback;
  String inTimeType = "Diagnosis";
  String processType = "Waiting";
  static const String URL =
      "https://script.google.com/macros/s/AKfycbxMogUeEKZ9Pezings_KfSJItcxBoQ3piekH6EYycBNryM0EaQi4Kug1IAPgqU-0EoB/exec";
  static const String updateSendInn =
      "https://script.google.com/macros/s/AKfycbzhMv7CLpHdGItp6Yvj-jjZ8RTPSYHUSnj9hotSZJCjfMcFxSzScQaRdrKp_HSCbPgj/exec";
  static const STATUS_SUCCESS = "SUCCESS";
  bool isDiagnossis() {
    if (selectedAppointment.id.isEmpty) return true;
    if (selectedAppointment.consult_ther == "Diagnosis") {
      return true;
    } else {
      return false;
    }
  }

  void submitForm(AppointemenetModel appointemenetModel) async {
    try {
      await http
          .get(Uri.parse(URL + appointemenetModel.toParams()))
          .then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      print(e);
    }
  }

  int setIndex(int indexVar) {
    index = indexVar;
    notifyListeners();
    return index;
  }

  void updateIsSendCell(AppointemenetModel appointemenetModel) async {
    try {
      await http
          .get(Uri.parse(updateSendInn + appointemenetModel.toUpdate()))
          .then((response) {
        callback(convert.jsonDecode(response.body)['status']);
        appointmentData.add(appointemenetModel);
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  int getAppointmentId() {
    if (appointmentData.isEmpty) return 1;
    return int.parse(appointmentData.last.id) + 1;
  }

  bool appointmentList() {
    if (allAppointmentData.isEmpty) return false;
    allAppointmentData.map((e) {
      if ((selectedAppointment != e.id) &&
          (selectedAppointment.patientName == e.patientName)) {
        appointmentDetailList.add(e);
      }
    }).toList();
    if (appointmentDetailList.isEmpty) return false;
    return true;
  }

  String setInTime(String inTimeTypeD) {
    inTimeType = inTimeTypeD;

    notifyListeners();
    return inTimeType;
  }

  String setProcess(String inTimeTypeD) {
    processType = inTimeTypeD;
    switch (inTimeTypeD) {
      case "Waiting":
        waitingData = [];
        appointmentData.map((e) {
          if (e.isSend == "false") waitingData.add(e);
        }).toList();
        currentAppointmentData = waitingData;
        break;
      case "Diagnosis":
        diagnosisData = [];

        appointmentData.map((e) {
          if (e.isSend == "true" &&
              e.consult_ther == "Diagnosis" &&
              e.isPaymentDone == "false") diagnosisData.add(e);
        }).toList();
        currentAppointmentData = diagnosisData;
        break;
      case "Therapy":
        therapyData = [];
        appointmentData.map((e) {
          if (e.isSend == "true" &&
              e.consult_ther == "Therapy" &&
              e.isPaymentDone == "false") therapyData.add(e);
        }).toList();
        currentAppointmentData = therapyData;
        break;
      case "Receipts":
        receiptData = [];
        appointmentData.map((e) {
          if (e.isPaymentDone == "true") receiptData.add(e);
        }).toList();
        currentAppointmentData = receiptData;
        break;
    }

    notifyListeners();
    return processType;
  }

  // bool getWaitingList() {
  //   if (appointmentData.isEmpty)
  //     return false;
  //   else {
  //     appointmentData.map((e) {
  //       if (e.isSend == "false") waitingData.add(e);
  //     }).toList();
  //     if (waitingData.isEmpty) {
  //       return false;
  //     } else {
  //       return true;
  //     }
  //   }
  // }

  Future getAppointementFromSheet() async {
    var rawData = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbypYGeNqHN8x7uLWLmNMqozWCvuWYZSh06XVPE6KsKcizj0FU3eC9mABpvv3TlqqXo3/exec"));
    var jsonProspectList = convert.jsonDecode(rawData.body);
    // prospectList = jsonProspectList.map((json) {
    //   Prospect.fromJson(json);
    // });

    final dateformat = new DateFormat('dd-MM-yyyy');
    var todays = dateformat.format(DateTime.now());
    final List<AppointemenetModel> tempSevaList = [];
    final List<AppointemenetModel> tempAllAppointmentList = [];
    jsonProspectList.forEach((element) {
      if (dateformat.format(DateTime.parse(element["inTime"])) == todays) {
        tempSevaList.add(AppointemenetModel.fromJson(element));
      }
      tempAllAppointmentList.add(AppointemenetModel.fromJson(element));
    });
    allAppointmentData = tempAllAppointmentList;
    appointmentData = tempSevaList;

    currentAppointmentData = tempSevaList;
    setProcess("Waiting");
  }
}
