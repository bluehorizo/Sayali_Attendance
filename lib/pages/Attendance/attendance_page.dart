import 'dart:io';
import 'package:googlesheet/pages/Attendance/createAttendance.dart';
import 'package:flutter/material.dart';
import 'package:googlesheet/model/attendancemodel.dart';
import 'package:googlesheet/model/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../operations/attendanceOperations.dart';
import '../../operations/authOperations.dart';
import 'attendanceHistory.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  GlobalKey<FormState> formskey = GlobalKey<FormState>();
  late SharedPreferences logindata;
  late String username;
  late TextEditingController targetcontroller = TextEditingController();

  late TextEditingController Completecontroller = TextEditingController();
  late TextEditingController reviewscontroller = TextEditingController();
  late AttendanceModel attendanceModel = AttendanceModel(
      id: 0,
      date: "",
      name: "",
      in_time: "--:--",
      out_time: "--:--",
      target: "",
      completion: "",
      reviews: "",
      location: "Your Mobile location",
      latitude: "",
      longitude: "",
      imagesemp: "",
      acceptOrNot: '',
      isWorking: "",
      latitudeOff: "",
      longitudeOff: "",
      imagesemp2: "",
      totalHour: "",
      weekOff: "",
      leave: "",
      reqWorkigHours: "",
      workedDays: "",
      dailyPayment: "",
      month: "");

  double? lat, long; // longitude location
  int _selectedIndex = 0;
  bool isAdmin = false;
  late AuthData? staff;
  File? image;
  bool InOutToggle = false;
  bool intimesvisible = true;
  bool ContainerVisible = true;
  bool TextVisible = true;
  bool controllerVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    isAdmin = Provider.of<AuthOperation>(this.context, listen: false).isAdmin();
    staff = Provider.of<AuthOperation>(this.context, listen: false).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<AttendanceOperations>(context, listen: false)
            .getAttendanceFromSheet(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                height: 120.0,
                width: 120.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/doct.jpg'),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              return Container(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                child: DefaultTabController(
                  length: 2,
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(25.0)),
                          child: TabBar(
                            indicator: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(25.0)),
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.white,
                            tabs: [
                              Tab(text: 'Attendance'),
                              Tab(text: 'History'),
                            ],
                          ),
                        ),
                        Divider(),
                        Expanded(
                          child: TabBarView(children: [
                            CreateAttendance(),
                            AttendanceHistory(),
                          ]),
                        )
                        // Visibility(
                        //   visible: isAdmin,
                        //   child: Expanded(
                        //     child: ListView.builder(
                        //       itemCount: orderData.attendanceData.length,
                        //       itemBuilder: (context, i) => AttendanceTile(
                        //           attendanceModel:
                        //               orderData.attendanceData[i]),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        });
  }
}
