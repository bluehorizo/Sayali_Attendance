import 'dart:math';

import 'package:flutter/material.dart';
import 'package:googlesheet/model/leaveapplymodel.dart';
import 'package:googlesheet/operations/LeavesOperation.dart';
import 'package:googlesheet/themes/color.dart';
import 'package:googlesheet/widgets/genericTile.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../operations/authOperations.dart';

class LeaveListHistory extends StatefulWidget {
  const LeaveListHistory({Key? key}) : super(key: key);

  @override
  State<LeaveListHistory> createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListHistory> {
  late LeaveApplyModel leaveApplyModel = LeaveApplyModel(
      id: "",
      emp_id: "",
      emp_name: "",
      supervisor_name: "",
      leave_Type: "",
      type_of_Day: "",
      from_Date: "",
      to_Date: "",
      no_of_days: "",
      half_Date: "",
      full_Date: "",
      reason: "",
      mob_Avail: "",
      email_Avail: "",
      op_bal: "",
      applied: "",
      applicationDate: "",
      approved: "",
      rejected: "",
      cancelled: "",
      leave_status: "");
  ValueNotifier<DateTime> _dateTimeNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  GlobalKey<FormState> formskey = GlobalKey<FormState>();
  bool halfdayVISIBLE = true;
  bool fulldayVISIBLE = false;
  bool moredaysVISIBLE = false;
  int selectedNumForLeave = 0;
  int selectedNumForDay = 0;
  var now = DateTime.now();

  var formatterDate = DateFormat('dd/MM/yyyy');
  var formatterTime = DateFormat('kk:mm');
  late List<bool> isSelectedForLeave;
  late List<bool> isSelectedForDays;
  List<String> leavesTypes = ["Casual Leave", "Sick Leave", "Privileges leave"];
  List<String> dayOptions = ["One Day", "More than One Day", "Half Day"];
  late TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Form(
      key: formskey,
      child: Column(
        children: [
          // Card(
          //   color: cardBackgroundColor,
          //   elevation: 10,
          //   shadowColor: appBarButtonBackColor,
          //   margin: EdgeInsets.all(10),
          //   shape: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(10),
          //       borderSide: BorderSide(color: appBarButtonBackColor, width: 1)),
          //   child: Stack(
          //     children: [
          //       Container(
          //         // padding: EdgeInsets.only(left: 40, right: 40),
          //         child: Column(
          //           children: [
          //             SizedBox(
          //               height: 15,
          //             ),
          //             Consumer<LeaveOperations>(
          //               builder: (context, orderData, child) => Padding(
          //                 padding:
          //                     const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 2.0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Text(
          //                       'Leave Summary',
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           fontSize: 25,
          //                           color: textColor),
          //                     ),
          //                     TextButton.icon(
          //                         onPressed: () async {},
          //                         icon: Icon(Icons.date_range),
          //                         label: Text("7")),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //             Row(
          //               children: [
          //                 TextButton.icon(
          //                     onPressed: () {},
          //                     icon: Icon(Icons.share, color: Colors.blue),
          //                     label: Text("Share")),
          //               ],
          //             ),
          //             SizedBox(
          //               height: 12,
          //             ),
          //             Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.symmetric(
          //                       vertical: 2.0, horizontal: 8.0),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Text(" Taken Casual Leave"),
          //                       Text("sccc")
          //                     ],
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.symmetric(
          //                       vertical: 2.0, horizontal: 8.0),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [Text("Taken Sick Leave"), Text("55")],
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.symmetric(
          //                       vertical: 2.0, horizontal: 8.0),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Text("Taken Privilaged Leave "),
          //                       Text("45"),
          //                     ],
          //                   ),
          //                 ),
          //                 Divider(),
          //                 Padding(
          //                   padding:
          //                       const EdgeInsets.symmetric(horizontal: 8.0),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Text("Amount deduct",
          //                           style: TextStyle(
          //                               color: Colors.black54,
          //                               fontWeight: FontWeight.bold,
          //                               fontSize: 18)),
          //                       Text(
          //                         "₹ 78",
          //                         style: TextStyle(
          //                             color: Colors.green,
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 18),
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             SizedBox(
          //               height: 15,
          //             ),
          //             Center(
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                 // crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   // GenericTile('Date', attendanceModel.date.substring(0, 10)),
          //                   // GenericTile(
          //                   //     'In Time',
          //                   //     attendanceModel.in_time != "--:--"
          //                   //         ? attendanceModel.in_time.substring(11, 16)
          //                   //         : attendanceModel.in_time),
          //                   // GenericTile(
          //                   //     'Out Time',
          //                   //     attendanceModel.out_time != "--:--"
          //                   //         ? attendanceModel.out_time.substring(11, 16)
          //                   //         : attendanceModel.out_time),
          //                 ],
          //               ),
          //             ),
          //             SizedBox(
          //               height: 15,
          //             ),
          //           ],
          //         ),
          //       ),
          //       Positioned(
          //         top: 0,
          //         child: Container(
          //           padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
          //           transform: Matrix4.rotationZ(-6 * pi / 180)
          //             ..translate(-10.0),
          //           decoration: BoxDecoration(
          //               color: Colors.green.shade800,
          //               borderRadius: BorderRadius.only(
          //                 topLeft: Radius.circular(8),
          //                 bottomRight: Radius.circular(8),
          //               ) // green shaped
          //               ),
          //           child: Text(
          //             "7",
          //             style: TextStyle(
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 16),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Divider(),
          Consumer<LeaveOperations>(
              builder: (context, leaveSummaryData, child) => Expanded(
                    child: ListView.builder(
                        itemCount: leaveSummaryData.leaveApplyList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              trailing: TextButton.icon(
                                  onPressed: () {

                                    Provider.of<LeaveOperations>(context,
                                            listen: false)
                                        .excecuteLeaveOperation(
                                        leaveSummaryData.leaveApplyList[index].id, "Cancelled",Provider.of<AuthOperation>(this.context, listen: false).isAdmin());
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                  label: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.red),
                                  )),
                              title: Column(
                                children: [

                                  Text(leaveSummaryData
                                      .leaveApplyList[index].leave_Type,),
                                  Text(formatterDate.format(DateTime.parse(leaveSummaryData
                                      .leaveApplyList[index].full_Date)),style: TextStyle(color: Colors.black54)),
                                ],
                              ));
                        }),
                  )),
        ],
      ),
    );
  }

  void initState() {
    // this is for 3 buttons, add "false" same as the number of buttons here
    isSelectedForLeave = [true, false, false];
    isSelectedForDays = [true, false, false];
  }
