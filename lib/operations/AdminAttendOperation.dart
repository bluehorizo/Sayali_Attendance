import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/all_enums.dart';
import '../model/attendancemodel.dart';
import 'gsheetConfiguration.dart';

class AdminAttendOps {
  static Worksheet? attendanceSheet;
  static List<AttendanceModel> attendanceAdminData = [];

  static Future initAttendAdmin() async {
    try {
      final spreadsheet =
          await AttendanceAPI.gsheets.spreadsheet(AttendanceAPI.spreadSheetId);

      attendanceSheet =
          await AttendanceAPI.getWorkSheet(spreadsheet, title: 'Attendance');
      final firstRow = [
        'ID',
        'Date',
        'empNumber',
        'Name',
        'In Time',
        'Out Time',
        'Target',
        'Completion',
        'Reviews',
        'Location',
        'latitude',
        'longitude',
        'Employ Images'
      ];
      attendanceSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print('Init Error: $e');
    }
  }

  static Future<int> getAuthRowCount() async {
    if (attendanceSheet == null) return 0;
    final lastRow = await attendanceSheet!.values.lastRow();
    return lastRow == null ? 0 : int.tryParse(lastRow.first) ?? 0;
  }

  Future<void> readAdminAttend() async {
    if (attendanceSheet == null) return;

    try {
      final lastRow = await attendanceSheet!.values.allRows();
      final List<AttendanceModel> AttendAdminList = [];
      if (lastRow == null) {
        return;
      }

      lastRow.forEach((AttendAdminData) {
        if (AttendAdminData[0] == 'ID' || AttendAdminData[1] == 'Date') {
        } else {
          AttendAdminList.add(AttendanceModel(
              id: int.parse(AttendAdminData[0]),
              date: AttendAdminData[1],
              name: AttendAdminData[2],
              in_time: AttendAdminData[3],
              out_time: AttendAdminData[4],
              target: AttendAdminData[5],
              completion: AttendAdminData[6],
              reviews: AttendAdminData[7],
              location: AttendAdminData[8],
              latitude: AttendAdminData[9],
              longitude: AttendAdminData[10],
              imagesemp: AttendAdminData[11],
              acceptOrNot: AttendAdminData[12],
              isWorking: AttendAdminData[13],
              latitudeOff: AttendAdminData[14],
              longitudeOff: AttendAdminData[15],
              imagesemp2: AttendAdminData[16],
              totalHour: AttendAdminData[17],
              weekOff: AttendAdminData[18],
              leave: AttendAdminData[19],
              reqWorkigHours: AttendAdminData[20],
              workedDays: AttendAdminData[21],
              dailyPayment: AttendAdminData[22],
              month: AttendAdminData[23]));
        }
      });
      attendanceAdminData = AttendAdminList;
    } catch (error) {
      throw (error);
    }
  }
}
