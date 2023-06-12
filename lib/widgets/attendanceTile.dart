import 'package:flutter/material.dart';
import 'package:googlesheet/widgets/genericTile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/attendancemodel.dart';
import '../themes/color.dart';

class AttendanceTile extends StatefulWidget {
  AttendanceModel attendanceModel;
  AttendanceTile({required this.attendanceModel});

  @override
  State<AttendanceTile> createState() => _AttendanceTileState();
}

class _AttendanceTileState extends State<AttendanceTile> {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.white,
        ),
      ),
      color: Colors.blue.shade50,
      elevation: 1,
      shadowColor: Colors.blue.shade50,
      child: ListTile(
        trailing: IconButton(
          icon: Icon(Icons.photo),
          onPressed: () {
            launch(widget.attendanceModel.imagesemp);
          },
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GenericTile("Name", widget.attendanceModel.name),
                GenericTile(
                    widget.attendanceModel.in_time == "--:--"
                        ? "Out Time ${DateTime.parse(widget.attendanceModel.out_time).hour}"
                        : "In Time",
                    widget.attendanceModel.in_time),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GenericTile("Location", widget.attendanceModel.location),
                GenericTile(
                    widget.attendanceModel.target == ""
                        ? "Todays Target"
                        : "Completed Task",
                    widget.attendanceModel.target == ""
                        ? "${widget.attendanceModel.completion}"
                        : "${widget.attendanceModel.target}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
