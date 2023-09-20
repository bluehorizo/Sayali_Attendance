import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googlesheet/model/attendancemodel.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import '../model/approvialmodel.dart';

class AprovelOperation extends ChangeNotifier {
  List<approvalmodel> productList = [];
  late final void Function(String) callback;

  static const String reciptsURL =
      "https://script.google.com/macros/s/AKfycbyFbk3sVIqcBNOMSTzVytOCTPQk07R3R3eIhVw_IvY4_n7Pj3Rtygm6jGenJz4Mt2OHSQ/exec";

  Future<bool> addAprovelSpreadsheet(approvalmodel data) async {
    final url =
        'https://script.google.com/macros/s/AKfycbwkLNmG1Gk40tEpFc-wNUBC-pOm9CeYRQ_v-ruNofP0KB_xOmPmzaZWx4PUN3rkVA1ejQ/execc'; // replace SCRIPT_ID with your actual script ID
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(data.toJson()),
    );
    // recentAdded = data;

    notifyListeners();
    if (response.statusCode == 200) {
      // Successful response

      return true;
    } else {
      // Error occurred

      return false;
    }
  }

  void setOutTime(int index, String selectedTime) {
    productList[index].outTime = selectedTime;
    notifyListeners();
  }

  Future getFromSheet() async {
    var rawData = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbx0aAKlrl6cheyQHa97_LCa9U6RHRiWdoVXsqvCMeAVXE3TfP2-TPLbr-cap39BXhnQ/exec"));

    var jsonProspectList = convert.jsonDecode(rawData.body);

    final List<approvalmodel> tempSevaList = [];
    jsonProspectList.forEach((element) {
      tempSevaList.add(approvalmodel.fromJson(element));
    });

    productList = tempSevaList;

    print("gauarav${tempSevaList.length}");
    notifyListeners();
  }

  Future<void> deleteAcccept(int index) async {

    productList.removeAt(index);
    notifyListeners();

  }



  Future<bool> submitForm(approvalmodel reciptModel,
      AttendanceModel attendanceModel, String day1) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token')!;
      final String designation = prefs.getString('designation')!;
      final String user_identification =
          prefs.getString('user_identification')!;
      final String staffEmail = prefs.getString('userEmail')!;

      final String id = prefs.getString('id')!;
      final String name = prefs.getString('name')!;
      reciptModel.name = name;
      reciptModel.outTime = day1.toString();
      reciptModel.id = attendanceModel.id.toString();
      final bool response = await http
          .get(Uri.parse(reciptsURL + reciptModel.toParams()))
          .then((response) {
        callback(convert.jsonDecode(response.body)['status']);
        return response.isRedirect;
      });
      if (!response) {
        notifyListeners();

        return false;
      }

      productList.add(reciptModel);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
