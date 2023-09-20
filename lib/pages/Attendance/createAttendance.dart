import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_month_picker/flutter_month_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:googlesheet/model/employeemodel.dart';
import 'package:googlesheet/model/leaveapplymodel.dart';
import 'package:googlesheet/operations/employeeOperation.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as Location1;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/approvialmodel.dart';
import '../../model/attendancemodel.dart';
import '../../model/user.dart';
import '../../operations/LeavesOperation.dart';
import '../../operations/approvialOperation.dart';
import '../../operations/attendanceOperations.dart';
import '../../operations/authOperations.dart';
import '../../operations/notification_services.dart';
import '../../themes/color.dart';
import '../../widgets/genericTile.dart';
import '../../widgets/stopwatchT.dart';
import '../Patients/ReceiptFormat/salarySlip.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/cupertino.dart';

class TimePickerModel extends ChangeNotifier {
  TimeOfDay _selectedTime = TimeOfDay.now();

  TimeOfDay get selectedTime => _selectedTime;

  void setSelectedTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }
}

class CreateAttendance extends StatefulWidget {
  const CreateAttendance({Key? key}) : super(key: key);

  @override
  State<CreateAttendance> createState() => _CreateAttendanceState();
}

class _CreateAttendanceState extends State<CreateAttendance> {
  GlobalKey<FormState> formskey = GlobalKey<FormState>();
  GlobalKey<FormState> form = GlobalKey<FormState>();

  late SharedPreferences logindata;
  FlutterTts flutterTts = FlutterTts();
  late String username;
  DateTime combinedDateTime2=DateTime.now();
  bool isUploaded = false;
  final DateFormat formatter = DateFormat('MMMM');
  final DateFormat formatter2 = DateFormat('MMM');
  final dd = new DateFormat('yyyy-MM-dd');
  late TextEditingController targetcontroller = TextEditingController();
  bool isAccepted = false;
  NotificationServices notificationServices = NotificationServices();
  List<Placemark> placemarks = [];
  bool isOutTinePatched=false;
  late TextEditingController Completecontroller = TextEditingController();
  late TextEditingController reviewscontroller = TextEditingController();
  late TextEditingController textController = TextEditingController();
  late TextEditingController logouttimetextController = TextEditingController();

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
      isWorking: "true",
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
  EmployModel newemployModel = EmployModel(
      id: "",
      date: "",
      empNumber: "",
      full_name: "",
      designation: "",
      mobile_no: "9867199955",
      alternate_no: "",
      email: "",
      gender: "",
      date_of_birth: "",
      address: "",
      pan_card: "",
      aadhar_card: "",
      user_identification: "",
      In_Time_1st: "",
      Out_Time_1st: "",
      In_Time_2nd: "",
      Out_Time_2nd: "",
      total_working_hours: "",
      working_days: "",
      sun_In_Time: "",
      sun_out_Time: "",
      sun_working_hours: "",
      number_of_sunday: "",
      salary: "",
      days: "",
      sal_per_days: "");
  approvalmodel Approvemodel = approvalmodel(
      id: "", name: "", outTime: "", reason: "", approved: "", rejected: "");
  double? lat, long; // longitude location
  int _selectedIndex = 0;
  bool isAdmin = false;
  late AuthData? staff;
  File? image;
  bool InOutToggle = false;
  bool intimesvisible = true;
  bool ContainerVisible = true;
  bool TextVisible = true;
  final DateFormat timeFormatter = DateFormat('hh:mm a');
  bool controllerVisible = true;
  List<AttendanceModel> existingList = [];
  late FirebaseStorage storage;
  TextEditingController reply = TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late TimeOfDay Time;

  Future<void> selectedTimefunction(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: Time,
    );

    if (picked != null && picked != Time) {
      setState(() {
        Time = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    Time = TimeOfDay.now();

    isAdmin = Provider.of<AuthOperation>(this.context, listen: false).isAdmin();
    staff = Provider.of<AuthOperation>(this.context, listen: false).user;
    Provider.of<EmployeeOperation>(this.context, listen: false)
        .getEmployeeFromSheet();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeOperation>(this.context, listen: false).isEmployee(
          Provider.of<AuthOperation>(this.context, listen: false).user.email);
    });

    existingList =
        Provider.of<AttendanceOperations>(this.context, listen: false)
            .workingList;
    Provider.of<LeaveOperations>(this.context, listen: false)
        .getLeaveDataFromSheet(
            Provider.of<AuthOperation>(this.context, listen: false).user.name,
            Provider.of<AuthOperation>(this.context, listen: false).isAdmin());
    var android = AndroidNotificationDetails(
      '112',
      'channel NAME',
      priority: Priority.high,
      importance: Importance.max,
      channelDescription: 'channel description',
      ticker: 'ticker',
      largeIcon: const DrawableResourceAndroidBitmap('justwater'),
      color: const Color(0xff2196f3),
    );
    var iOS = DarwinNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);

    NotificationDetails notiDetails =
        NotificationDetails(android: android, iOS: iOS);

