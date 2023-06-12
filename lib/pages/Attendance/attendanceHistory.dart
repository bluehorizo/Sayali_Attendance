import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_month_picker/flutter_month_picker.dart';
import 'package:get/get.dart';
import 'package:googlesheet/model/employeemodel.dart';
import 'package:googlesheet/operations/employeeOperation.dart';
import 'package:googlesheet/pages/Patients/ReceiptFormat/salarySlip.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../model/attendancemodel.dart';
import '../../operations/attendanceOperations.dart';
import '../../operations/authOperations.dart';
import '../../operations/receiptOperation.dart';
import '../../themes/color.dart';
import 'attendanceTile.dart';

class AttendanceHistory extends StatefulWidget {
  const AttendanceHistory({Key? key}) : super(key: key);

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  final DateFormat formatter = DateFormat('MMMM');
  final DateFormat formatter2 = DateFormat('MMM');
  @override
  void initState() {
    Provider.of<EmployeeOperation>(context, listen: false)
        .getEmployeeFromSheet()
        .then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Consumer<AttendanceOperations>(
        builder: (context, orderData, child) => FutureBuilder(
            future: Provider.of<AttendanceOperations>(context, listen: false)
                .getAttendanceFromSheet()
                .then((value) {}),
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
                  return Column(
                    children: [
                      Card(
                        color: cardBackgroundColor,
                        elevation: 10,
                        shadowColor: appBarButtonBackColor,
                        margin: EdgeInsets.all(10),
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: appBarButtonBackColor, width: 1)),
                        child: Stack(
                          children: [
                            Container(
                              // padding: EdgeInsets.only(left: 40, right: 40),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Consumer<AttendanceOperations>(
                                    builder: (context, orderData, child) =>
                                        Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 8.0, 8.0, 2.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Salary Detail',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: textColor),
                                          ),
                                          TextButton.icon(
                                              onPressed: () async {
                                                var selectedDate =
                                                    (await showMonthPicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.parse(
                                                      Provider.of<AttendanceOperations>(
                                                              context,
                                                              listen: false)
                                                          .attendanceData
                                                          .last
                                                          .date),
                                                  lastDate: DateTime.parse(Provider
                                                          .of<AttendanceOperations>(
                                                              context,
                                                              listen: false)
                                                      .attendanceData
                                                      .first
                                                      .date),
                                                ))!;
                                                await orderData.getMonthlyList(
                                                    selectedDate);
                                                // dateController.text =
                                                //     date.toString().substring(0, 10);
                                              },
                                              icon: Icon(Icons.date_range),
                                              label: Text(
                                                  "${formatter2.format(orderData.selectedMonth)} - ${orderData.selectedMonth.year}")),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      TextButton.icon(
                                          onPressed: () async {
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            final String token =
                                                prefs.getString('token')!;
                                            final String designation =
                                                prefs.getString('designation')!;
                                            final String id =
                                                prefs.getString('id')!;
                                            EmployModel employee =
                                                Provider.of<EmployeeOperation>(
                                                        context,
                                                        listen: false)
                                                    .employData
                                                    .firstWhere((element) {
                                              return element.id == id;
                                            }, orElse: null);
                                            await GenerateSalarySlipPdf(
                                                    employModel: employee,
                                                    flag: true,
                                                    attendanceList:
                                                        Provider.of<AttendanceOperations>(
                                                                context,
                                                                listen: false)
                                                            .monthlyCalculationData,
                                                    requiredHours:
                                                        Provider.of<AttendanceOperations>(
                                                                context,
                                                                listen: false)
                                                            .requiredHours,
                                                    totalHour:
                                                        Provider.of<AttendanceOperations>(
                                                                context,
                                                                listen: false)
                                                            .totalHour,
                                                    salary: Provider.of<AttendanceOperations>(
                                                            context,
                                                            listen: false)
                                                        .salary,
                                                    getSalary: Provider.of<AttendanceOperations>(context, listen: false).getSalary,
                                                    servedHours: Provider.of<AttendanceOperations>(context, listen: false).servedHours)
                                                .generateInvoice(employee);
                                          },
                                          icon: Icon(
                                            Icons.picture_as_pdf,
                                            color: Colors.red,
                                          ),
                                          label: Text(
                                            "View",
                                            style: TextStyle(color: Colors.red),
                                          )),
                                      TextButton.icon(
                                          onPressed: () {},
                                          icon: Icon(Icons.share,
                                              color: Colors.blue),
                                          label: Text("Share")),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0, horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Total Required Hours"),
                                            Text(
                                                "${orderData.requiredHours.toPrecision(2)}")
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0, horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Total Served Hours"),
                                            Text(
                                                "${orderData.totalHour.toPrecision(2)}")
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0, horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Gross Salary "),
                                            Text(" ${orderData.getSalary}"),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Net Salary Payable  ",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                            Text(
                                              "₹ ${orderData.salary.toPrecision(2)}",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // GenericTile('Date', attendanceModel.date.substring(0, 10)),
                                        // GenericTile(
                                        //     'In Time',
                                        //     attendanceModel.in_time != "--:--"
                                        //         ? attendanceModel.in_time.substring(11, 16)
                                        //         : attendanceModel.in_time),
                                        // GenericTile(
                                        //     'Out Time',
                                        //     attendanceModel.out_time != "--:--"
                                        //         ? attendanceModel.out_time.substring(11, 16)
                                        //         : attendanceModel.out_time),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 15),
                                transform: Matrix4.rotationZ(-6 * pi / 180)
                                  ..translate(-10.0),
                                decoration: BoxDecoration(
                                    color: Colors.green.shade800,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ) // green shaped
                                    ),
                                child: Text(
                                  "${formatter2.format(orderData.selectedMonth)}-${orderData.selectedMonth.year}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade200,
                          border: Border.all(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Attendace Record',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2.0,
                                      color: Colors.green,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.37,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    DataTable(
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    Colors.green.shade100),
                                        dataRowColor:
                                            MaterialStateColor.resolveWith(
                                          (states) => Colors.green.shade50,
                                        ),
                                        dividerThickness: 1,
                                        horizontalMargin: 2,
                                        columnSpacing: tableDefaultPadding,
                                        columns: [
                                          if (Provider.of<AuthOperation>(
                                                  this.context,
                                                  listen: false)
                                              .isAdmin())
                                            DataColumn(
                                                label: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text("Name",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w800)),
                                            )),
                                          DataColumn(
                                              label: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text("Working Hours",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w800)),
                                          )),
                                          if (!Provider.of<AuthOperation>(
                                                  this.context,
                                                  listen: false)
                                              .isAdmin())
                                            DataColumn(
                                                label: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Text("Review",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w800)),
                                                )),
                                        ],
                                        rows: List.generate(
                                            orderData
                                                .monthlyCalculationData.length,
                                            (index) => employeeRow(orderData
                                                    .monthlyCalculationData[
                                                index]))),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }
            }));
  }

  DataRow employeeRow(AttendanceModel attendanceModel) {
    bool isEmailEmpty = false;
    bool isPhoneEmpty = false;
    final f = new DateFormat('HH:mm');
    if (attendanceModel != null) {
      isEmailEmpty = attendanceModel.location.isNotEmpty;
      isPhoneEmpty = attendanceModel.imagesemp.isNotEmpty;
    }

    final dateformat = new DateFormat('dd-MM-yyyy');
    var reviews;
    return DataRow(
      cells: [
        if (Provider.of<AuthOperation>(this.context, listen: false).isAdmin())
          DataCell(SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(attendanceModel.name,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                ),
              ],
            ),
          )),
        DataCell(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  attendanceModel.totalHour.isEmpty
                      ? "-"
                      : "${double.parse(attendanceModel.totalHour).toStringAsFixed(2)} hr",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.red),
                ),
                Text.rich(TextSpan(
                    text: '₹ ',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                    children: <InlineSpan>[
                      TextSpan(
                          text: attendanceModel.dailyPayment.isEmpty
                              ? "-"
                              : "${double.parse(attendanceModel.dailyPayment).roundToDouble().toString()}",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 14))
                    ])),
              ],
            ),
            PopupMenuButton<int>(
              color: Colors.white,
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),

              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: Colors.black26),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  )),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                        "Attendance Details",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                      PopupMenuDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                  attendanceModel.in_time != "--:--"
                                      ? dateformat.format(DateTime.parse(
                                          attendanceModel.in_time))
                                      : attendanceModel.in_time,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54)),
                              Text(
                                  attendanceModel.in_time == "--:--"
                                      ? "--"
                                      : f.format(DateTime.parse(
                                              attendanceModel.in_time)
                                          .toLocal()),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green)),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                  attendanceModel.out_time != "--:--"
                                      ? dateformat.format(DateTime.parse(
                                          attendanceModel.out_time))
                                      : attendanceModel.out_time,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54)),
                              Text(
                                  attendanceModel.out_time == "--:--"
                                      ? "--"
                                      : f.format(DateTime.parse(
                                              attendanceModel.out_time)
                                          .toLocal()),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red)),
                            ],
                          ),
                        ],
                      ),
                      PopupMenuDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text("DayWise Calc",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54)),
                              Text.rich(TextSpan(
                                  text:
                                      '${double.parse(attendanceModel.workedDays).toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                  children: <InlineSpan>[
                                    TextSpan(
                                        text: '',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14))
                                  ])),
                            ],
                          ),
                          Column(
                            children: [
                              Text("+/- Sal",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54)),
                              Text.rich(TextSpan(
                                  text: '₹ ',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                  children: <InlineSpan>[
                                    TextSpan(
                                        text:
                                            '${double.parse(attendanceModel.dailyPayment).roundToDouble().toString()} ',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14))
                                  ])),
                            ],
                          ),
                        ],
                      ),
                      PopupMenuDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text("Image",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54)),
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.image,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        launch(attendanceModel.imagesemp);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.image,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        launch(attendanceModel.imagesemp2);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text("Locationn",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54)),
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.location_on,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        var latitude = double.parse(
                                            attendanceModel.latitude);
                                        var longitude = double.parse(
                                            attendanceModel.longitude);
                                        MapsLauncher.launchCoordinates(
                                            latitude, longitude);
                                      },
                                      color: Colors.blue,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        var latitude = double.parse(
                                            attendanceModel.latitudeOff);
                                        var longitude = double.parse(
                                            attendanceModel.longitudeOff);
                                        MapsLauncher.launchCoordinates(
                                            latitude, longitude);
                                      },
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              // onSelected: (item) => SelectedItem(context, item),
            )
          ],
        )),
        if (!Provider.of<AuthOperation>(this.context, listen: false).isAdmin())
          DataCell(
            Row(
              children: [
                Text(attendanceModel.reviews.isNotEmpty
                    ? attendanceModel.reviews
                    : (attendanceModel.acceptOrNot == "true"
                        ? "Accepted"
                        : "Pending")),
                PopupMenuButton<int>(
                  color: Colors.white, icon: Icon(Icons.info),
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                        value: 0,
                        child: Text("Custom Theme",
                            style: TextStyle(
                              color: textColor,
                            ))),
                    PopupMenuDivider(),
                    PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                          ],
                        )),
                  ],
                  // onSelected: (item) => SelectedItem(context, item),
                )
              ],
            ),
            //   Column(
            //     children: [
            //       if (reviews.isEmpty)
            //       {
            //          print('****');
            //       } else {
            //         print('attendanceModel.reviews)');
            // },

            // ],
          )
      ],
    );
  }
}
