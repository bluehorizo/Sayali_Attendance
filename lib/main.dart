import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googlesheet/operations/LeavesOperation.dart';
import 'package:googlesheet/operations/authOperations.dart';
import 'package:googlesheet/operations/dropDownListOperation.dart';
import 'package:googlesheet/operations/inTimePatientOperation.dart';
import 'package:googlesheet/operations/medicieOperation.dart';
import 'package:googlesheet/operations/therepyOperation.dart';
import 'package:googlesheet/pages/Leaves/leaveMainPage.dart';
import 'package:googlesheet/pages/Patients/Appointment/createAppointment.dart';
import 'package:googlesheet/pages/Patients/createDiagnosisMainPage.dart';
import 'package:googlesheet/pages/Patients/createPatients.dart';
import 'package:googlesheet/pages/Patients/patientPage.dart';
import 'package:googlesheet/pages/homepage.dart';
import 'package:googlesheet/pages/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:googlesheet/showmodal/employinfoshowmodal.dart';
import 'package:googlesheet/widgets/stopwatchT.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'model/user.dart';
import 'operations/approvialOperation.dart';
import 'operations/attendanceOperations.dart';
import 'operations/diagnosisOperation.dart';
import 'operations/employeeOperation.dart';
import 'operations/local_notification_service.dart';
import 'operations/pacientFormOpeation.dart';
import 'operations/patientOperation.dart';
import 'operations/receiptOperation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (BuildContext context) => AuthOperation()),
      ChangeNotifierProvider(
          create: (BuildContext context) => EmployeeOperation()),
      ChangeNotifierProvider(
          create: (BuildContext context) => AttendanceOperations()),
      ChangeNotifierProvider(
          create: (BuildContext context) => PatientOperation()),
      ChangeNotifierProvider(
          create: (BuildContext context) => AppointementOperation()),
      ChangeNotifierProvider(
          create: (BuildContext context) => MedicineOperation()),
      ChangeNotifierProvider(
          create: (BuildContext context) => RceiptOperation()),
      ChangeNotifierProvider(
          create: (BuildContext context) => DropDownListMasterOperation()),
      ChangeNotifierProvider(
          create: (BuildContext context) => DiagnosisOperation()),
      ChangeNotifierProvider(
          create: (BuildContext context) => TherepyOperation()),
      ChangeNotifierProvider(
          create: (BuildContext context) => LeaveOperations()),
      ChangeNotifierProvider(
          create: (BuildContext context) =>PacientForamOperation()),
      ChangeNotifierProvider(
          create: (BuildContext context) => AprovelOperation())

    ],
    child: MyApp(),
  ));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences logindata;
  late final LocalNotificationService service;
  bool newuser = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // late String token;
  // @override
  void initState() {
    Provider.of<AprovelOperation>(context, listen: false).getFromSheet();
    autoLogin();
    service = LocalNotificationService();
    Provider.of<DropDownListMasterOperation>(context, listen: false)
        .getVersionData();
    service.intialize();
    if (Platform.isAndroid) Firebase.initializeApp();
    Provider.of<AttendanceOperations>(context, listen: false).initAttendAuth();
    Provider.of<RceiptOperation>(context, listen: false).getReceiptFromSheet();
    Provider.of<DropDownListMasterOperation>(context, listen: false).getDropDownListFromSheet();
  }

  void check_if_already_login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    if (token != null) {
      setState(() {
        newuser = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/leavepage', //first main page to display
      // home: StopWatchTimerPage(),
      home: newuser ? HomePage() : LoginPage(), //first main page to display
      routes: {
        '/homePage': (context) => HomePage(),
        '/loginpage': (context) => LoginPage(),
        '/leavepage': (context) => LeaveMainPage(),
        '/employeePage': (context) => EmployInfoShowModal(),
        '/createPatient': (context) => CreatePatient(),
        '/createAppointment': (context) => CreateAppointment(),
        '/createDiagnosis': (context) => CreateDiagnosisMainPage()

      },
      debugShowCheckedModeBanner: false,
    );
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => PatientHomePage())));
    }
  }

  void autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final String designation = prefs.getString('designation')!;
    final String staffEmail = prefs.getString('userEmail')!;
    final String id = prefs.getString('id')!;
    final String name = prefs.getString('name')!;
    if (token != null) {
      Provider.of<AuthOperation>(context, listen: false).AuthenticatedUser =
          AuthData(
              id: id,
              email: staffEmail,
              name: name,
              token: token,
              designation: designation);
      setState(() {
        newuser = true;
      });
      // setAuthTimout(tokenLifeSApan);
      // notifyListeners();
    }
  }
}
