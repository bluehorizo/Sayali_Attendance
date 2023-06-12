import 'package:flutter/material.dart';
import 'package:googlesheet/model/attendancemodel.dart';
Widget buildPlayerModelList(AttendanceModel attendanceModel) {
  return Card(
    child: ExpansionTile(
      title: Text(
        attendanceModel.name,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
      children: <Widget>[
        ListTile(
          title: Text(
            attendanceModel.date,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        )
      ],
    ),
  );
}