import 'dart:math';

import 'package:flutter/material.dart';
import 'package:googlesheet/model/leaveapplymodel.dart';
import 'package:googlesheet/operations/LeavesOperation.dart';
import 'package:googlesheet/themes/color.dart';
import 'package:googlesheet/widgets/genericTile.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateLeaveApplication extends StatefulWidget {
  const CreateLeaveApplication({Key? key}) : super(key: key);

  @override
  State<CreateLeaveApplication> createState() => _CreateLeaveApplicationState();
}

class _CreateLeaveApplicationState extends State<CreateLeaveApplication> {
  GlobalKey<FormState> formskey = GlobalKey<FormState>();
  ValueNotifier<DateTime> _dateTimeNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  bool isHalfDaySwitch = false;
  var textValue = 'Before Lunch';
  late LeaveApplyModel leaveApplyModel = LeaveApplyModel(
      id: "",
      emp_id: "",
      emp_name: "",
      supervisor_name: "",
      leave_Type: leavesTypes[0],
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

  var now = DateTime.now();
  int defualtDayCount = 0;
  var formatterDate = DateFormat('dd-MMM-yyy');
  List<String> leavesTypes = ["Casual Leave", "Sick Leave", "Privileges leave"];

  List<String> dayOptions = ["One Day", "More than One Day", "Half Day"];
  var formatterTime = DateFormat('kk:mm');
  @override
  void initState() {
    Provider.of<LeaveOperations>(context, listen: false).isSelectedForDays = [
      true,
      false,
      false
    ];
    Provider.of<LeaveOperations>(context, listen: false).isSelectedForLeave = [
      true,
      false,
      false
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Consumer<LeaveOperations>(
        builder: (context, leaveSummaryData, child) => Column(
              children: [
                Divider(),
                Card(
                  elevation: 10,
                  color: cardBackgroundColor,
                  shadowColor: appBarButtonBackColor,
                  margin: EdgeInsets.all(10),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: appBarButtonBackColor, width: 1)),
                  child: Container(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Weekly Off ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: textColor),
                              ),
                            ),
                            Consumer<LeaveOperations>(
                              builder: (context, orderData, child) => InkWell(
                                onTap: () async {
                                  final DateTime? d = await showDatePicker(
                                          context: context,
                                          initialDate: _dateTimeNotifier.value,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2099))
                                      .then((dateTime) =>
                                          _dateTimeNotifier.value = dateTime!);
                                  if (d != null)
                                    leaveApplyModel.from_Date =
                                        DateFormat.yMMMEd().format(d);
                                  Provider.of<LeaveOperations>(context,
                                          listen: false)
                                      .setDate();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black26,
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.calendar_month),
                                      Column(
                                        children: [
                                          Text("Date",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12)),
                                          Text(leaveApplyModel.from_Date),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        MaterialButton(
                          onPressed: () {
                            leaveApplyModel.leave_Type = "Monthly off";
                            leaveApplyModel.full_Date =
                                leaveApplyModel.from_Date;
                            leaveApplyModel.approved = "false";
                            leaveApplyModel.rejected = "false";
                            leaveApplyModel.cancelled = "false";

                            Provider.of<LeaveOperations>(context, listen: false)
                                .submitForm(leaveApplyModel);
                          },
                          child: Text("Save"),
                          color: Colors.blue.shade200,
                        )
                      ],
                    ),
                  ),
                ),
                Form(
                  key: formskey,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(children: [
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Leave Application",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: textColor),
                                  ),
                                ),
                                Text(
                                  'Date :- ${formatterDate.format(now)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                child: Text('Submit'),
                                style: ElevatedButton.styleFrom(
                                  primary: appBarButtonBackColor,
                                  onPrimary: textColor,
                                  shadowColor: appBarButtonBackColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                  minimumSize: Size(120, 45),
                                ),
                                onPressed: () {
                                  if (!formskey.currentState!.validate()) {
                                    return;
                                  }
                                  leaveApplyModel.type_of_Day =
                                      dayOptions[defualtDayCount];
                                  formskey.currentState?.save();

                                  Provider.of<LeaveOperations>(context,
                                          listen: false)
                                      .submitForm(leaveApplyModel);
                                  // reasonController.clear();
                                  // LeaveOperations.writeLeave(leaveApplyModel);
                                  // leaveApplyModel=  LeaveApplyModel(id: '', date: , name: '', Reason: '', supervisor_name: '', Half_Day: '', More_Days: '', Full_Date: '', Half_Date: '', Full_Day: '', From_Date: '', Leave_Type: '', Email_Avail: '', Mob_Avail: '', To_Date: '');
                                },
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        SizedBox(
                            height: height * 0.47,
                            child: SingleChildScrollView(
                                child: Consumer<LeaveOperations>(
                              builder: (context, orderData, child) => Column(
                                children: [
                                  Consumer<LeaveOperations>(
                                    builder: (context, orderData, child) =>
                                        Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                child: Text(
                                                  leaveApplyModel.leave_Type,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: textColor,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ToggleButtons(
                                            constraints: BoxConstraints.expand(
                                                width: size * 0.3),
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(leavesTypes[0],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16)),
                                                    Text(
                                                        "Available - ${leaveSummaryData.availableCL}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      leavesTypes[1],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                        "Available - ${leaveSummaryData.availableSL}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(leavesTypes[2],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16)),
                                                    Text(
                                                        "Available - ${leaveSummaryData.availablePL}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            isSelected:
                                                Provider.of<LeaveOperations>(
                                                        context,
                                                        listen: false)
                                                    .isSelectedForLeave,
                                            onPressed: (int index) {
                                              Provider.of<LeaveOperations>(
                                                      context,
                                                      listen: false)
                                                  .setLeaveType(index);
                                              leaveApplyModel.leave_Type =
                                                  leavesTypes[index];
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Consumer<LeaveOperations>(
                                    builder: (context, orderData, child) =>
                                        Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Text(
                                            "Application to request for ${dayOptions[defualtDayCount]} leave",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ToggleButtons(
                                            constraints: BoxConstraints.expand(
                                                width: size * 0.3),
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(dayOptions[0],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16)),
                                                    Text(
                                                        "On ${leaveApplyModel.full_Date}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      dayOptions[1],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                    Text(" Total Days- 08",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(dayOptions[2],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16)),
                                                    Text("",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            isSelected:
                                                Provider.of<LeaveOperations>(
                                                        context,
                                                        listen: false)
                                                    .isSelectedForDays,
                                            onPressed: (int index) {
                                              defualtDayCount = index;
                                              Provider.of<LeaveOperations>(
                                                      context,
                                                      listen: false)
                                                  .setDay(index);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                      visible: Provider.of<LeaveOperations>(
                                              context,
                                              listen: false)
                                          .isSelectedForDays[0],
                                      child: InkWell(
                                        onTap: () async {
                                          final DateTime? d =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2099),
                                          );
                                          if (d != null)
                                            leaveApplyModel.full_Date =
                                                DateFormat.yMMMEd().format(d);
                                          Provider.of<LeaveOperations>(context,
                                                  listen: false)
                                              .setDate();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black26,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.calendar_month),
                                              Column(
                                                children: [
                                                  Text("Date",
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 12)),
                                                  Text(leaveApplyModel
                                                      .full_Date),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                  Visibility(
                                    visible: Provider.of<LeaveOperations>(
                                            context,
                                            listen: false)
                                        .isSelectedForDays[1],
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Text("From",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 12)),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    final DateTime? d =
                                                        await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    _dateTimeNotifier
                                                                        .value,
                                                                firstDate:
                                                                    DateTime(
                                                                        2000),
                                                                lastDate:
                                                                    DateTime(
                                                                        2099))
                                                            .then((dateTime) =>
                                                                _dateTimeNotifier
                                                                        .value =
                                                                    dateTime!);
                                                    if (d != null)
                                                      leaveApplyModel
                                                              .from_Date =
                                                          DateFormat.yMMMEd()
                                                              .format(d);
                                                    Provider.of<LeaveOperations>(
                                                            context,
                                                            listen: false)
                                                        .setDate();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.black26,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(Icons
                                                            .calendar_month),
                                                        Column(
                                                          children: [
                                                            Text("Date",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        12)),
                                                            Text(leaveApplyModel
                                                                .from_Date),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text("To",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 12)),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    DateTime? d =
                                                        await showDatePicker(
                                                      context: context,
                                                      firstDate:
                                                          _dateTimeNotifier
                                                              .value,
                                                      initialDate:
                                                          _dateTimeNotifier
                                                              .value,
                                                      lastDate: DateTime(2099),
                                                    );
                                                    if (d != null) {
                                                      // d = d!.add(Duration(days: 1,));
                                                      leaveApplyModel.to_Date =
                                                          DateFormat.yMMMEd()
                                                              .format(d);
                                                    }
                                                    var dateFrom =
                                                        DateTime.parse(
                                                            leaveApplyModel
                                                                .from_Date);

                                                    var dateTo = DateTime.parse(
                                                        leaveApplyModel
                                                            .to_Date);
                                                    final result = dateTo
                                                        .difference(dateFrom)
                                                        .inDays;
                                                    leaveApplyModel.no_of_days =
                                                        result.toString();

                                                    Provider.of<LeaveOperations>(
                                                            context,
                                                            listen: false)
                                                        .setDate();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.black26,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(Icons
                                                            .calendar_month),
                                                        Column(
                                                          children: [
                                                            Text("Date",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        12)),
                                                            Text(leaveApplyModel
                                                                .to_Date),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                      visible: Provider.of<LeaveOperations>(
                                              context,
                                              listen: false)
                                          .isSelectedForDays[2],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              final DateTime? d =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2099),
                                              );
                                              if (d != null)
                                                leaveApplyModel.half_Date =
                                                    DateFormat.yMMMEd()
                                                        .format(d);
                                              Provider.of<LeaveOperations>(
                                                      context,
                                                      listen: false)
                                                  .setDate();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Icon(Icons.calendar_month),
                                                  Column(
                                                    children: [
                                                      Text("Date",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 12)),
                                                      Text(leaveApplyModel
                                                          .half_Date),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Switch(
                                                onChanged: (bool value) {
                                                  if (isHalfDaySwitch ==
                                                      false) {
                                                    isHalfDaySwitch = true;
                                                    textValue = 'After Lunch';
                                                    Provider.of<LeaveOperations>(
                                                            context,
                                                            listen: false)
                                                        .setDate();
                                                  } else {
                                                    isHalfDaySwitch = false;
                                                    textValue = 'Before Lunch';
                                                    Provider.of<LeaveOperations>(
                                                            context,
                                                            listen: false)
                                                        .setDate();
                                                  }
                                                },
                                                value: isHalfDaySwitch,
                                              ),
                                              Text("Half Day :${textValue}",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12))
                                            ],
                                          )
                                        ],
                                      )),
                                  Divider(),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20,
                                        10,
                                        20,
                                        MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        leaveApplyModel.reason = value;
                                      },
                                      decoration: InputDecoration(
                                          hintText: '(optional)',
                                          labelText: 'Reason For Leave'),
                                    ),
                                  ),
                                ],
                              ),
                            )))
                      ])),
                ),
              ],
            ));
  }
}
