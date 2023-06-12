import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:googlesheet/model/employeemodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../model/all_enums.dart';
import '../operations/authOperations.dart';
import '../operations/employeeOperation.dart';
import '../themes/color.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formskey = GlobalKey<FormState>();

  String email = '', password = '', repassword = '';

  //
  // void validateAndSave() {
  //   final FormState? form = formskey.currentState;
  //   if (form!.validate()) {
  //     print('Form is valid');
  //   } else {
  //     print('Form is invalid');
  //   }
  // }
  AuthMode _authMode = AuthMode.Login;
  late TextEditingController emailcontroller = TextEditingController();
  late TextEditingController passwordcontroller = TextEditingController();
  late TextEditingController repasswordcontroller = TextEditingController();
  late bool newuser;
  bool _isObscurepass = true;
  bool _isObscureconfirm = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<EmployeeOperation>(context, listen: false)
            .getEmployeeFromSheet(),
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
              return Scaffold(
                backgroundColor: Colors.white54,
                // child: SingleChildScrollView(

                body: buildloginCard(),
              );
            }
          }
        });
  }

  Container buildloginCard() {
    return Container(
      width: double.infinity,
      height: double.maxFinite,
      decoration: BoxDecoration(
          color: Colors.cyan.shade50,
          gradient: LinearGradient(
              colors: [(Colors.cyan.shade100), Colors.orange.shade200],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Center(
        child: Container(
            padding: EdgeInsets.only(left: 10, top: 10, right: 10),
            child: SingleChildScrollView(
              child: Form(
                key: formskey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 50,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/doct.jpg',
                          height: 300,
                          width: 150,
                        ),
                      ),
                    ),
                    Consumer<EmployeeOperation>(
                        builder: (context, orderData, child) {
                      return TextFormField(
                        onChanged: (value) {
                          email = value;
                          orderData.isEmployee(value);
                        },
                        controller: emailcontroller,
                        decoration: InputDecoration(
                            helperStyle: TextStyle(
                                color: orderData.staff.id == "0"
                                    ? Colors.red
                                    : Colors.green),
                            helperText: orderData.staff.id == "0"
                                ? "If you don't have Authorised mail id then Please Contact to HR For Access"
                                : "Info ${orderData.staff.designation} - ${orderData.staff.full_name}",
                            hintText: ' abc@gmail.com',
                            prefixIcon: Icon(Icons.mail_outline_outlined),
                            labelText: 'Email',
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                            return 'Required11';
                          } else {
                            return null;
                          }
                        },
                      );
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        password = value;
                      },
                      controller: passwordcontroller,
                      obscureText: _isObscurepass,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.password_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscurepass
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isObscurepass = !_isObscurepass;
                              });
                            },
                          ),
                          labelText: 'Password',
                          border: OutlineInputBorder()),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Required';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Consumer<AuthOperation>(
                        builder: (context, orderData, child) {
                      return Visibility(
                        visible: orderData.passVisible,
                        child: TextFormField(
                          onChanged: (value) {
                            repassword = value;
                          },
                          controller: repasswordcontroller,
                          obscureText: _isObscureconfirm,
                          decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              prefixIcon: Icon(Icons.password_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(_isObscureconfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscureconfirm = !_isObscureconfirm;
                                  });
                                },
                              ),
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return ' Required';
                            }
                            if (value != password) {
                              return 'Confirm password not matching';
                            }
                            return null;
                          },
                        ),
                      );
                    }),
                    Consumer<AuthOperation>(
                        builder: (context, orderData, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("${orderData.textValue}"),
                          Switch(
                            onChanged: orderData.toggleSwitch,
                            value: orderData.passVisible,
                          ),
                        ],
                      );
                    }),
                    Consumer<AuthOperation>(
                        builder: (context, orderData, child) {
                      return orderData.buttonVisible
                          ? ElevatedButton(
                              child: Text('LOGIN'),
                              style: ElevatedButton.styleFrom(
                                primary: appBarButtonBackColor,
                                onPrimary: textColor,
                                shadowColor: appBarButtonBackColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                minimumSize: Size(200, 40),
                              ),
                              onPressed: () async {
                                EmployModel employeeD =
                                    Provider.of<EmployeeOperation>(this.context,
                                            listen: false)
                                        .staff;
                                Map<String, dynamic> successInformation;
                                if (employeeD.id != "0" &&
                                    employeeD.email == email) {
                                  successInformation =
                                      await Provider.of<AuthOperation>(
                                              this.context,
                                              listen: false)
                                          .authenticate(
                                              email,
                                              password,
                                              Provider.of<EmployeeOperation>(
                                                      context,
                                                      listen: false)
                                                  .staff,
                                              _authMode);

                                  if (successInformation['success']) {
                                    await Navigator.pushReplacementNamed(
                                        context, '/homePage');
                                  }
                                } else {}

                                emailcontroller.clear();
                                passwordcontroller.clear();
                              },
                            )
                          : ElevatedButton(
                              child: Text('REGISTRATION'),
                              style: ElevatedButton.styleFrom(
                                primary: appBarButtonBackColor,
                                onPrimary: textColor,
                                shadowColor: appBarButtonBackColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                minimumSize: Size(200, 40),
                              ),
                              onPressed: () async {
                                // validate();
                                Map<String, dynamic> successregistration;
                                successregistration =
                                    await Provider.of<AuthOperation>(
                                            this.context,
                                            listen: false)
                                        .authenticate(
                                            email,
                                            password,
                                            Provider.of<EmployeeOperation>(
                                                    context,
                                                    listen: false)
                                                .staff,
                                            _authMode);

                                if (successregistration['success']) {
                                  await Navigator.pushReplacementNamed(
                                      context, '/homePage');
                                }

                                emailcontroller.clear();
                                passwordcontroller.clear();
                                repasswordcontroller.clear();
                              },
                            );
                    }),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
