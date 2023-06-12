import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:googlesheet/model/employeemodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/all_enums.dart';
import '../model/user.dart';
import '../themes/client_company_info.dart';
import 'attendanceOperations.dart';
import 'package:rxdart/rxdart.dart';
import 'employeeOperation.dart';

class AuthOperation extends ChangeNotifier {
  var deviceToken;
  late AuthData? AuthenticatedUser;
  PublishSubject<bool> _userSubject = PublishSubject();
  AuthMode _authMode = AuthMode.Login;
  bool passVisible = false;
  bool buttonVisible = true;
  var textValue = 'New User Registration?';
  AuthData get user {
    return AuthenticatedUser!;
  }

  Future initData() async {
    await Firebase.initializeApp();
  }

  bool isAdmin() {
    return AuthenticatedUser!.designation == "Director" ||
        AuthenticatedUser!.designation == "Manager" ||
        AuthenticatedUser!.designation == "Admin";
  }

  Future<Map<String, dynamic>> authenticate(
      String Email, String Password, EmployModel staffDetails,
      [AuthMode mode = AuthMode.Login]) async {
    final Map<String, dynamic> authData = {
      'email': Email,
      'password': Password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(Uri.parse(clientAuthSignInLink),
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.post(Uri.parse(clientAuthSignUpLink),
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    }
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = '';
    if (responseData.containsKey('refreshToken')) {
      hasError = false;
      message = 'Authentication succeded';
      AuthenticatedUser = AuthData(
          id: responseData['localId'],
          designation: staffDetails.designation,
          email: staffDetails.email,
          name: staffDetails.full_name,
          token: responseData['refreshToken']);
      //setAuthTimout(int.parse(responseData['expiresIn']));
      final DateTime now = DateTime.now();
      final DateTime expireTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['refreshToken']);
      prefs.setString('userEmail', Email);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('designation', staffDetails.designation);
      prefs.setString('user_identification', staffDetails.user_identification);
      prefs.setString('id', staffDetails.id.toString());
      prefs.setString('name', staffDetails.full_name);

      prefs.setString('salary', staffDetails.salary);
      prefs.setString('expiryTime', expireTime.toIso8601String());
      notifyListeners();
      _userSubject.add(true);
    } else if (responseData['error']['message'] == 'EMAIL_EXIST') {
      message = 'This Email already exist.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This Email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The PASSWORD IS INVALID';
    }
    return {'success': !hasError, 'message': message};
  }

  void logout() async {
    AuthenticatedUser = null;
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
    prefs.clear();
    notifyListeners();
  }

  void autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final String designation = prefs.getString('designation')!;
    final String staffEmail = prefs.getString('userEmail')!;
    final String id = prefs.getString('id')!;
    final String name = prefs.getString('name')!;
    if (token != null) {
      AuthenticatedUser = AuthData(
          id: id,
          email: staffEmail,
          name: name,
          token: token,
          designation: designation);
      _userSubject.add(true);
      // setAuthTimout(tokenLifeSApan);
      // notifyListeners();
    }
  }

  void toggleSwitch(bool value) {
    if (_authMode == AuthMode.Login) {
      passVisible = true;
      _authMode = AuthMode.SignUp;
      textValue = 'Back to Login';
      buttonVisible = false;
      notifyListeners();
    } else {
      passVisible = false;
      textValue = 'New User Registration?';
      _authMode = AuthMode.Login;
      buttonVisible = true;
      notifyListeners();
    }
  }
}
