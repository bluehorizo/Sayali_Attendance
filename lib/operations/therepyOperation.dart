import 'package:flutter/cupertino.dart';
import 'package:googlesheet/model/patience.dart';
import 'package:googlesheet/model/receipt.dart';
import 'package:googlesheet/model/therepy.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/employeemodel.dart';
import 'gsheetConfiguration.dart';

class TherepyOperation extends ChangeNotifier {
  List<Therepy> receiptsData = [];
  late final void Function(String) callback;
  int index=0;
  static const String URL =
      "https://script.google.com/macros/s/AKfycbxb0wn7kbP2VM2JbSwRTZeOfkGCVB7ytufU5-VCHsZXGzCnPiq_KyvwaxxmOcXlhKe7/exec";
  static const STATUS_SUCCESS = "SUCCESS";
  late Therepy selectedTherapy;

  Therepy? selectTherapyData(String diagnosisId) {
    selectedTherapy = receiptsData.firstWhere((element) {
      return element.id == diagnosisId;
    }, orElse: null);
    if (selectedTherapy.id.isNotEmpty) {
      notifyListeners();
      return selectedTherapy;
    } else {
      return null;
    }
  }

  void submitForm(Therepy therepyModel) async {
    try {
      await http.get(Uri.parse(URL + therepyModel.toParams())).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      print(e);
    }
  }

  int getTherapyId() {
    if (receiptsData.isEmpty) {
      notifyListeners();
      return 1;
    } else {
      notifyListeners();
      return int.parse(receiptsData.last.id) + 1;
    }
  }

  Future getTherepyFromSheet() async {
    var rawData = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbx_BpHc-ZfqzovRlI_prkbdQiIAm9k4YQm7tLbPNU7n9r0ybsCyc9h-0npF6CFPe33N/exec"));
    var jsonProspectList = convert.jsonDecode(rawData.body);
    // prospectList = jsonProspectList.map((json) {
    //   Prospect.fromJson(json);
    // });
    final List<Therepy> tempSevaList = [];
    jsonProspectList.forEach((element) {
      tempSevaList.add(Therepy.fromJson(element));
    });
    receiptsData = tempSevaList;
  }
}
