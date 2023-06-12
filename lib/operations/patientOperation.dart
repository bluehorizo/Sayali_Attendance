import 'package:flutter/cupertino.dart';
import 'package:googlesheet/model/patience.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/employeemodel.dart';
import 'gsheetConfiguration.dart';

class PatientOperation extends ChangeNotifier {
  List<PatientModel> patientData = [];
  late final void Function(String) callback;
  int currentStep = 0;
  PatientModel selectedPatientData = PatientModel(
      id: "",
      patient_ID: "",
      date: "",
      patient_name: "",
      branch_name: "",
      patient_mobile_number: "",
      email: "",
      alergies: "",
      preExistingDecease: "",
      patient_photo: "",
      patientDOB: "",
      age: "",
      patient_gender: "",
      emerg_contact_person: "",
      emerg_mobile_number: "",
      patient_weight_kg: "",
      height: "",
      patient_adhaar_number: "",
      patient_PAN: "",
      user_identification: "",
      userEmailId: "");
  static const String URL =
      "https://script.google.com/macros/s/AKfycbzU0PJdmFKl1xld7Oh0bNqCx2XPoE4IAI8QhoS7BCDDJ5oL2F_PKl85jzqFzBHApVDODw/exec";
  static const STATUS_SUCCESS = "SUCCESS";

  void submitForm(PatientModel employModel) async {
    try {

      employModel.date = DateTime.now().toString();
      await http.get(Uri.parse(URL + employModel.toParams())).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      print(e);
    }
  }

  bool selectPatientData(String patientName) {
    selectedPatientData = patientData.firstWhere((element) {
      return element.patient_name == patientName;
    }, orElse: null);
    if (selectedPatientData != null) {
      return true;
    } else {
      return false;
    }
  }

  bool duplicateEntry(String name) {
    return patientData.any(
        (element) => element.patient_name.toLowerCase() == name.toLowerCase());
  }

  String getId() {
    if (patientData.last.id.isEmpty) {
      return "0";
    } else {
      return (int.parse(patientData.last.id) + 1).toString();
    }
  }

  tapped(int step) {
    currentStep = step;
    notifyListeners();
  }

  continued() {
    currentStep < 2 ? currentStep += 1 : null;
    notifyListeners();
  }

  int getPatientId() {
    return int.parse(patientData.last.id) + 1;
  }

  cancel() {
    currentStep > 0 ? currentStep -= 1 : null;
    notifyListeners();
  }

  List<String> getBranchNameSuggestions() {
    List<PatientModel> _dropDownList = [];
    List<String> list = [];
    _dropDownList = patientData;
    _dropDownList.sort((a, b) {
      return a.patient_name
          .toLowerCase()
          .compareTo(b.patient_name.toLowerCase());
    });
    list = _dropDownList.map((e) {
      return e.patient_name;
    }).toList();
    list.removeWhere((element) => element.isEmpty);
    return list;
  }

  Future getPatientFromSheet() async {
    var rawData = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbzxEq5AtmpZ1phAlJSKF2MsU6wbJrVthpb1yfCPuthcTdoQvtL0J2pwdcyXP0ncghYOog/exec"));
    var jsonProspectList = convert.jsonDecode(rawData.body);
    // prospectList = jsonProspectList.map((json) {
    //   Prospect.fromJson(json);
    // });
    final List<PatientModel> tempSevaList = [];
    jsonProspectList.forEach((element) {
      tempSevaList.add(PatientModel.fromJson(element));
    });
    patientData = tempSevaList;
    print(patientData.length);
    notifyListeners();
  }
}
