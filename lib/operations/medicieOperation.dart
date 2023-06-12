import 'package:flutter/cupertino.dart';
import 'package:googlesheet/model/medicine.dart';
import 'package:googlesheet/model/patience.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/employeemodel.dart';
import 'gsheetConfiguration.dart';

class MedicineOperation extends ChangeNotifier {
  List<MedicineModel> medicineData = [];
  late final void Function(String) callback;
  static const String URL =
      "https://script.google.com/macros/s/AKfycbwbHjVzuimgEhjsppfsieifNQZLUg6Uj48rGZL3BBG-0418rQBWha3Wl_ouj71DYb8Y/exec";
  static const STATUS_SUCCESS = "SUCCESS";

  void submitForm(MedicineModel medicinemodel) async {
    try {
      await http
          .get(Uri.parse(URL + medicinemodel.toParams()))
          .then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      print(e);
    }
  }

  Future getMedicineFromSheet() async {
    var rawData = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycby-DavUWf1oeBrGCbD-wBVUE2kfWZ1LFkV86AQHOi6pFbHjiX8tH2p-cYSzLtBWf7YG/exec"));
    var jsonProspectList = convert.jsonDecode(rawData.body);
    // prospectList = jsonProspectList.map((json) {
    //   Prospect.fromJson(json);
    // });
    final List<MedicineModel> tempSevaList = [];
    jsonProspectList.forEach((element) {
      tempSevaList.add(MedicineModel.fromJson(element));
    });
    medicineData = tempSevaList;
  }
}
