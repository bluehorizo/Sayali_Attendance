import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlesheet/model/employeemodel.dart';
import 'package:googlesheet/model/leaveSummaryModel.dart';
import 'dart:convert' as convert;
import 'package:googlesheet/model/leaveapplymodel.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/attendancemodel.dart';
import 'gsheetConfiguration.dart';
import 'package:http/http.dart' as http;

class LeaveOperations with ChangeNotifier {
  static Worksheet? LeavSheet;
  static List<LeaveApplyModel> leaveapplyData = [];
  late final void Function(String) callback;
  List<LeaveSummaryModel> leaveSummaryList = [];
  List<LeaveApplyModel> leaveApplyList = [];
  List<LeaveApplyModel> leaveApplyActiveList = [];
  int availableCL = 0,
      availableSL = 0,
      availablePL = 0,
      availableMonthlyOff = 0;
  LeaveSummaryModel leaveSummaryModel = LeaveSummaryModel(
      emp_id: "",
      emp_name: "",
      op_bal: "",
      totalCasualLeave: "",
      totalSickLeave: "",
      totalPrivilageLeave: "",
      totalMonthlyOff: "",
      countCasualLeave: "",
      countSickLeave: "",
      countPrivilageLeave: "",
      countMonthlyOff: "",
      addition: "",
      approved: "",
      rejected: "",
      cancelled: "",
      closing_balance: "");
  late List<bool> isSelectedForLeave;
  late List<bool> isSelectedForDays;
  static const String employeeOnlyURL =
      "https://script.google.com/macros/s/AKfycbxDO8cHf3wtskV-9bcJ2NSyWsrdfyGXVkrfTgjL-sHoa8QlXUNGjebg0AXAwAcPiiNh6Q/exec";

  static const String URL =
      "https://script.google.com/macros/s/AKfycbzNU_C8RoZmjj23sGJWl4mPNiUleh-oNOJ3_dcEWnWJbfAFWwtzuFnzIK2nA2kHqpWA0Q/exec";
  void submitForm(LeaveApplyModel leaveApplyModel) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token')!;
      final String designation = prefs.getString('designation')!;
      final String staffEmail = prefs.getString('userEmail')!;
      final String id = prefs.getString('id')!;
      final String name = prefs.getString('name')!;
      leaveApplyModel.emp_name = name;
      leaveApplyModel.emp_id = id;

      await http
          .get(Uri.parse(URL + leaveApplyModel.toParams()))
          .then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      print(e);
    }
  }

  setDate() {
    notifyListeners();
  }

  setLeaveType(int index) {
    isSelectedForLeave = [false, false, false];
    isSelectedForLeave[index] = !isSelectedForLeave[index];
    notifyListeners();
  }

  setDay(int index) {
    isSelectedForDays = [false, false, false];
    isSelectedForDays[index] = !isSelectedForDays[index];
    notifyListeners();
  }

  Future getLeaveSummaryFromSheet(String name, bool isAdmin) async {
    var rawData = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbxCrOfHIPrXrJi3dKkd3irbz-AfcCMeNd3bLwkXA2X0j_DUIxtutm8xByy2JKQ73PcjMw/exec?emp_name=$name&emp_designation=$isAdmin"));
    var jsonProspectList = convert.jsonDecode(rawData.body);

    // prospectList = jsonProspectList.map((json) {
    //   Prospect.fromJson(json);
    // });
    final List<LeaveSummaryModel> tempSevaList = [];
    jsonProspectList.forEach((element) {
      if (isAdmin) {
        tempSevaList.add(LeaveSummaryModel.fromJson(element));
      } else {
        leaveSummaryModel = LeaveSummaryModel.fromJson(element);
        availableCL = int.parse(leaveSummaryModel.totalCasualLeave) -
            int.parse(leaveSummaryModel.countCasualLeave);
        availableSL = int.parse(leaveSummaryModel.totalSickLeave) -
            int.parse(leaveSummaryModel.countSickLeave);
        availablePL = int.parse(leaveSummaryModel.totalPrivilageLeave) -
            int.parse(leaveSummaryModel.countPrivilageLeave);
        availableMonthlyOff = int.parse(leaveSummaryModel.totalMonthlyOff) -
            int.parse(leaveSummaryModel.countMonthlyOff);
      }
    });
    leaveSummaryList = tempSevaList;
    notifyListeners();
  }

  Future getLeaveDataFromSheet(String name, bool isAdmin) async {
    var rawData = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbwsK8Y6V6nj-N59EoWzNhisgNCvgcLOsRoZeRw019dAnbqXNt-poyG52O8DBeM2MDHlJg/exec?emp_name=$name&emp_designation=$isAdmin"));
    var jsonProspectList = convert.jsonDecode(rawData.body);

    // prospectList = jsonProspectList.map((json) {
    //   Prospect.fromJson(json);
    // });

    final List<LeaveApplyModel> tempSevaList = [];
    final List<LeaveApplyModel> tempLeaveActiveList = [];
    jsonProspectList.forEach((element) {
      if ((name == element["emp_name"]) || isAdmin == true) {
        tempSevaList.add(LeaveApplyModel.fromJson(element));
        if (!element["rejected"] && !element["cancelled"]) {
          tempLeaveActiveList.add(LeaveApplyModel.fromJson(element));
        }
      }
    });
    leaveApplyList = tempSevaList;
    leaveApplyActiveList = tempLeaveActiveList;
    leaveApplyActiveList.sort((b, a) {
      return a.id.compareTo(b.id);
    });
    leaveApplyList.sort((b, a) {
      return a.id.compareTo(b.id);
    });
    notifyListeners();
  }

  Future excecuteLeaveOperation(String id, String applicationStatus,bool adminOnly) async {

    var resoense = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbxv3ZuMGnQmwv9k-QFsOCW3Q1TWEbrCnJmcigDJthbJpm6KJy149jSvYk9dkX2PrDNuAw/exec?id=${id}id&applicationStatus=$applicationStatus"));
    if(adminOnly){
      leaveApplyActiveList.removeWhere(
            (element) => element.id == id,
      );
    }
    else{
      leaveApplyList.removeWhere(
            (element) => element.id == id,
      );
    }

    // prospectList = jsonProspectList.map((json) {
    //   Prospect.fromJson(json);
    // });

    notifyListeners();
  }

  Future<void> postListToGoogleScript(LeaveApplyModel list) async {
    final url =
        'https://script.google.com/macros/s/AKfycbyGEj6f7KzJTOJUEEBaSTdNFGPEFa8o3IHshfman12bbks5Ai8K8qPF8BayXIpxK36oWA/exec'; // Replace with your web app URL
    final body = jsonEncode({'list': list});
    final response = await http.post(Uri.parse(url), body: body);
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Failed to post list to Google Script');
    }
  }
}
