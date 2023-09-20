import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:googlesheet/model/attendancemodel.dart';
import 'package:googlesheet/operations/dropDownListOperation.dart';
import 'package:googlesheet/operations/employeeOperation.dart';
import 'package:googlesheet/pages/Attendance/attendance_page.dart';
import 'package:googlesheet/pages/Patients/createPatients.dart';
import 'package:googlesheet/pages/loginpage.dart';
import 'package:googlesheet/pages/Patients/patientPage.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/user.dart';
import '../operations/attendanceOperations.dart';
import '../operations/authOperations.dart';
import '../operations/notification_services.dart';
import '../themes/client_company_info.dart';
import '../themes/color.dart';
import 'Attendance/attendanceHistory.dart';
import 'Leaves/leaveMainPage.dart';
import 'Patients/Appointment/createAppointment.dart';
import 'Patients/createDiagnosisMainPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationServices notificationServices = NotificationServices();
  final tabs = [
    AttendancePage(),
    CreateDiagnosisMainPage(),
    LeaveMainPage(),
  ];
  late SharedPreferences logindata;
  bool isAdmin = false;
  late AuthData? staff;
  int _selectedIndex = 0;
  File? image;
  TextEditingController issueController =
      TextEditingController(text: "Data Not Found");

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(this.context);
    notificationServices.isRefresh();
    notificationServices.getDeviceTaken().then((value) async {
      if (Provider.of<AuthOperation>(this.context, listen: false).isAdmin()) {
        await http.post(
            Uri.parse(
                'https://script.google.com/macros/s/AKfycbyqVVvJZbOFwpoaoqqT8jkeA8aVnUFgbaFvA3ZgRXmqGHlUTmASpt0MKFzfnGyf9i8ZWA/exec'),
            body: {
              'token': value,
              'time': DateTime.now().toString()
            }).then((response) {});
      } else {
        http
            .get(Uri.parse(
                'https://script.google.com/macros/s/AKfycbz8HirFso5bcZqk4WhUK06eTBkPUJXVCI4wYrTc1yLI1qAlhNg2v9vC5wQ0NY0xmmS5oQ/exec'))
            .then((response) {
          Provider.of<AuthOperation>(this.context, listen: false).deviceToken =
              jsonDecode(response.body);
          print(
              'Data received: ${Provider.of<AuthOperation>(this.context, listen: false).deviceToken}');
        });
      }
    });
    notificationServices.setupInteractMessage(this.context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/doct.jpg",
            ),
          ),
          title: Text(
            'Time Is Everything',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    40.0)), //this right here
                            child: SingleChildScrollView(
                              child: Container(
                                  height: height * 0.9, child: CreatePatient()),
                            ));
                      });
                  // Navigator.pushNamed(context, '/createPatient');
                },
                icon: Icon(Icons.person_add)),
            Theme(
                data: Theme.of(context).copyWith(
                    textTheme: TextTheme().apply(bodyColor: Colors.black),
                    dividerColor: Colors.black,
                    iconTheme: IconThemeData(color: Colors.black)),
                child: Stack(
                  children: [
                    PopupMenuButton<int>(
                      color: Colors.white,
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                            value: 0,
                            child: Text("Custom Theme",
                                style: TextStyle(
                                  color: textColor,
                                ))),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text.rich(TextSpan(
                              text: Provider.of<DropDownListMasterOperation>(
                                              context,
                                              listen: false)
                                          .versionName ==
                                      applicationVersion
                                  ? " Version "
                                  : "Update Now",
                              style: TextStyle(
                                color: Provider.of<DropDownListMasterOperation>(
                                                context,
                                                listen: false)
                                            .versionName ==
                                        applicationVersion
                                    ? textColor
                                    : Colors.red,
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                    text:
                                        Provider.of<DropDownListMasterOperation>(
                                                        context,
                                                        listen: false)
                                                    .versionName ==
                                                applicationVersion
                                            ? " $applicationVersion"
                                            : " Version $applicationVersion",
                                    style: TextStyle(
                                      color: textColor.withOpacity(0.5),
                                    ))
                              ])),
                        ),
                        PopupMenuItem<int>(
                            value: 1,
                            child: Text("Help",
                                style: TextStyle(
                                  color: textColor,
                                ))),
                        PopupMenuDivider(),
                        PopupMenuItem<int>(
                            value: 2,
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
                      onSelected: (item) => SelectedItem(context, item),
                    ),
                  ],
                )),
          ],
          backgroundColor: appBarButtonBackColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          backgroundColor: Colors.blue,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(40.0)), //this right here
                      child: SingleChildScrollView(
                        child: Container(
                            height: height * 0.9, child: CreatePatient()),
                      ));
                });
          },
        ),
        backgroundColor: backgroundColor,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: appBarButtonBackColor,
          unselectedItemColor: iconButtonColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.perm_identity_outlined), label: 'Attendance'),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.query_stats,
              ),
              label: 'Patients',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_sharp), label: 'Leaves'),
          ],
          // currentIndex: tabs[_selectedIndex],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          }, //New
          // onTap: _onItemTapped,
        ),
        body: tabs[_selectedIndex]);
  }

  void SelectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              backgroundColor = defaultBackgroundColor;
                              appBarButtonBackColor =
                                  defaultAppBarButtonBackColor;
                              textColor = defaultTextColor;
                              cardBackgroundColor = defaultCardBackgroundColor;
                            });
                          },
                          child: Text("Set as Default")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text("Done")),
                    ],
                  ),
                ],
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '''Customize Theme''',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: textColor),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("AppBar and Button Color"),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    actions: <Widget>[
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        icon: Icon(Icons.check),
                                      ),
                                    ],
                                    content: SingleChildScrollView(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.35,
                                        child: MaterialColorPicker(
                                          circleSize: 50,
                                          selectedColor: appBarButtonBackColor,
                                          onColorChange: (Color color) {
                                            setState(() {
                                              appBarButtonBackColor = color;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: CircleAvatar(
                                backgroundColor: appBarButtonBackColor,
                                child: Icon(
                                  Icons.colorize,
                                  color: cardBackgroundColor,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Text Color"),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    actions: <Widget>[
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        icon: Icon(Icons.check),
                                      ),
                                    ],
                                    content: SingleChildScrollView(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.35,
                                        child: MaterialColorPicker(
                                          circleSize: 50,
                                          selectedColor: textColor,
                                          onColorChange: (Color color) {
                                            setState(() {
                                              textColor = color;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: CircleAvatar(
                                backgroundColor: textColor,
                                child: Icon(
                                  Icons.colorize,
                                  color: appBarButtonBackColor,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Background Color"),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    actions: <Widget>[
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        icon: Icon(Icons.check),
                                      ),
                                    ],
                                    content: SingleChildScrollView(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.35,
                                        child: MaterialColorPicker(
                                          circleSize: 50,
                                          selectedColor: backgroundColor,
                                          onColorChange: (Color color) {
                                            setState(() {
                                              backgroundColor = color;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: CircleAvatar(
                                backgroundColor: backgroundColor,
                                child: Icon(
                                  Icons.colorize,
                                  color: textColor,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Card Background Color"),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    actions: <Widget>[
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        icon: Icon(Icons.check),
                                      ),
                                    ],
                                    content: SingleChildScrollView(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.35,
                                        child: MaterialColorPicker(
                                          circleSize: 50,
                                          selectedColor: cardBackgroundColor,
                                          onColorChange: (Color color) {
                                            setState(() {
                                              cardBackgroundColor = color;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: CircleAvatar(
                                backgroundColor: cardBackgroundColor,
                                child: Icon(
                                  Icons.colorize,
                                  color: textColor,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        break;
      case 1:
        if (Provider.of<DropDownListMasterOperation>(context, listen: false)
                .versionName ==
            applicationVersion) {
          final snackBar = SnackBar(
            content: Text(
                'Version is Up to Date, Version ${Provider.of<DropDownListMasterOperation>(context, listen: false).versionName} :Date ${Provider.of<DropDownListMasterOperation>(context, listen: false).versionDate}'),
            backgroundColor: (Colors.black12),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          var url =
              Provider.of<DropDownListMasterOperation>(context, listen: false)
                  .versionLink;
          Clipboard.setData(ClipboardData(text: url));
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Update Alert'),
                  content: Text(
                      ' 1) Click on copy Link \n 2) Unistall this application \n 3) open browser and paste link \n 4) install application'),
                  actions: <Widget>[
                    new MaterialButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new TextButton.icon(
                      icon: Icon(Icons.copy),
                      label: Text('Copy Link'),
                      onPressed: () {
                        final snackBar = SnackBar(
                          content: const Text('Link Copied'),
                          backgroundColor: (Colors.black12),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ],
                );
              });
          // await launchUrlString(
          //   url,
          //   mode: LaunchMode.externalApplication,
          // );
        }

        break;
      case 2:
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to exit the App'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Provider.of<AuthOperation>(context, listen: false)
                          .logout();
                      Navigator.pushReplacementNamed(context, '/loginpage');
                    },
// logindata.clear();

// Navigator.of(context).pop(true),
                    child: Text('Yes'),
                  ),
                ],
              );
            },
          );
        }
        break;
    }
  }
}
