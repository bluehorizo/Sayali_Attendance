import 'package:flutter/cupertino.dart';
import 'package:googlesheet/model/diagnosis.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/employeemodel.dart';
import 'gsheetConfiguration.dart';

class DiagnosisOperation extends ChangeNotifier {
  List<DiagnosisModel> receiptsData = [];
  late final void Function(String) callback;
  int index = 0;
  int currentStep = 0;
  static const String URL =
      "https://script.google.com/macros/s/AKfycbxq0oQ4cOECWdW0Irw3rD1Kk-O99wGZVUA2LtKBTC1FLLJqr6Zp3_r3UhnpEfMIgyR1/exec";
  static const STATUS_SUCCESS = "SUCCESS";
  late DiagnosisModel selected;
  DiagnosisModel? selectDiagnosisData(String diagnosisId) {
    selected = receiptsData.firstWhere((element) {
      return element.id == diagnosisId;
    }, orElse: null);
    if (selected.id.isNotEmpty) {
      notifyListeners();
      return selected;
    } else {
      notifyListeners();
      return null;
    }
  }

  int setIndex(int indexVar) {
    index = indexVar;
    return index;
  }

  void submitForm(DiagnosisModel diagnosisModel) async {
    try {
      await http
          .get(Uri.parse(URL + diagnosisModel.toParams()))
          .then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      print(e);
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
    if (receiptsData.isEmpty) {
      notifyListeners();
      return 1;
    } else {
      notifyListeners();
      return int.parse(receiptsData.last.id) + 1;
    }
  }

  cancel() {
    currentStep > 0 ? currentStep -= 1 : null;
    notifyListeners();
  }

  Future getDiagnosisFromSheet() async {
    var rawData = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbzxvPrcXtK7_7ZxJw0ZBeo9Tn8jYH8nUXepNou2_1SpT1OQ_LmJXXSnyx7NY0fa4tXr/exec"));
    var jsonProspectList = convert.jsonDecode(rawData.body);
    // prospectList = jsonProspectList.map((json) {
    //   Prospect.fromJson(json);
    // });
    final List<DiagnosisModel> tempSevaList = [];
    jsonProspectList.forEach((element) {
      tempSevaList.add(DiagnosisModel.fromJson(element));
    });
    receiptsData = tempSevaList;
  }
}
