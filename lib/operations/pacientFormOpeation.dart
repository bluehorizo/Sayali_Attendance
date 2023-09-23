import 'dart:convert' as convert;
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googlesheet/model/patience.dart';
import 'package:googlesheet/model/receipt.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/employeemodel.dart';
import '../model/patientReport.dart';
import 'gsheetConfiguration.dart';

class PacientForamOperation extends ChangeNotifier {
  List<PatientReportModel> receiptsformData = [];
  String URLPost =
      'https://script.google.com/macros/s/AKfycbw-26qgHMfV2UCTYMZqDpXEEjlIDnNRXxkrjDkBdwVOMvgekKiRFPICGtWvT2aectL-4w/exec';
  late final void Function(String) callback;

  static const String URL =
      "https://script.google.com/macros/s/AKfycby0fxywOGDCvvt_0etLmoMhZ_i-g8ILGKM2Fw_bChe4qz3GxtrySvAE58jwAKsg4T38yA/exec";

  Future<bool> submitForm(PatientReportModel patientReportModel) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token')!;
      final String designation = prefs.getString('designation')!;
      final String user_identification = prefs.getString('name')!;
      patientReportModel.user_names = user_identification;
      final bool response = await http
          .get(Uri.parse(URL + patientReportModel.toParams()))
          .then((response) {
        callback(convert.jsonDecode(response.body)['status']);
        return response.isRedirect;
      });
      if (!response) {
        notifyListeners();

        return false;
      }
      receiptsformData.add(patientReportModel);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addPatientReportSpreadsheet(PatientReportModel data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String user_identification = prefs.getString('name')!;
    data.user_names = user_identification;
    final response = await http.post(
      Uri.parse(URLPost),
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

  String formatDate(String datetimeString) {
    final formatter = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.parse(datetimeString);
    return formatter.format(dateTime);
  }

  Future getpatientMonthlyList(DateTime selectedDate) async {
    List<PatientReportModel> filteredData = [];
    receiptsformData.map((receipt) {
      if (DateTime.parse(receipt.date).month == selectedDate.month &&
          DateTime.parse(receipt.date).year == selectedDate.year) {
        print("1234567 ${receipt.date}");
        filteredData.add(receipt);
        print(filteredData);

      }
    }).toList();
    receiptsformData=filteredData;
    notifyListeners();
  }

  // Function to show the alert dialog
  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Data Saved'),
          content: Text('Your data has been saved successfully.'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future getdatafromPacientReport() async {
    var rawData = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbwzTvNW-q2bz6GGwWiWmG4jZo5fSd6eEQYQeyLEFn5_uwmdwUTNa9SFI7ejjl3xLW0i9A/exec"));
    var jsonProspectList = convert.jsonDecode(rawData.body);
    // prospectList = jsonProspectList.map((json) {
    //   Prospect.fromJson(json);
    // });
    final List<PatientReportModel> tempSevaList = [];
    jsonProspectList.forEach((element) {
      tempSevaList.add(PatientReportModel.fromJson(element));
    });
    receiptsformData = tempSevaList;
  }
}