    Provider.of<AprovelOperation>(this.context, listen: false).getFromSheet();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size2 = MediaQuery.of(context).size.height;
    return Consumer<AttendanceOperations>(
        builder: (context, orderData, child) => Form(
              key: formskey,
              child: Flex(direction: Axis.horizontal, children: [
                Expanded(
                  child: Column(
                    children: [
                      Card(
                        color: cardBackgroundColor,
                        elevation: 10,
                        shadowColor: appBarButtonBackColor,
                        margin: EdgeInsets.all(2),
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: appBarButtonBackColor, width: 1)),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 20),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/banner1.jpg',
                                height: 100,
                                scale: 2.5,
                                // color: Color.fromARGB(255, 15, 147, 59),
                                // opacity:
                                // const AlwaysStoppedAnimation<double>(0.5)
                              ),
                              Text(
                                staff!.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: textColor),
                              ),
                              Text(
                                staff!.designation,
                                style: TextStyle(color: textColor),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Visibility(
                                      visible: isAdmin,
                                      child: TextButton(
                                        child: Text("Create",style: TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                            color: Colors
                                                .black,
                                            fontSize: 12)),
                                        onPressed: () async {
                                          await Navigator.pushNamed(
                                              context, '/employeePage');
                                        },
                                      ),
                                    ),

                                    Visibility(
                                      visible: isAdmin,
                                      child: TextButton(
                                        child: Text("Branch Rev",style: TextStyle(
                                            fontWeight:
                                            FontWeight
                                            .bold,
                                            color: Colors
                                                .black,
                                            fontSize: 12)),
                                        onPressed: () async {
                                          await Navigator.pushNamed(
                                              context, '/employeePage');
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible: isAdmin,
                                      child: TextButton(
                                        child: Text("Available Staff",style:TextStyle(
                                            fontWeight:
                                            FontWeight
                                                .bold,
                                            color: Colors
                                                .black,
                                            fontSize: 12)),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              20))),
                                              builder: (context) {
                                                return Container(
                                                  width: double.minPositive,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: RichText(
                                                          text: TextSpan(
                                                            text:
                                                                "Available staff : ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 24),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text: Provider.of<
                                                                              AttendanceOperations>(
                                                                          context)
                                                                      .workingList
                                                                      .length
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .blue)),
                                                              TextSpan(
                                                                  text:
                                                                      ' Members',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black38,
                                                                      fontSize:
                                                                          16)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Visibility(
                                                        visible: isAdmin,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height:
                                                                  size2 * 0.35,
                                                              width: double
                                                                  .infinity,
                                                              child:
                                                                  SingleChildScrollView(
                                                                child:
                                                                    DataTable(
                                                                        horizontalMargin:
                                                                            2,
                                                                        columnSpacing:
                                                                            defaultPadding,
                                                                        columns: [
                                                                          DataColumn(
                                                                              label: Text("Name", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800))),
                                                                          DataColumn(
                                                                              label: Text("In / Out", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800))),
                                                                          DataColumn(
                                                                              label: Text("Map - Image - Target", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800))),

                                                                          //
                                                                          // DataColumn(
                                                                          //     label: Text("Targets",
                                                                          //         style: TextStyle(
                                                                          //             fontSize: 12,
                                                                          //             fontWeight: FontWeight.w800))),
                                                                        ],
                                                                        rows: List.generate(
                                                                            orderData
                                                                                .workingList.length,
                                                                            (index) =>
                                                                                availableStaffRow(orderData.workingList[index], context))),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                "Developed By Blue Horizon Automation Research",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blueAccent,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ), // For Admin Only
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                      ),
                                    ),

                                    Visibility(
                                      visible: isAdmin,
                                      child: TextButton(
                                        child: Text("Login CR",style:TextStyle(
                                            fontWeight:
                                            FontWeight
                                            .bold,
                                            color: Colors
                                                .black,
                                            fontSize: 12)),
                                        onPressed: () {
                                          setState(() {

                                          });
                                          showModalBottomSheet(
                                              context: context,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              20))),
                                              builder: (context) {
                                                return Container(
                                                  width: double.minPositive,
                                                  child: Column(
                                                    children: [
                                                      Card(
                                                        elevation: 10,
                                                        color: Colors
                                                            .lightBlue.shade50,
                                                        shadowColor:
                                                            Colors.black,
                                                        // margin: EdgeInsets.all(10),
                                                        child: ListTile(
                                                          title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      child: Text(
                                                                          "  Name  ",
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w800)),
                                                                    ),
                                                                    Container(
                                                                        child: Text(
                                                                            "  Reason  ",
                                                                            style:
                                                                                TextStyle(fontSize: 13, fontWeight: FontWeight.w800))),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                        "  Out time  ",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w800)),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                    "  Accept  ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w800)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      // Header
                                                      Expanded(
                                                        child:  FutureBuilder(
                                                            future:
                                                            Provider.of<AprovelOperation>(context, listen: false)
                                                                .getFromSheet(),

                                                            builder: (context, dataSnapshot) {
                                                              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                                                                return Center(
                                                                  child: CircularProgressIndicator(),
                                                                );
                                                              } else {
                                                                if (dataSnapshot.error != null) {
                                                                  return Center(
                                                                    child: Text('An error occured'),
                                                                  );
                                                                } else {

                                                                return  Consumer<AttendanceOperations>(
                                                                      builder: (context, orderData12, child){return ListView
                                                                          .builder(
                                                                          itemCount:
                                                                          Provider.of<AprovelOperation>(context, listen: false)
                                                                              .productList
                                                                              .length,
                                                                          itemBuilder:
                                                                              (BuildContext
                                                                          context,
                                                                              int index) {

                                                                            return Container(
                                                                              child:
                                                                              ListTile(
                                                                                title:
                                                                                Row(
                                                                                  mainAxisAlignment:
                                                                                  MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Consumer<AttendanceOperations>(
                                                                                        builder: (context, orderData12, child) => Column(
                                                                                          children: [
                                                                                            Text(  Provider.of<AprovelOperation>(context, listen: false).productList[index].name, style: TextStyle(color: Colors.black, fontSize: 15)),
                                                                                            Container(
                                                                                              child: Text(  Provider.of<AprovelOperation>(context, listen: false).productList[index].reason, style: TextStyle(color: Colors.black, fontSize: 15)),
                                                                                            ),
                                                                                            Container(
                                                                                              child: Text(timeFormatter.format(DateTime.parse(  Provider.of<AprovelOperation>(context, listen: false).productList[index].outTime).toLocal().subtract(Duration(minutes: 8))).toString(), style: TextStyle(color: Colors.black, fontSize: 15)),
                                                                                            ),
                                                                                          ],
                                                                                        )),
                                                                                    Consumer<AttendanceOperations>(
                                                                                        builder: (context, orderData12, child) => Container(
                                                                                          child:
                                                                                          Row(
                                                                                            children: [
                                                                                              IconButton(
                                                                                                  onPressed: () async{
                                                                                                    var  finalOutTimeGromAtt=DateTime.parse(Provider.of<AttendanceOperations>(context, listen: false).getAttendanceForOutTime(int.parse(  Provider.of<AprovelOperation>(context, listen: false).productList[index].id)).date);
                                                                                                    var dateConverted = DateTime.parse(  Provider.of<AprovelOperation>(context, listen: false).productList[index].outTime).toLocal().subtract(Duration(minutes: 8));
                                                                                                    DateTime now1 = DateTime.now();

                                                                                                    // Combine the current date with the selected TimeOfDay

                                                                                                   TimeOfDay finalTime =
                                                                                                        await Provider.of<AttendanceOperations>(
                                                                                                            context,
                                                                                                            listen: false)
                                                                                                            .selectTime(context);
                                                                                                     combinedDateTime2 = DateTime(
                                                                                                      finalOutTimeGromAtt.year,
                                                                                                      finalOutTimeGromAtt.month,
                                                                                                      finalOutTimeGromAtt.day,
                                                                                                      finalTime.hour,
                                                                                                      finalTime.minute,

                                                                                                    );
                                                                                                    isOutTinePatched=true;
                                                                                                    attendanceModel.out_time=combinedDateTime2.toString();

                                                                                                  },
                                                                                                  icon: Icon(Icons.watch_later)),
                                                                                              InkWell(
                                                                                                onTap: () =>
                                                                                                    Provider.of<AttendanceOperations>(
                                                                                                        context,
                                                                                                        listen: false)
                                                                                                        .selectTime(context),
                                                                                                child: Text(
                                                                                                  Provider.of<AttendanceOperations>(
                                                                                                      context,
                                                                                                      listen: false)
                                                                                                      .selectedRequestedTime !=
                                                                                                      null
                                                                                                      ? '${Provider.of<AttendanceOperations>(context, listen: false).selectedTime.format(context)}'
                                                                                                      : 'No time selected',
                                                                                                  style: TextStyle(fontSize: 18),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )),
                                                                                    Consumer<AprovelOperation>(
                                                                                      builder: (context, orderData12, child) => Container(
                                                                                        child: Row(
                                                                                          children: [
                                                                                            IconButton(
                                                                                              icon: Icon(
                                                                                                Icons.done_outline_outlined,
                                                                                                color: Colors.green,
                                                                                              ),
                                                                                              onPressed: () async {

                                                                                                var  finalOutTimeGromAtt=DateTime.parse(Provider.of<AttendanceOperations>(context, listen: false).getAttendanceForOutTime(int.parse(  Provider.of<AprovelOperation>(context, listen: false).productList[index].id)).date);
                                                                                                var dateConverted = DateTime.parse(  Provider.of<AprovelOperation>(context, listen: false).productList[index].outTime).toLocal().subtract(Duration(minutes: 8));


                                                                                                // Combine the current date with the selected TimeOfDay
                                                                                                DateTime combinedDateTime = DateTime(
                                                                                                  finalOutTimeGromAtt.year,
                                                                                                  finalOutTimeGromAtt.month,
                                                                                                  finalOutTimeGromAtt.day,
                                                                                                  dateConverted.hour,
                                                                                                  dateConverted.minute,
                                                                                                );

                                                                                                Provider.of<AprovelOperation>(context, listen: false).productList[index].outTime = combinedDateTime.toString();

if(isOutTinePatched){

  Provider.of<AprovelOperation>(context, listen: false).productList[index].outTime = combinedDateTime2.toString();

}
                                                                                                isOutTinePatched= false;
                                                                                                attendanceModel.out_time = (  Provider.of<AprovelOperation>(context, listen: false).productList[index].outTime);
                                                                                                attendanceModel.in_time = "--:--";

                                                                                                attendanceModel.acceptOrNot = "false";
                                                                                                attendanceModel.isWorking = "false";
                                                                                                attendanceModel.name = staff!.name;
                                                                                                attendanceModel.id = int.parse(  Provider.of<AprovelOperation>(context, listen: false).productList[index].id);

                                                                                                var totalDuration = Duration(minutes: 00, hours: 00, seconds: 00);
                                                                                                attendanceModel.totalHour = totalDuration.toString().substring(0, 4);
                                                                                                ContainerVisible = false;
                                                                                                TextVisible = false;
                                                                                                final put = attendanceModel.imagesemp.split("media");

                                                                                                // final hours = time.hour.toString().padLeft(2, '0');
                                                                                                // final minutes = time.minute.toString().padLeft(2, '0');
                                                                                                await Provider.of<AttendanceOperations>(context, listen: false).updateOutTime(attendanceModel);
                                                                                                Provider.of<AprovelOperation>(context, listen: false).deleteAcccept(index);
                                                                                              },
                                                                                              color: Colors.blue,
                                                                                            ),
                                                                                            // IconButton(
                                                                                            //   icon: Icon(
                                                                                            //     Icons.cancel,
                                                                                            //     color: Colors.red,
                                                                                            //   ),
                                                                                            //   onPressed: () {},

                                                                                            // ),
                                                                                          ],
                                                                                        ),
                                                                                      ),)
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            );
                                                                          });});

                                                                }
                                                              }
                                                            }),
                                                        // child: Consumer<
                                                        //         AprovelOperation>(
                                                        //     builder: (context,
                                                        //         myDataModel,
                                                        //         child) {
                                                        //   return ListView
                                                        //       .builder(
                                                        //           itemCount:
                                                        //               myDataModel
                                                        //                   .productList
                                                        //                   .length,
                                                        //           itemBuilder:
                                                        //               (BuildContext
                                                        //                       context,
                                                        //                   int index) {
                                                        //             return Container(
                                                        //               child:
                                                        //                   ListTile(
                                                        //                 title:
                                                        //                     Row(
                                                        //                   mainAxisAlignment:
                                                        //                       MainAxisAlignment.spaceBetween,
                                                        //                   children: [
                                                        //                     Consumer<AttendanceOperations>(
                                                        //                         builder: (context, orderData12, child) => Column(
                                                        //                               children: [
                                                        //                                 Text(myDataModel.productList[index].name, style: TextStyle(color: Colors.black, fontSize: 15)),
                                                        //                                 Container(
                                                        //                                   child: Text(myDataModel.productList[index].reason, style: TextStyle(color: Colors.black, fontSize: 15)),
                                                        //                                 ),
                                                        //                                 Container(
                                                        //                                   child: Text(timeFormatter.format(DateTime.parse(myDataModel.productList[index].outTime).toLocal().subtract(Duration(minutes: 8))).toString(), style: TextStyle(color: Colors.black, fontSize: 15)),
                                                        //                                 ),
                                                        //                               ],
                                                        //                             )),
                                                        //                     Consumer<AttendanceOperations>(
                                                        //                         builder: (context, orderData12, child) => Container(
                                                        //                               child: Row(
                                                        //                                 // Text(myDataModel.productList[index].outTime, style: TextStyle(color: Colors.black, fontSize: 15)),
                                                        //                                 children: [
                                                        //                                   IconButton(onPressed: () => Provider.of<AttendanceOperations>(context, listen: false).selectTime(context), icon: Icon(Icons.watch_later)),
                                                        //                                 ],
                                                        //                               ),
                                                        //                             )),
                                                        //                     Consumer<AprovelOperation>(
                                                        //                       builder: (context, orderData12, child) => Container(
                                                        //                       child: Row(
                                                        //                         children: [
                                                        //                           IconButton(
                                                        //                             icon: Icon(
                                                        //                               Icons.done_outline_outlined,
                                                        //                               color: Colors.green,
                                                        //                             ),
                                                        //                             onPressed: () async {
                                                        //                               var now = myDataModel.productList[index].outTime;
                                                        //                               final formatter = DateFormat('y-M-d H:mm:ss');
                                                        //                               var  finalOutTimeGromAtt=DateTime.parse(Provider.of<AttendanceOperations>(context, listen: false).getAttendanceForOutTime(int.parse(myDataModel.productList[index].id)).date);
                                                        //                               var dateConverted = DateTime.parse(myDataModel.productList[index].outTime).toLocal().subtract(Duration(minutes: 8));
                                                        //                               DateTime now1 = DateTime.now();
                                                        //
                                                        //                               // Combine the current date with the selected TimeOfDay
                                                        //                               DateTime combinedDateTime = DateTime(
                                                        //                                 finalOutTimeGromAtt.year,
                                                        //                                 finalOutTimeGromAtt.month,
                                                        //                                 finalOutTimeGromAtt.day,
                                                        //                                 dateConverted.hour,
                                                        //                                 dateConverted.minute,
                                                        //                               );
                                                        //
                                                        //                               myDataModel.productList[index].outTime = combinedDateTime.toString();
                                                        //                               String actualTime = now.toString();
                                                        //                               attendanceModel.date = actualTime;
                                                        //                               print(myDataModel.productList[index].outTime);
                                                        //
                                                        //                               attendanceModel.out_time = (myDataModel.productList[index].outTime);
                                                        //                               attendanceModel.in_time = "--:--";
                                                        //
                                                        //                               attendanceModel.acceptOrNot = "false";
                                                        //                               attendanceModel.isWorking = "false";
                                                        //                               attendanceModel.name = staff!.name;
                                                        //                               attendanceModel.id = int.parse(myDataModel.productList[index].id);
                                                        //
                                                        //                               var totalDuration = Duration(minutes: 00, hours: 00, seconds: 00);
                                                        //                               attendanceModel.totalHour = totalDuration.toString().substring(0, 4);
                                                        //                               ContainerVisible = false;
                                                        //                               TextVisible = false;
                                                        //                               final put = attendanceModel.imagesemp.split("media");
                                                        //
                                                        //                               // final hours = time.hour.toString().padLeft(2, '0');
                                                        //                               // final minutes = time.minute.toString().padLeft(2, '0');
                                                        //                               await Provider.of<AttendanceOperations>(context, listen: false).updateOutTime(attendanceModel);
                                                        //                             },
                                                        //                             color: Colors.blue,
                                                        //                           ),
                                                        //                           IconButton(
                                                        //                             icon: Icon(
                                                        //                               Icons.cancel,
                                                        //                               color: Colors.red,
                                                        //                             ),
                                                        //                             onPressed: () {},
                                                        //                           ),
                                                        //                         ],
                                                        //                       ),
                                                        //                     ),)
                                                        //                   ],
                                                        //                 ),
                                                        //               ),
                                                        //             );
                                                        //           });
                                                        // }),
                                                      ),
                                                      //  Row Data
                                                      Container(
                                                        child: Text(
                                                          "Developed By Blue Horizon Automation Research",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blueAccent,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                      ),
                                    ),

                                    // gaurav

                                    Visibility(
                                      visible: isAdmin,
                                      child: TextButton(
                                        child: Text("Leave",style:TextStyle(
                                            fontWeight:
                                            FontWeight
                                            .bold,
                                            color: Colors
                                                .black,
                                            fontSize: 12)),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              20))),
                                              builder: (context) {
                                                return Container(
                                                  width: double.minPositive,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Consumer<
                                                            LeaveOperations>(
                                                          builder: (context,
                                                                  orderData,
                                                                  child) =>
                                                              RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  "Leave Applications ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 24),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: Provider.of<LeaveOperations>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .leaveApplyActiveList
                                                                        .length
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .blue)),
                                                                TextSpan(
                                                                    text:
                                                                        ' Pending',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black38,
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Consumer<LeaveOperations>(
                                                        builder: (context,
                                                                leaveSummaryData,
                                                                child) =>
                                                            Visibility(
                                                          visible: isAdmin,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: size2 *
                                                                    0.35,
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: DataTable(
                                                                      horizontalMargin: 2,
                                                                      columnSpacing: defaultPadding,
                                                                      columns: [
                                                                        DataColumn(
                                                                            label:
                                                                                Text("Name", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800))),
                                                                        DataColumn(
                                                                            label:
                                                                                Text("Date - NoDay - Reason ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800))),
                                                                        DataColumn(
                                                                            label:
                                                                                Text("Accept/Reject", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800))),

                                                                        //
                                                                        // DataColumn(
                                                                        //     label: Text("Targets",
                                                                        //         style: TextStyle(
                                                                        //             fontSize: 12,
                                                                        //             fontWeight: FontWeight.w800))),
                                                                      ],
                                                                      rows: List.generate(Provider.of<LeaveOperations>(context).leaveApplyActiveList.length, (index) => leaveApplicationRow(Provider.of<LeaveOperations>(context).leaveApplyActiveList[index], context))),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  "Developed By Blue Horizon Automation Research",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blueAccent,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ) // For Admin Only
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Create Attendance Visibility
                      Visibility(
                        visible: !isAdmin,
                        child: Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Consumer<AttendanceOperations>(
                                    builder: (context, orderData, child) {
                                  return Visibility(
                                      visible:
                                          Provider.of<AttendanceOperations>(
                                                  context,
                                                  listen: false)
                                              .isWorking,
                                      child: buildDateCard(context));
                                }),
                                buildTargetCard(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(), // For Employee Only
                      Visibility(
                        visible: isAdmin,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white54,
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
                                child: RichText(
                                  text: TextSpan(
                                    text: "Staff Window : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 24),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: Provider.of<EmployeeOperation>(
                                                  context)
                                              .employData
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)),
                                      TextSpan(
                                          text: '  Members',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black38,
                                              fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Provider.of<AttendanceOperations>(
                                                context,
                                                listen: false)
                                            .notifyOnly();
                                      },
                                      icon: Icon(Icons.refresh)),
                                  RichText(
                                    text: TextSpan(
                                      text: "Available Members : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontSize: 16),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: Provider.of<
                                                        AttendanceOperations>(
                                                    context)
                                                .workingList
                                                .length
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blue)),
                                        TextSpan(
                                            text: '  Members',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black38,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                          lastDate: DateTime.parse(
                                              Provider.of<AttendanceOperations>(
                                                      context,
                                                      listen: false)
                                                  .attendanceData
                                                  .first
                                                  .date),
                                        ))!;
                                        await orderData
                                            .getMonthlyList(selectedDate);
                                        // dateController.text =
                                        //     date.toString().substring(0, 10);
                                      },
                                      icon: Icon(Icons.date_range),
                                      label: Text(
                                          "${formatter2.format(orderData.selectedMonth)} - ${orderData.selectedMonth.year}")),
                                ],
                              ),
                              SizedBox(
                                height: size2 * 0.32,
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  child: DataTable(
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.blue.shade100),
                                      dataRowColor:
                                          MaterialStateColor.resolveWith(
                                        (states) => Colors.blueGrey.shade50,
                                      ),
                                      dividerThickness: 1,
                                      horizontalMargin: 2,
                                      columnSpacing: tableDefaultPadding,
                                      columns: [
                                        DataColumn(
                                            label: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text("Name",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800)),
                                        )),
                                        DataColumn(
                                            label: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text("Report And Contact",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800)),
                                        )),
                                      ],
                                      rows: List.generate(
                                          Provider.of<EmployeeOperation>(
                                                  context,
                                                  listen: false)
                                              .employData
                                              .length,
                                          (index) =>
                                              allEmployeeForMonthlyReportRow(
                                                  Provider.of<EmployeeOperation>(
                                                          context,
                                                          listen: false)
                                                      .employData[index],
                                                  context))),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Developed By Blue Horizon Automation Research",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ), // For Admin Only
                    ],
                  ),
                ),
              ]),
            ));
  }

  // For Both Admin as well Employee
  //Create Attendance Cards
  Card buildDateCard(BuildContext context) {
    return Card(
      color: cardBackgroundColor,
      elevation: 10,
      shadowColor: appBarButtonBackColor,
      margin: EdgeInsets.all(10),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: appBarButtonBackColor, width: 1)),
      child: Container(
        // padding: EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              'Working Hours',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 25, color: textColor),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<AttendanceOperations>(
                    builder: (context, orderData, child) => Visibility(
                        visible: Provider.of<AttendanceOperations>(context,
                                listen: false)
                            .isWorking,
                        child: StopWatchTimerPage())),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    );
  } // For Employee Only

  Card buildTargetCard(BuildContext context) {
    return Card(
      elevation: 10,
      color: cardBackgroundColor,
      shadowColor: appBarButtonBackColor,
      margin: EdgeInsets.all(10),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: appBarButtonBackColor, width: 1)),
      child: Container(
        padding: EdgeInsets.only(left: 40, right: 40),
        child: Column(
          children: [
            // image != null
            //     ? Image.file(
            //   image!,
            //   height: 360,
            //   width: 260,
            //   fit: BoxFit.cover,
            // )
            //     : CircleAvatar(
            //   backgroundImage: AssetImage('assets/camera.png'),
            // ),
            SizedBox(
              height: 16,
            ),
            InkWell(
              onTap: () async {
                image = await Provider.of<AttendanceOperations>(context,
                        listen: false)
                    .pickImage(ImageSource.camera);
                await uploadfiles();
                // await getLatLong();
              },
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    radius: 52.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: (image != null)
                          ? Image.file(image!)
                          : Image.asset('assets/camera.png'),
                    ),
                  ),
                  Visibility(
                      visible: isUploaded,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Icon(Icons.cloud_done, color: Colors.green),
                            ),
                            Text("Selfie Uploaded"),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              Provider.of<AttendanceOperations>(context, listen: false)
                      .isWorking
                  ? 'Completions'
                  : 'Targets',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 25, color: textColor),
            ),
            SizedBox(
              height: 15,
            ),

            Container(
              child: TextFormField(
                controller: targetcontroller,
                onChanged: (value) {
                  Provider.of<AttendanceOperations>(context, listen: false)
                          .isWorking
                      ? attendanceModel.completion = value
                      : attendanceModel.target = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter your task';
                  }
                },
                decoration: InputDecoration(
                    hintText:
                        ContainerVisible ? 'Enter Your Target' : 'Completion',
                    labelText: ContainerVisible ? 'Target' : 'Completion',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: 15,
            ),

            Consumer<AttendanceOperations>(
              builder: (context, orderData, child) => Row(
                children: [
                  IconButton(
                      onPressed: () {
                        orderData.setIsDone();
                      },
                      icon: Icon(Icons.refresh)),
                  ElevatedButton(
                    child: Text(Provider.of<AttendanceOperations>(context,
                                listen: false)
                            .isWorking
                        ? 'Out Time Entry'
                        : 'In Time Entry'),
                    style: ElevatedButton.styleFrom(
                      primary: Provider.of<AttendanceOperations>(context,
                                  listen: false)
                              .isDone
                          ? Colors.grey
                          : appBarButtonBackColor,
                      onPrimary: textColor,
                      shadowColor: appBarButtonBackColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      minimumSize: Size(200, 40),
                    ),
                    onPressed: () {
                      Provider.of<AttendanceOperations>(context, listen: false)
                              .isDone
                          ? null
                          : submitForm(context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  } // For Employee Only

  //Method list of employees Table

  DataRow allEmployeeForMonthlyReportRow(
      EmployModel employModel, BuildContext context) {
    bool isEmailEmpty = false;
    bool isPhoneEmpty = false;
    final width = MediaQuery.of(context).size.width;
    final hei = MediaQuery.of(context).size.height;
    bool isWorkingAttendanceD = false;
    bool noData = false;
    DateTime now = DateTime.now();
    Duration difference = now.difference(now);
    DateTime dateTimelast = DateTime.now();
    DateTime dateTime2last = DateTime.now();

    Provider.of<AttendanceOperations>(context, listen: false)
        .allAttendanceData
        .map((element) {
      if ((employModel.full_name == element.name) &&
          (element.isWorking == "false") &&
          !noData) {
        dateTimelast = DateTime.parse(element.date);
        noData = true;
      }
    }).toList();

    Provider.of<AttendanceOperations>(context, listen: false)
        .workingList
        .map((element) {
      if ((employModel.full_name == element.name) &&
          (element.isWorking == "true")) {
        difference = now.difference(DateTime.parse(element.in_time));
        isWorkingAttendanceD = true;
      }
    }).toList();
    final f = new DateFormat('HH:mm');
    if (employModel != null) {}
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();

    return DataRow(cells: [
      DataCell(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(employModel.full_name,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                Visibility(
                  visible: isWorkingAttendanceD,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isWorkingAttendanceD,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Text(
                    "${difference.inHours.toString()} hr ${difference.inMinutes.remainder(60).toString()} min ago",
                    style: TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.w400)),
              ),
            ),
            Visibility(
              visible: !isWorkingAttendanceD && noData,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Text("Last Entry: ${dd.format(dateTimelast)} ",
                    style: TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.w400)),
              ),
            ),
            Visibility(
              visible: !noData,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Text("no entry",
                    style: TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      )),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.picture_as_pdf_sharp,
              color: Colors.red,
            ),
            onPressed: () async {
              await Provider.of<AttendanceOperations>(context, listen: false)
                  .setMonthlyAttendance(employModel.full_name, employModel);
              await GenerateSalarySlipPdf(
                      employModel: employModel,
                      flag: true,
                      attendanceList: Provider.of<AttendanceOperations>(context,
                              listen: false)
                          .tempMonthlyCalculationData,
                      requiredHours: Provider.of<AttendanceOperations>(context,
                              listen: false)
                          .requiredHours,
                      totalHour: Provider.of<AttendanceOperations>(context,
                              listen: false)
                          .totalHour,
                      salary: Provider.of<AttendanceOperations>(context,
                              listen: false)
                          .salary,
                      getSalary: Provider.of<AttendanceOperations>(context,
                              listen: false)
                          .getSalary,
                      servedHours:
                          Provider.of<AttendanceOperations>(context, listen: false)
                              .servedHours)
                  .generateInvoice(employModel);
              // var latitude = double.parse(employModel.latitude);
              // var longitude = double.parse(employModel.longitude);
              // MapsLauncher.launchCoordinates(latitude, longitude);
            },
            color: Colors.blue,
          ),
          Visibility(
            visible: isWorkingAttendanceD,
            child: IconButton(
              icon: Icon(Icons.volume_up_rounded),
              onPressed: () async {
                await flutterTts.setLanguage("en-US");
                await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
                await flutterTts.speak(
                    " ${employModel.full_name}, please contact to Doctor Ramesh");

                // List<EducationBillFormat> listDetails = [];
                // UsersSheetsApi.donationTransactionsList.map((e) {
                //   if (e.donatorName == educationBillFormat.donatorName &&
                //       e.donatorPhoneNumber ==
                //           educationBillFormat.donatorPhoneNumber) {
                //     listDetails.add(e);
                //   }
                // }).toList();
                // Navigator.of(context).pushNamed(                //     DonatorDonationBillDetails.routeName,
                //     arguments: listDetails);
              },
              color: Theme.of(context).primaryColor,
            ),
          ),
          IconButton(
            icon: Icon(
              MdiIcons.whatsapp,
              color: Colors.green,
            ),
            onPressed: () async {
              await openWhatsApp(
                  employModel.mobile_no, "Hello ${employModel.full_name}, \n ");
              // launch(employModel.imagesemp);
            },
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
                child: IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    Uri phoneno = Uri.parse('tel:+91${employModel.mobile_no}');
                    if (await launchUrl(phoneno)) {
                      //dialer opened
                    } else {
                      //dailer is not opened
                    }
                    // launch(employModel.imagesemp);
                  },
                ),
              ),
              PopupMenuItem<int>(
                value: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.message,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    var uri =
                        'sms:+91${employModel.mobile_no}?body=Hello ${employModel.full_name}, \n ';
                    if (await canLaunchUrl(Uri.parse(uri))) {
                      await launchUrl(Uri.parse(uri));
                    } else {
                      // iOS
                      const uri = 'sms:0039-222-060-888?body=hello%20there';
                      if (await canLaunchUrl(Uri.parse(uri))) {
                        await canLaunchUrl(Uri.parse(uri));
                      } else {
                        throw 'Could not launch $uri';
                      }
                      // var latitude = double.parse(employModel.latitude);
                      // var longitude = double.parse(employModel.longitude);
                      // MapsLauncher.launchCoordinates(latitude, longitude);
                    }
                  },
                  color: Colors.blue,
                ),
              ),
              PopupMenuItem<int>(
                value: 0,
                child: IconButton(
                  icon: Icon(
                    MdiIcons.gmail,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    String email = Uri.encodeComponent(employModel.email);
                    String subject = Uri.encodeComponent("Title");
                    String body =
                        Uri.encodeComponent("Hello ${employModel.full_name}");
                    //output: Hello%20Flutter
                    Uri mail =
                        Uri.parse("mailto:$email?subject=$subject&body=$body");
                    if (await launchUrl(mail)) {
                      //email app opened
                    } else {
                      //email app is not opened
                    }
                  },
                  color: Colors.blue,
                ),
              ),
            ],
            // onSelected: (item) => SelectedItem(context, item),
          )
        ],
      )),
      // DataCell(TextButton(
      //   onPressed: () {},
      //   child: IconButton(
      //     icon: Icon(
      //       Icons.info_sharp,
      //       color: isEmailEmpty ? Colors.blue : Colors.black12,
      //     ),
      //     onPressed: () {
      //       showDialog(
      //         builder: (ctx) => AlertDialog(
      //           title: Text("Targets /Completion"),
      //           content: Text(attendanceModel.target),
      //           actions: <Widget>[
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceAround,
      //               children: [
      //                 ElevatedButton(onPressed: () {}, child: Text("Reply")),
      //                 ElevatedButton(onPressed: () {}, child: Text("Accept")),
      //               ],
      //             )
      //           ],
      //         ),
      //         context: this.context,
      //       );
      //     },
      //     color: Colors.blue,
      //   ),
      // )),
    ]);
  } // For admin Only

  DataRow availableStaffRow(
      AttendanceModel attendanceModel, BuildContext context) {
    bool isEmailEmpty = false;
    bool isPhoneEmpty = false;
    final width = MediaQuery.of(context).size.width;
    final hei = MediaQuery.of(context).size.height;

    final f = new DateFormat('HH:mm');
    if (attendanceModel != null) {
      isEmailEmpty = attendanceModel.location.isNotEmpty;
      isPhoneEmpty = attendanceModel.imagesemp.isNotEmpty;
    }
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();

    return DataRow(cells: [
      DataCell(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(attendanceModel.name,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
      )),
      DataCell(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                    attendanceModel.in_time == "--:--"
                        ? "${attendanceModel.out_time.substring(0, 10)}  "
                        : "${attendanceModel.in_time.substring(0, 10)}  ",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    attendanceModel.in_time == "--:--"
                        ? f.format(
                            DateTime.parse(attendanceModel.out_time).toLocal())
                        : f.format(
                            DateTime.parse(attendanceModel.in_time).toLocal()),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Icon(
                  attendanceModel.in_time == "--:--"
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: attendanceModel.in_time == "--:--"
                      ? Colors.red
                      : Colors.green,
                )
              ],
            ),
          ],
        ),
      )),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.location_on,
              color: isEmailEmpty ? Colors.blue : Colors.black12,
            ),
            onPressed: () {
              var latitude = double.parse(attendanceModel.latitude);
              var longitude = double.parse(attendanceModel.longitude);
              MapsLauncher.launchCoordinates(latitude, longitude);
            },
            color: Colors.blue,
          ),
          IconButton(
            icon: Icon(
              Icons.image,
              color: isPhoneEmpty ? Colors.black : Colors.black12,
            ),
            onPressed: () {
              launch(attendanceModel.imagesemp);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.info_sharp,
              color: isEmailEmpty ? Colors.blue : Colors.black12,
            ),
            onPressed: () {
              showDialog(
                builder: (ctx) => AlertDialog(
                  title: Text("Targets /Completion"),
                  content: Text(attendanceModel.target),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0)), //this right here
                                      child: Container(
                                        height: hei * 0.4,
                                        width: width * 0.7,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: TextField(
                                                  autofocus: true,
                                                  controller: reply,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Enter the reply for Target',
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Provider.of<AttendanceOperations>(
                                                          context,
                                                          listen: false)
                                                      .updateReview(
                                                          attendanceModel.id,
                                                          reply.text,
                                                          true);
                                                },
                                                child: Text("Submit"))
                                          ],
                                        ),
                                        // ElevatedButton(onPressed: () {}, child: Text("Accept")),
                                      ),
                                    );
                                  });
                            },
                            child: Text("Reply")),
                        ElevatedButton(
                            onPressed: () {
                              isAccepted = true;
                              Navigator.pop(context);
                              Provider.of<AttendanceOperations>(context,
                                      listen: false)
                                  .updateReview(
                                      attendanceModel.id, reply.text, true);
                              // showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return Dialog(
                              //         shape: RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.circular(
                              //                 20.0)), //this right here
                              //         child: Container(
                              //           height: hei * 0.4,
                              //           width: width * 0.7,
                              //
                              //           padding: EdgeInsets.all(100.0),
                              //           child: Column(
                              //             // crossAxisAlignment: CrossAxisAlignment.center,
                              //             children: [
                              //               ElevatedButton(
                              //                   onPressed: () {
                              //                     isAccepted = true;
                              //                     print(isAccepted);
                              //                   },
                              //                   child: Text("Submit"))
                              //             ],
                              //           ),
                              //           // ElevatedButton(onPressed: () {}, child: Text("Accept")),
                              //         ),
                              //       );
                              //     });
                            },
                            child: Text("Accept")),
                      ],
                    )
                  ],
                ),
                context: this.context,
              );
            },
            color: Colors.blue,
          ),
        ],
      )),
      // DataCell(TextButton(
      //   onPressed: () {},
      //   child: IconButton(
      //     icon: Icon(
      //       Icons.info_sharp,
      //       color: isEmailEmpty ? Colors.blue : Colors.black12,
      //     ),
      //     onPressed: () {
      //       showDialog(
      //         builder: (ctx) => AlertDialog(
      //           title: Text("Targets /Completion"),
      //           content: Text(attendanceModel.target),
      //           actions: <Widget>[
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceAround,
      //               children: [
      //                 ElevatedButton(onPressed: () {}, child: Text("Reply")),
      //                 ElevatedButton(onPressed: () {}, child: Text("Accept")),
      //               ],
      //             )
      //           ],
      //         ),
      //         context: this.context,
      //       );
      //     },
      //     color: Colors.blue,
      //   ),
      // )),
    ]);
  } // For admin Only

  DataRow leaveApplicationRow(
      LeaveApplyModel leaveApplyModel, BuildContext context) {
    bool isEmailEmpty = false;
    bool isPhoneEmpty = false;
    final width = MediaQuery.of(context).size.width;
    final hei = MediaQuery.of(context).size.height;

    final f = new DateFormat('HH:mm');

    if (leaveApplyModel != null) {
      isEmailEmpty = leaveApplyModel.emp_name.isNotEmpty;
      isPhoneEmpty = leaveApplyModel.applicationDate.isNotEmpty;
    }
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();

    return DataRow(cells: [
      DataCell(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Text(leaveApplyModel.emp_name,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            Text(leaveApplyModel.leave_Type,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
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
                    dd.format(DateTime.parse(leaveApplyModel.full_Date)),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      )),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.done_outline_outlined,
              color: Colors.green,
            ),
            onPressed: () {
              Provider.of<LeaveOperations>(context, listen: false)
                  .excecuteLeaveOperation(
                      leaveApplyModel.id,
                      "Accepted",
                      Provider.of<AuthOperation>(this.context, listen: false)
                          .isAdmin());
            },
            color: Colors.blue,
          ),
          IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.red,
            ),
            onPressed: () {
              Provider.of<LeaveOperations>(context, listen: false)
                  .excecuteLeaveOperation(
                      leaveApplyModel.id,
                      "Rejected",
                      Provider.of<AuthOperation>(this.context, listen: false)
                          .isAdmin());
            },
          ),
        ],
      )),
      // DataCell(TextButton(
      //   onPressed: () {},
      //   child: IconButton(
      //     icon: Icon(
      //       Icons.info_sharp,
      //       color: isEmailEmpty ? Colors.blue : Colors.black12,
      //     ),
      //     onPressed: () {
      //       showDialog(
      //         builder: (ctx) => AlertDialog(
      //           title: Text("Targets /Completion"),
      //           content: Text(attendanceModel.target),
      //           actions: <Widget>[
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceAround,
      //               children: [
      //                 ElevatedButton(onPressed: () {}, child: Text("Reply")),
      //                 ElevatedButton(onPressed: () {}, child: Text("Accept")),
      //               ],
      //             )
      //           ],
      //         ),
      //         context: this.context,
      //       );
      //     },
      //     color: Colors.blue,
      //   ),
      // )),
    ]);
  }

  //Submit Attendance Application
  void submitForm(BuildContext context) async {
    Provider.of<AttendanceOperations>(context, listen: false).setIsDone();

    var now = DateTime.now();
    String actualTime = now.toString();
    if (!formskey.currentState!.validate()) {
      return;
    }

    formskey.currentState?.save();
    // if (attendanceModel.imagesemp.isEmpty) {
    //   _shoToast("Please select image");
    //   return;
    // }
    attendanceModel.name = staff!.name;
    DateTime currentDate = DateTime.now();
    TimeOfDay time = TimeOfDay(hour: 11, minute: 30);

    var inDate = Provider.of<AttendanceOperations>(context, listen: false)
            .workingList
            .isEmpty
        ? currentDate
        : DateTime.parse(
            Provider.of<AttendanceOperations>(context, listen: false)
                .workingList[0]
                .in_time);

    DateTime actualDate = DateTime(2023, 7, 4);
    if (Provider.of<AttendanceOperations>(context, listen: false).isWorking &&
        currentDate.day == inDate.day) {
      Provider.of<AttendanceOperations>(context, listen: false).inTime();
      attendanceModel.date = actualTime;
      attendanceModel.out_time = actualTime;
      attendanceModel.in_time = "--:--";

      attendanceModel.acceptOrNot = "false";
      attendanceModel.isWorking = "false";
      attendanceModel.name = staff!.name;
      attendanceModel.id =
          Provider.of<AttendanceOperations>(context, listen: false)
              .workingList[0]
              .id;

      var seconds = (DateTime.parse(attendanceModel.out_time)
          .difference(inDate)
          .inSeconds);

      var totalDuration = Duration(minutes: 00, hours: 00, seconds: seconds);
      attendanceModel.totalHour = totalDuration.toString().substring(0, 4);
      ContainerVisible = false;
      TextVisible = false;
      final put = attendanceModel.imagesemp.split("media");

      // final hours = time.hour.toString().padLeft(2, '0');
      // final minutes = time.minute.toString().padLeft(2, '0');
      await Provider.of<AttendanceOperations>(context, listen: false)
          .updateOutTime(attendanceModel);
      Provider.of<AttendanceOperations>(context, listen: false).isWorking =
          false;
      notificationServices.notificationSend(attendanceModel, false,
          Provider.of<AuthOperation>(this.context, listen: false).deviceToken);
      _shoToast("Out Time Entry stored, Thank You");
    } else if (Provider.of<AttendanceOperations>(context, listen: false)
            .isWorking &&
        currentDate.day != inDate.day) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: AlertDialog(
                title: Center(child: Text('        OUT TIME AlERT      ')),
                content: Form(
                  key: form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Consumer<AttendanceOperations>(
                          builder: (context, orderData12, child) => Container(
                                child:
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Approvemodel.outTime =
                                              Provider.of<AttendanceOperations>(
                                                      context,
                                                      listen: false)
                                                  .selectTime(context)
                                                  .toString();
                                        },
                                        icon: Icon(Icons.watch_later)),
                                    InkWell(
                                      onTap: () =>
                                          Provider.of<AttendanceOperations>(
                                                  context,
                                                  listen: false)
                                              .selectTime(context),
                                      child: Text(
                                        Provider.of<AttendanceOperations>(
                                                        context,
                                                        listen: false)
                                                    .selectedRequestedTime !=
                                                null
                                            ? '${Provider.of<AttendanceOperations>(context, listen: false).selectedTime.format(context)}'
                                            : 'No time selected',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                      TextFormField(
                        controller: textController,
                        onSaved: (value) {
                          Approvemodel.reason = value!;
                          // textController.clear();
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter the Reason',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      IconButton(
                        icon: Icon(
                          MdiIcons.whatsapp,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          if (!form.currentState!.validate()) {
                            return;
                          }

                          form.currentState?.save();
                          Provider.of<AprovelOperation>(context, listen: false)
                              .submitForm(
                                  Approvemodel,
                                  Provider.of<AttendanceOperations>(context,
                                          listen: false)
                                      .workingList[0],
                                  Provider.of<AttendanceOperations>(context,
                                          listen: false)
                                      .selectedTime
                                      .format(context));
                          // DateTime combinedDateTime = DateTime(
                          //   finalOutTimeGromAtt.year,
                          //   finalOutTimeGromAtt.month,
                          //   finalOutTimeGromAtt.day,
                          //   dateConverted.hour,
                          //   dateConverted.minute,
                          // );
                          //
                          // myDataModel.productList[index].outTime = combinedDateTime.toString();
                          var dateConverted = DateTime.parse( Provider.of<AttendanceOperations>(context,
                              listen: false)
                              .workingList[0].date).toLocal().subtract(Duration(minutes:8));
                          openWhatsApp(newemployModel.mobile_no,
                              "*NAME* - ${Provider.of<AttendanceOperations>(context,
                              listen: false)
                              .workingList[0].name} \n \n*LOGOUT TIME FORGOT APPROVIAL FOR TODAYS LOGIN* \n \n*LOGOUT TIME* - ${Provider.of<AttendanceOperations>(context, listen: false).selectedTime.format(context)} on ${dd.format(dateConverted)}. \n \n*REASION* - ${Approvemodel.reason}");
                          // launch(employModel.imagesemp);
                        },
                      ),
                    ],
                  ),
                ),

                // actions: <Widget>[
                //   TextButton(
                //     child: Text('Close'),
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //     },
                //   ),
                // ],
              ),
            );
          });
    } else {
      Provider.of<AttendanceOperations>(context, listen: false).inTime();
      attendanceModel.in_time = actualTime;
      attendanceModel.out_time = "--:--";
      attendanceModel.acceptOrNot = "false";
      attendanceModel.totalHour = "0";
      attendanceModel.weekOff = "0";
      attendanceModel.leave = "0";
      attendanceModel.reqWorkigHours = "0";
      attendanceModel.workedDays = "0";
      attendanceModel.dailyPayment = "0";
      attendanceModel.month = "0";

      attendanceModel.date = actualTime;
      attendanceModel.isWorking = "true";
      ContainerVisible = true;
      TextVisible = true;
      // await Provider.of<AttendanceOperations>(context, listen: false)
      //     .writeattendance(attendanceModel);
      await Provider.of<AttendanceOperations>(context, listen: false)
          .submitForm(attendanceModel)
          .then((value) {
        print(value);

        notificationServices.notificationSend(
            attendanceModel,
            true,
            Provider.of<AuthOperation>(this.context, listen: false)
                .deviceToken);
        _shoToast("In Time Entry stored, Thank You");
      });
    }

    attendanceModel = AttendanceModel(
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
        isWorking: "false",
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
    targetcontroller.clear();
    reviewscontroller.clear();
    Completecontroller.clear();
    clearData();
  }

  //Notification Method

  clearData() {
    setState(() {
      image = null;
    });
  } // For Employee Only

  void _shoToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT, //duration
        gravity: ToastGravity.CENTER, //location
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black38, //background color
        textColor: Colors.white, //text Color
        fontSize: 20.0 //font size
        );
  }

  //File Upload From Firease
  uploadfiles() async {
    if (image == null) return;
    final fileName = basename(image!.path);
    final destination = 'EmployImage/';

    Reference ref = storage
        .ref(destination)
        .child("EmployImages" + DateTime.now().toString());
    await ref.putFile(image!);
    isUploaded = true;
    attendanceModel.imagesemp = await ref.getDownloadURL();

    // UploadTask uploadTask = ref.putFile(image!);
    // uploadTask.then((res) {
    //   res.ref.getDownloadURL();
    //   print(res);
    // });
  } // For Employee Only

  //Latitude and longitude Information
  // For convert lat long to address

  // getLatLong() {
  //   Future<Position> data = _determinePosition();
  //
  //   data.then((value) {
  //     lat = value.latitude;
  //     long = value.longitude;
  //     // attendanceModel.longLat = "${value.latitude},${value.longitude}";
  //     // print(attendanceModel.longLat);
  //     attendanceModel.latitude = lat.toString();
  //     attendanceModel.longitude = long.toString();
  //     getAddress(value.latitude, value.longitude);
  //   }).catchError((error) {
  //     print("Error $error");
  //   });
  // } // For Employee Only
  //
  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   var location = Location1.Location();
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     bool isturnedon = await location.requestService();
  //     if (isturnedon) {
  //       print("GPS device is turned ON");
  //     } else {
  //       print("GPS Device is still OFF");
  //     }
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // } // For Employee Only

  getAddress(lat, long) async {
    placemarks = await placemarkFromCoordinates(lat, long);

    attendanceModel.location = placemarks[0].street! +
        " " +
        placemarks[0].locality! +
        " " +
        placemarks[0].postalCode! +
        placemarks[0].country!;

    for (int i = 0; i < placemarks.length; i++) {}
  } // For Employee Only

  Future<void> openWhatsApp(String phoneNumber, String message) async {
    String url =
        "whatsapp://send?phone=$phoneNumber&text=${message}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(
        url,
      ));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _selecteddTime(BuildContext context) async {
    TimePickerModel timePickerModel =
        Provider.of<TimePickerModel>(context, listen: false);
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: timePickerModel.selectedTime,
    );

    if (pickedTime != null) {
      timePickerModel.setSelectedTime(pickedTime);
    }
  }
}
