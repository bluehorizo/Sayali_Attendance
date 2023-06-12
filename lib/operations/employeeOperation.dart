import 'package:flutter/cupertino.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/employeemodel.dart';
import 'gsheetConfiguration.dart';

class EmployeeOperation extends ChangeNotifier {
  List<EmployModel> employData = [];
  late final void Function(String) callback;
  static const String URL =
      "https://script.google.com/macros/s/AKfycbxWykkaJpDBxkvFibN-3-t9SZ7yrGSXwl2wzagXJydJE5kw5LGDodrbuUwD0UuEiaTR0w/exec";
  static const STATUS_SUCCESS = "SUCCESS";

  List<EmployModel> taskList = [];
  EmployModel staff = EmployModel(
      id: "0",
      date: "",
      empNumber: "",
      full_name: "",
      designation: "",
      mobile_no: "",
      alternate_no: "",
      email: "",
      gender: "",
      date_of_birth: "",
      address: "",
      pan_card: "",
      aadhar_card: "",
      user_identification: "",
      In_Time_1st: "",
      Out_Time_1st: "",
      In_Time_2nd: "",
      Out_Time_2nd: "",
      total_working_hours: "",
      working_days: "",
      sun_In_Time: "",
      sun_out_Time: "",
      sun_working_hours: "",
      number_of_sunday: "",
      salary: "",
      days: "",
      sal_per_days: "");
  EmployModel isEmployee(String value) {
    staff = EmployModel(
        id: "0",
        date: "",
        empNumber: "",
        full_name: "",
        designation: "",
        mobile_no: "",
        alternate_no: "",
        email: "",
        gender: "",
        date_of_birth: "",
        address: "",
        pan_card: "",
        aadhar_card: "",
        user_identification: "",
        In_Time_1st: "",
        Out_Time_1st: "",
        In_Time_2nd: "",
        Out_Time_2nd: "",
        total_working_hours: "",
        working_days: "",
        sun_In_Time: "",
        sun_out_Time: "",
        sun_working_hours: "",
        number_of_sunday: "",
        salary: "",
        days: "",
        sal_per_days: "");
    employData.map((element) {
      if (element.email == value) {
        staff = element;
      }
    }).toList();
    notifyListeners();
    return staff;
  }

  void submitForm(EmployModel employModel) async {
    try {
      await http.get(Uri.parse(URL + employModel.toParams())).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      print(e);
    }
  }

  Future getEmployeeFromSheet() async {
    var rawData = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbwr4ZdB40AZGVREUMKTqn4828BV2Towlpq9SNBy2TjA6NtVXVGbZT4W2o4qNc1WGJ210w/exec"));
    var jsonProspectList = convert.jsonDecode(rawData.body);
    // prospectList = jsonProspectList.map((json) {
    //   Prospect.fromJson(json);
    // });
    final List<EmployModel> tempSevaList = [];
    jsonProspectList.forEach((element) {
      if(element['number_of_sunday']==true) {
        tempSevaList.add(EmployModel.fromJson(element));
      }
    });
    employData = tempSevaList;
  }
}
