import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googlesheet/model/employeemodel.dart';
import 'package:googlesheet/model/inTimeEntry.dart';
import 'package:gsheets/gsheets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/approvialmodel.dart';
import '../model/attendancemodel.dart';
import 'gsheetConfiguration.dart';
import 'package:googlesheet/notification_service.dart';

class AttendanceOperations extends ChangeNotifier {
  static Worksheet? attendanceSheet;
  List<AttendanceModel> attendanceData = [];
  List<AttendanceModel> allAttendanceData = [];
  List<AttendanceModel> monthlyCalculationData = [];
  List<AttendanceModel> tempMonthlyCalculationData = [];
  List<AttendanceModel> workingList = [];
  TimeOfDay selectedRequestedTime = TimeOfDay.now();
  String getSalary = "0";
  bool isDone = false;
  int last_id = 0;
  DateTime selectedMonth = DateTime.now();
  double requiredHours = 0, servedHours = 0, salary = 0, totalHour = 0;
  int totalDayWorking = 0;
  final void Function(String) callback = (dw) {};
  bool isWorking = false;

  static const String URL =
      "https://script.google.com/macros/s/AKfycbyHxgaDcmMDb_zv2DMyGv3IWZHLB-UD19la6qO8sqbtRRMpuF0LJL2d_eyL_ctRP2N8yw/exec";
  static const String updateReviewURL =
      "https://script.google.com/macros/s/AKfycbw7DhOlvdiIaYVTb3tI8GLignA3kSkbP4l1I6V9_ziut2UkJZSMd5GvMiiCFsbWW2Z04g/exec";
  static const String attendanceUpdate =
      "https://script.google.com/macros/s/AKfycbwn30D-PilY-sPkKsk1WzavhER-wuJvucaAGKDrNFziDibbW1vkBxS6FLXfxpSOg060KQ/exec";
  final issueUrl =
      'https://script.google.com/macros/s/AKfycbzrT3f8jpyWRhGLGVb0mu1OJuCWn_rXUYv0yAOLCBrZ4u1ISEIftgR2oQ_SaDs4WclePg/exec';
  static const STATUS_SUCCESS = "SUCCESS";
  bool getisWorking() {
    notifyListeners();
    return isWorking;
  }

  Future initAttendAuth() async {
    try {
      final spreadsheet =
          await AttendanceAPI.gsheets.spreadsheet(AttendanceAPI.spreadSheetId);

      attendanceSheet = await AttendanceAPI.getWorkSheet(spreadsheet,
          title: 'AttendanceFinalRepaired');
      final firstRow = [
        'ID',
        'Date',
        'Name',
        'In Time',
        'Out Time',
        'Target',
        'Completion',
        'Reviews',
        'Location',
        'latitude',
        'longitude',
        'imagesemp',
        'acceptOrNot',
        "isWorking"
      ];
      attendanceSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print('Init Error: $e');
    }
  }