// void substract(StateSetter mystate){
// DateTime first=DateTime.now();
// DateTime fiftyDaysAgo = first.subtract(const Duration(days: 50));
// }

  Future<void> OneDay(BuildContext context, StateSetter mystate) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
    if (d != null)
      mystate(() {
        leaveApplyModel.full_Date = DateFormat.yMMMEd().format(d);
      });
  }

  var datefromat = DateFormat.yMMMEd();
  Future<void> HalfDay(BuildContext context, StateSetter mystate) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
    if (d != null)
      mystate(() {
        leaveApplyModel.half_Date = DateFormat.yMMMEd().format(d);
      });
  }

  // DateTime from=DateTime.parse(leaveApplyModel.From_Date);
  Future<void> FromDay(BuildContext context, StateSetter mystate,
      ValueNotifier<DateTime> _dateTimeNotifier) async {
    final DateTime? d = await showDatePicker(
            context: context,
            initialDate: _dateTimeNotifier.value,
            firstDate: DateTime(2000),
            lastDate: DateTime(2099))
        .then((dateTime) => _dateTimeNotifier.value = dateTime!);
    if (d != null)
      mystate(() {
        leaveApplyModel.from_Date = DateFormat.yMMMEd().format(d);
      });
  }

  Future<void> ToDay(BuildContext context, StateSetter mystate,
      ValueNotifier<DateTime> _dateTimeNotifier) async {
    DateTime? d = await showDatePicker(
      context: context,
      firstDate: _dateTimeNotifier.value,
      initialDate: _dateTimeNotifier.value,
      lastDate: DateTime(2099),
    );
    if (d != null) {
      mystate(() {
        // d = d!.add(Duration(days: 1,));
        leaveApplyModel.to_Date = DateFormat.yMMMEd().format(d);
      });
    }
  }

  bool isHalfDaySwitch = false;
  var textValue = 'Before Lunch';
}
