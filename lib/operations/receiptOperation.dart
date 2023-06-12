import 'package:flutter/cupertino.dart';
import 'package:googlesheet/model/patience.dart';
import 'package:googlesheet/model/receipt.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/employeemodel.dart';
import 'gsheetConfiguration.dart';

class RceiptOperation extends ChangeNotifier {
  List<ReceiptModel> receiptsData = [];
  String modePayment = 'Cash';
  String therepyOrd = 'Diagnosis';
  final void Function(String) callback = (d) {};
  static const String URL =
      "https://script.google.com/macros/s/AKfycbyBYNc21Bd9qrWmMbbfpSWLClJj3qlv1lctWmuyeGwVB190Hy-k3y4wjFIQymuHg78h/exec";
  static const STATUS_SUCCESS = "SUCCESS";
  int getId() {
    return int.parse(receiptsData.first.id) + 1;
  }

  void submitForm(ReceiptModel employModel) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token')!;
      final String designation = prefs.getString('designation')!;
      final String user_identification =
          prefs.getString('user_identification')!;
      final String name = prefs.getString('name')!;
      final String staffEmail = prefs.getString('userEmail')!;
      employModel.user_id = staffEmail;
      employModel.dignosisId = name;
      await http.get(Uri.parse(URL + employModel.toParams())).then((response) {
        employModel.id = getId.toString();
        receiptsData.add(employModel);
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      print(e);
    }
  }

  setPaymentMode(value) {
    modePayment = value;
    notifyListeners();
  }

  List<String> getPatientNameSuggestions() {
    receiptsData.sort((a, b) {
      return a.petientName.toLowerCase().compareTo(b.petientName.toLowerCase());
    });
    final list = receiptsData.map((e) {
      return e.petientName;
    }).toList();
    List<String> myNewList = list.toSet().toList();

    return myNewList;
  }

  setTherapyMode(value) {
    therepyOrd = value;
    notifyListeners();
  }

  Future getReceiptFromSheet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final String designation = prefs.getString('designation')!;
    final String user_identification = prefs.getString('user_identification')!;
    final String staffEmail = prefs.getString('userEmail')!;
    var rawData = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbwlM9k29pYOW2AGp1MhVqIgjBC7PsK_CWyyxYJNUVS-wa9OwekpW7f7hTkL3aUXKQkp/exec"));
    var jsonProspectList = convert.jsonDecode(rawData.body);
    // prospectList = jsonProspectList.map((json) {
    //   Prospect.fromJson(json);
    // });
    final List<ReceiptModel> tempSevaList = [];
    jsonProspectList.forEach((element) {
      tempSevaList.add(ReceiptModel.fromJson(element));
    });
    receiptsData = tempSevaList;
    receiptsData.sort((b, a) {
      return a.date.compareTo(b.date);
    });
    print(receiptsData.length);
    notifyListeners();
  }
}