  TimeOfDay stringToTimeOfDay(String timeString) {
    // Split the timeString to extract hours and minutes
    List<String> timeParts = timeString.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    // Create a new TimeOfDay object
    TimeOfDay timeOfDay = TimeOfDay(hour: hours, minute: minutes);
    return timeOfDay;
  }
  Future<TimeOfDay> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    // If the user selects a time, update the selected time
    if (picked != null && picked != _selectedTime) {

        _selectedTime = picked;

    }
    notifyListeners();
    return _selectedTime;
  }

  Future<File?> pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: source, preferredCameraDevice: CameraDevice.front);
      if (image == null) return null;

      final imageTemporary = File(image.path);
      notifyListeners();
      return imageTemporary;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  static Future<int> getAuthRowCount() async {
    if (attendanceSheet == null) return 0;
    final lastRow = await attendanceSheet!.values.lastRow();
    return lastRow == null ? 0 : int.tryParse(lastRow.first) ?? 0;
  }

  int getId() {
    return attendanceData.first.id + 1;
  }

  Future<void> updateOutTime(AttendanceModel attendanceModel) async {
    try {
      // notification(completedTask);
      attendanceModel.imagesemp2 = attendanceModel.imagesemp;
      String toParams() =>
          "?id=${attendanceModel.id}&outTime=${attendanceModel.out_time}&completedTask=${attendanceModel.completion}&latitude=${attendanceModel.latitude}&longitude=${attendanceModel.longitude}&imsg2=${attendanceModel.imagesemp}&totalHour=${attendanceModel.totalHour}";

      await http
          .get(Uri.parse(attendanceUpdate + toParams()))
          .then((response) async {
        final cell = await attendanceSheet!.cells
            .cell(column: 17, row: attendanceModel.id + 1);
        cell.post(attendanceModel.imagesemp2);
        setIsDone();
        callback(convert.jsonDecode(response.body)['status']);
        workingList = [];
        isWorking = false;

        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  void updateReview(int id, String review, bool accptOrNot) async {
    try {
      // notification(review);
      String toParams() => "?id=$id&review=$review&accptOrNot=$accptOrNot";
      await http.get(Uri.parse(updateReviewURL + toParams())).then((response) {
        callback(convert.jsonDecode(response.body)['status']);

        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  } //not used

  Future getMonthlyList(DateTime selectedDate) async {
    selectedMonth = selectedDate;
    notifyListeners();
  }

  bool setIsDone() {
    isDone = !isDone;
    notifyListeners();
    return isDone;
  }
  AttendanceModel getAttendanceForOutTime(int id){
    AttendanceModel tempAttendance=attendanceData[0];
    attendanceData.map((e) {
      if(e.id==id){
        tempAttendance=e;
      }

    }).toList();
    return tempAttendance;
  }
  Future submitForm(AttendanceModel attendanceModel) async {
    try {
      workingList = [];
      await http
          .get(Uri.parse(URL + attendanceModel.toParams()))
          .then((response) async {
        final cell =
            await attendanceSheet!.cells.cell(column: 12, row: last_id + 2);
        workingList.add(attendanceModel);
        cell.post(attendanceModel.imagesemp);
        isWorking = true;

        attendanceModel.id = getId();
        final responseBody = response.body;
        // attendanceModel.id=int.parse(responseBody['id']);
        attendanceData.add(attendanceModel);
        setIsDone();
        callback(convert.jsonDecode(response.body)['status']);

        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  } //not used
  String formatTimeOfDay(TimeOfDay time) {
    // Get the current date to combine with the TimeOfDay
    DateTime now = DateTime.now();

    // Combine the current date with the selected TimeOfDay
    DateTime combinedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Define the format for the time
    final DateFormat timeFormat = DateFormat('hh:mm a');

    // Format the combined DateTime using the time format
    return timeFormat.format(combinedDateTime);
  }
  Future submitForm2(String name, String issue) async {
    final response = await http.post(Uri.parse(issueUrl), body: {
      'name': name,
      'issue': issue,
    });

    if (response.statusCode == 200) {
      print('Data posted successfully');
    } else {
      print('Error posting data: ${response.statusCode}');
    }
  }

  void notifyOnly() async {
    await getAttendanceFromSheet();
    notifyListeners();
  }

  Future getAttendanceFromSheet() async {
    var rawData = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbxZQ-0RnoCa9m4IGBldcxJWbm8lByWYqFm2mgyIYYU5a9XNy2TQZx3pDsKpH-mNYLj6Ew/exec"));

    var jsonProspectList = convert.jsonDecode(rawData.body);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final String designation = prefs.getString('designation')!;
    final String user_identification = prefs.getString('user_identification')!;
    final String staffEmail = prefs.getString('userEmail')!;

    if (prefs.getString('salary') != null) {
      getSalary = prefs.getString('salary')!;
    }
    final String id = prefs.getString('id')!;
    final String name = prefs.getString('name')!;
    // prospectList = jsonProspectList.map((json) {
    //   Prospect.fromJson(json);
    // });
    final List<AttendanceModel> tempSevaList = [];
    final List<AttendanceModel> tempWorking = [];
    final List<AttendanceModel> tempMonth = [];
    monthlyCalculationData = [];
    salary = 0;
    servedHours = 0;
    requiredHours = 0;
    totalHour = 0;
    last_id = 0;
    DateTime x1 = DateTime(selectedMonth.year, selectedMonth.month, 0).toUtc();
    // var day = daysInMonthWithoutSunday(selectedMonth, user_identification);
    jsonProspectList.forEach((element) {
      last_id++;
      if (name == element['name'] || designation == "Director") {
        if (element['isWorking'] == true) {
          isWorking = true;
          tempWorking.add(AttendanceModel.fromJson(element));
          if (selectedMonth.month == DateTime.parse(element['date']).month &&
              selectedMonth.year == DateTime.parse(element['date']).year) {
            tempMonth.add(AttendanceModel.fromJson(element));
          }
        }

        if (selectedMonth.month == DateTime.parse(element['date']).month &&
            selectedMonth.year == DateTime.parse(element['date']).year &&
            element['isWorking'] == false) {
          tempMonth.add(AttendanceModel.fromJson(element));
          if (element['dailyPayment'] != 0 && name == element['name']) {
            salary = element['dailyPayment'] + salary;

            servedHours = element['workedDays'] + servedHours;
            // requiredHours = (element['reqWorkigHours'] * day) + 0.0;

            totalHour = element['totalHour'] + totalHour;
          }

          // salary = (salary + int.parse(element['dailyPayment']));
        }

        tempSevaList.add(AttendanceModel.fromJson(element));
      }
    });

    attendanceData = tempSevaList;
    workingList = tempWorking;
    allAttendanceData = tempSevaList;
    monthlyCalculationData = tempMonth;
    List.from(allAttendanceData.reversed);
    totalDayWorking = monthlyCalculationData.length;
    monthlyCalculationData.sort((b, a) {
      return a.date.compareTo(b.date);
    });
    attendanceData.sort((b, a) {
      return a.date.compareTo(b.date);
    });
  }

  int daysInMonthWithoutSunday(
      DateTime month, String user_identification, EmployModel employModel) {
    int days = 0;
    for (int i = 1; i <= DateTime(month.year, month.month + 1, 0).day; i++) {
      DateTime day = DateTime(month.year, month.month, i);
      if (day.weekday != DateTime.sunday) {
        days++;
      }
    }
    return days;
  }

  int daysInMonthWithSunday(
      DateTime month, String user_identification, EmployModel employModel) {
    int sunDays = 0;
    for (int i = 1; i <= DateTime(month.year, month.month + 1, 0).day; i++) {
      DateTime day = DateTime(month.year, month.month, i);
      if (user_identification == "Substaff") {
        if (day.weekday == DateTime.sunday) {
          sunDays++;
        }
      } else if (user_identification == "Senior Doctor") {
        sunDays = 0;
      } else if (user_identification == "Doctor") {
        if (day.weekday == DateTime.sunday && sunDays < 2) {
          sunDays++;
        }
      }
    }
    return sunDays;
  }

  Future setMonthlyAttendance(String name, EmployModel employModel) async {
    DateTime x1 = DateTime(selectedMonth.year, selectedMonth.month, 0).toUtc();
    var day = DateTime(selectedMonth.year, selectedMonth.month + 1, 0)
        .toUtc()
        .difference(x1)
        .inDays;

    tempMonthlyCalculationData = [];
    salary = 0;
    servedHours = 0;
    requiredHours = 0;
    totalHour = 0;
    var day1 = daysInMonthWithoutSunday(
        selectedMonth, employModel.user_identification, employModel);
    var sunday = daysInMonthWithSunday(
        selectedMonth, employModel.user_identification, employModel);

    requiredHours = (double.parse(employModel.total_working_hours) * day1 +
                double.parse(employModel.sun_working_hours) * sunday) *
            24 +
        0.0;
    print("Working Hours:${requiredHours}");
    attendanceData.forEach((element) {
      if ((name == element.name) &&
          (selectedMonth.month == DateTime.parse(element.date).month &&
              selectedMonth.year == DateTime.parse(element.date).year)) {
        tempMonthlyCalculationData.add(element);
        if (element.dailyPayment != 0) {
          salary = double.parse(element.dailyPayment) + salary;
          servedHours = double.parse(element.workedDays) + servedHours;

          totalHour = double.parse(element.totalHour) + totalHour;
        }
      }
    });
    tempMonthlyCalculationData.sort((a, b) {
      return a.date.compareTo(b.date);
    });
  }
//not used

  void notification(String msg) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    notification_service.showBigTextNotification(
        id: 0,
        title: "Blue Horizon Automation Research",
        body: msg,
        payload: 'item x',
        fln: flutterLocalNotificationsPlugin);
  }

  String inTime() {
    notifyListeners();
    return DateTime.now().toString();
  }

  Future<bool> writeattendance(AttendanceModel attendanceModel) async {
    int number = await getAuthRowCount();
    number++;
    final Map<String, dynamic> attendanceTypeData = {
      'ID': number,
      'Date': attendanceModel.date,
      "Name": attendanceModel.name,
      'In Time': attendanceModel.in_time,
      'Out Time': attendanceModel.out_time,
      'Target': attendanceModel.target,
      'Reviews': attendanceModel.reviews,
      'Location': attendanceModel.location,
      'latitude': attendanceModel.latitude,
      'longitude': attendanceModel.longitude,
      'imagesemp': attendanceModel.imagesemp,
      "acceptOrNot": attendanceModel.acceptOrNot,
      "isWorking": attendanceModel.isWorking
    };
    try {
      final bool response =
          await attendanceSheet!.values.map.appendRow(attendanceTypeData);
      workingList.add(attendanceModel);

      if (!response) {
        return false;
      } else {
        isWorking = true;
        notifyListeners();
        return true;
      }
    } catch (error) {
      return false;
    }
  } //  // write function

  TimeOfDay _selectedTime = TimeOfDay.now();

  TimeOfDay get selectedTime => _selectedTime;

  void setSelectedTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }
}
