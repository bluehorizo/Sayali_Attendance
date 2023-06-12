import 'package:flutter/material.dart';
import 'package:googlesheet/model/inTimeEntry.dart';
import 'package:googlesheet/operations/inTimePatientOperation.dart';
import 'package:googlesheet/operations/patientOperation.dart';
import 'package:googlesheet/pages/Patients/patientListWidget.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../model/attendancemodel.dart';
import '../../operations/attendanceOperations.dart';
import '../../operations/authOperations.dart';
import '../../operations/receiptOperation.dart';
import '../../themes/color.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  State<PatientHomePage> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<PatientHomePage> {
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  List<dynamic> appointmentList = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<AppointementOperation>(context, listen: false)
            .getAppointementFromSheet()
            .then((value) =>
                Provider.of<PatientOperation>(context, listen: false)
                    .getPatientFromSheet()),
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
              return Consumer<AppointementOperation>(
                  builder: (context, orderData, child) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Patient List",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.refresh))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text.rich(TextSpan(
                                    text: 'Today, ',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                    children: <InlineSpan>[
                                      TextSpan(
                                          text:
                                              '${Provider.of<AppointementOperation>(context, listen: false).currentAppointmentData.length} Patients ',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      TextSpan(
                                          text: 'are in',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16))
                                    ])),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButton(
                                    hint: Text("Select Process"),
                                    // Initial Value
                                    value: orderData.processType,

                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),

                                    // Array list of items
                                    items: <String>['Waiting', 'Receipts']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (newValue) {
                                      orderData.setProcess(newValue.toString());

                                      // appointemenetModel.consult_ther =
                                      //     orderData.inTimeType;
                                    },
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Divider(),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemBuilder: (_, i) => Column(
                                children: [
                                  PatietListWidget(
                                      receiptModel: Provider.of<RceiptOperation>(
                                              context,
                                              listen: false)
                                          .receiptsData[i],id: i),

                                  // SevaHistoryBillInfo(
                                  //     sevaTransactionList[i],
                                  //     sevaTransactionList[i].id,
                                  //     sevaTransactionList[i].srNumber,
                                  //     sevaTransactionList[i].donatorName),
                                  Divider()
                                ],
                              ),
                              itemCount: Provider.of<AppointementOperation>(
                                      context,
                                      listen: false)
                                  .currentAppointmentData
                                  .length,
                            ),
                          ),
                        ],
                      ));
              // return SingleChildScrollView(
              //   child: DataTable(
              //       dividerThickness: 3,
              //       horizontalMargin: 2,
              //       columnSpacing: defaultPadding,
              //       columns: [
              //         DataColumn(
              //           label: Text("Patient Name",
              //               style: TextStyle(
              //                   fontSize: 16, fontWeight: FontWeight.w800)),
              //           onSort: (columnIndex, _) {
              //             setState(() {
              //               _currentSortColumn = columnIndex;
              //               if (_isSortAsc) {
              //                 orderData.appointmentData.sort(
              //                     (a, b) => b.inTime.compareTo(a.inTime));
              //               } else {
              //                 orderData.appointmentData.sort(
              //                     (a, b) => a.outTime.compareTo(b.outTime));
              //               }
              //               _isSortAsc = !_isSortAsc;
              //             });
              //           },
              //         ),
              //         if (Provider.of<AuthOperation>(this.context,
              //                 listen: false)
              //             .isAdmin())
              //           DataColumn(
              //               label: Text("In Time",
              //                   style: TextStyle(
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w800))),
              //         DataColumn(
              //             label: Text("Out Time",
              //                 style: TextStyle(
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.w800))),
              //         DataColumn(
              //             label: Text("PDF Receipt",
              //                 style: TextStyle(
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.w800))),
              //         if (!Provider.of<AuthOperation>(this.context,
              //                 listen: false)
              //             .isAdmin())
              //           DataColumn(
              //               label: Text("Review",
              //                   style: TextStyle(
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w800))),
              //       ],
              //       rows: List.generate(
              //           orderData.appointmentData.length,
              //           (index) =>
              //               employeeRow(orderData.appointmentData[index]))),
              // );
            }
          }
        });
  }

  DataRow employeeRow(AppointemenetModel appointemenetModel) {
    bool isEmailEmpty = false;
    bool isPhoneEmpty = false;
    print(appointemenetModel.id);
    final f = new DateFormat('HH:mm');
    if (appointemenetModel != null) {
      isEmailEmpty = appointemenetModel.inTime.isNotEmpty;
      isPhoneEmpty = appointemenetModel.outTime.isNotEmpty;
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
                    child: Text(appointemenetModel.patientName,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                  ),
                ),
              ],
            ),
          )),
        DataCell(SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                      dateformat
                          .format(DateTime.parse(appointemenetModel.inTime)),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54)),
                ),
              ),
              Visibility(
                visible: appointemenetModel.inTime != "--:--",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        appointemenetModel.inTime == "--:--"
                            ? "--"
                            : f.format(DateTime.parse(appointemenetModel.inTime)
                                .toLocal()),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green)),
                  ],
                ),
              ),
            ],
          ),
        )),
        DataCell(SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                      dateformat
                          .format(DateTime.parse(appointemenetModel.outTime)),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54)),
                ),
              ),
              Visibility(
                visible: appointemenetModel.inTime != "--:--",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        f.format(DateTime.parse(appointemenetModel.outTime)
                            .toLocal()),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        )),
        DataCell(
          appointemenetModel.consult_ther != "yes"
              ? IconButton(
                  onPressed: () {
                    // GenerateDonatorVersionDonationPdf(
                    //     Provider.of<RceiptOperation>(context, listen: false)
                    //         .receiptsData[0],
                    //     true);
                  },
                  icon: Icon(
                    Icons.picture_as_pdf,
                    color: Colors.red,
                  ))
              : Text(appointemenetModel.consult_ther),
          //   Column(
          //     children: [
          //       if (reviews.isEmpty)
          //       {
          //          print('****');
          //       } else {
          //         print('attendanceModel.reviews)');
          // },

          // ],
        ),
        if (!Provider.of<AuthOperation>(this.context, listen: false).isAdmin())
          DataCell(
            appointemenetModel.consult_ther != "-"
                ? IconButton(
                    onPressed: () {
                      // GenerateDonatorVersionDonationPdf(
                      //     Provider.of<RceiptOperation>(context, listen: false)
                      //         .receiptsData[0],
                      //     true);
                    },
                    icon: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                    ))
                : Text(appointemenetModel.consult_ther),
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

        // if (reviws.isEmpty) {
        // print('****');
        // } else {
        // print('attendanceModel.reviews)');
        // }
        //     Text(attendanceModel.reviews),
        // IconButton(
        //   icon: Icon(
        //     Icons.info_outline,
        //     color: Colors.blue,
        //   ),
        //   onPressed: () {
        //     launch(attendanceModel.reviews);
        //   },
        // ),
      ],
    );
  }
}
