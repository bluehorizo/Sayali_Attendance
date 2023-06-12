import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:googlesheet/model/diagnosis.dart';
import 'package:googlesheet/model/dropDownList.dart';
import 'package:googlesheet/themes/client_company_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/employeemodel.dart';
import 'gsheetConfiguration.dart';

class DropDownListMasterOperation extends ChangeNotifier {
  List<DropDownListModel> dropDownListData = [];
  var versionName;
  var versionDate;
  var versionLink;
  late final void Function(String) callback;
  String frequency = "1-1-1";
  String method = "Before eating";
  String excersise = "Active neck exercise";
  String quipmentType = "Tens";
  String therapyType = "Advance Physiotherapy Treatment with PEMF";
  static const String URL =
      "https://script.google.com/macros/s/AKfycbzBrzbVC7At5bsMpoL3Z_XmTkipeoE0dPEjt0nvM-2NAWb-pCCvtA976UgsF8zr6SkG/exec";
  static const STATUS_SUCCESS = "SUCCESS";

  void submitForm(DropDownListModel dropDownListModel) async {
    try {
      await http
          .get(Uri.parse(URL + dropDownListModel.toParams()))
          .then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      print(e);
    }
  }

  String setfrequency(String inTimeTypeD) {
    frequency = inTimeTypeD;

    notifyListeners();
    return frequency;
  }

  String settherapyType(String threpyD) {
    therapyType = threpyD;

    notifyListeners();
    return therapyType;
  }

  String setMethod(String methodA) {
    method = methodA;

    notifyListeners();
    return method;
  }

  String setEquipmentType(String threpyD) {
    quipmentType = threpyD;

    notifyListeners();
    return quipmentType;
  }

  String setExcersise(String inTimeTypeD) {
    excersise = inTimeTypeD;

    notifyListeners();
    return frequency;
  }

  List<String> getBranchNameSuggestions() {
    List<DropDownListModel> _dropDownList = [];
    List<String> list = [];
    _dropDownList = dropDownListData;
    _dropDownList.sort((a, b) {
      return a.branch.toLowerCase().compareTo(b.branch.toLowerCase());
    });
    list = _dropDownList.map((e) {
      return e.branch;
    }).toList();
    list.removeWhere((element) => element.isEmpty);
    return list;
  }

  List<String> getBConditionSuggestions() {
    List<DropDownListModel> _dropDownList = [];
    List<String> list = [];
    _dropDownList = dropDownListData;
    _dropDownList.sort((a, b) {
      return a.condition.toLowerCase().compareTo(b.condition.toLowerCase());
    });
    list = _dropDownList.map((e) {
      return e.condition;
    }).toList();
    list.removeWhere((element) => element.isEmpty);
    return list;
  }

  List<String> getFrequencySuggestions() {
    List<DropDownListModel> _dropDownList = [];
    List<String> list = [];
    _dropDownList = dropDownListData;
    _dropDownList.sort((a, b) {
      return a.frequncy.toLowerCase().compareTo(b.frequncy.toLowerCase());
    });
    list = _dropDownList.map((e) {
      return e.frequncy;
    }).toList();
    list.removeWhere((element) => element.isEmpty);
    return list;
  }

  List<String> getMethodSuggestions() {
    List<DropDownListModel> _dropDownList = [];
    List<String> list = [];
    _dropDownList = dropDownListData;
    _dropDownList.sort((a, b) {
      return a.method.toLowerCase().compareTo(b.method.toLowerCase());
    });
    list = _dropDownList.map((e) {
      return e.method;
    }).toList();
    list.removeWhere((element) => element.isEmpty);
    return list;
  }

  List<String> getTherapySuggestions() {
    List<DropDownListModel> _dropDownList = [];
    List<String> list = [];
    _dropDownList = dropDownListData;
    _dropDownList.sort((a, b) {
      return a.therepyType.toLowerCase().compareTo(b.therepyType.toLowerCase());
    });
    list = _dropDownList.map((e) {
      return e.therepyType;
    }).toList();
    list.removeWhere((element) => element.isEmpty);
    return list;
  }

  List<String> getEquipmentSuggestions() {
    List<DropDownListModel> _dropDownList = [];
    List<String> list = [];
    _dropDownList = dropDownListData;
    _dropDownList.sort((a, b) {
      return a.equipment.toLowerCase().compareTo(b.equipment.toLowerCase());
    });
    list = _dropDownList.map((e) {
      return e.equipment;
    }).toList();
    list.removeWhere((element) => element.isEmpty);
    return list;
  }

  List<String> getExcrsiseSuggestions() {
    List<DropDownListModel> _dropDownList = [];
    List<String> list = [];
    _dropDownList = dropDownListData;
    _dropDownList.sort((a, b) {
      return a.excersise.toLowerCase().compareTo(b.excersise.toLowerCase());
    });
    list = _dropDownList.map((e) {
      return e.excersise;
    }).toList();
    list.removeWhere((element) => element.isEmpty);
    return list;
  }

  Future getDropDownListFromSheet() async {
    var rawData = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbyBlJT8xJH9xOQWOaKInlwmsKMtWSiWCnsk5PzHVqopXuuRvKO8fKQwZP913dKkCO44Aw/exec"));
    var jsonProspectList = convert.jsonDecode(rawData.body);
    // prospectList = jsonProspectList.map((json) {
    //   Prospect.fromJson(json);
    // });
    final List<DropDownListModel> tempSevaList = [];
    jsonProspectList.forEach((element) {
      tempSevaList.add(DropDownListModel.fromJson(element));
    });
    dropDownListData = tempSevaList;
    notifyListeners();
  }

  Future<void> getVersionData() async {
    String url =
        'https://script.google.com/macros/s/AKfycbwWeSnjW7XgwG_lKsArGP_TpzK-TJB95bkKpHr-m3VGLE4VwTDBocSNcHVZqT9IN7sX6Q/exec';

    try {
      final response = await http.get(Uri.parse(url));
      print('Application Version : $applicationVersion');

      // Process the data as needed
      var data = json.decode(response.body);
      versionName = data['Version'];
      versionDate = data['Date'];
      versionLink = data['Link'];
    } catch (e) {
      print('Error: $e');
    }
  }
}
