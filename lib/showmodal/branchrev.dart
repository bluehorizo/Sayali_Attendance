import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googlesheet/operations/employeeOperation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../model/employeemodel.dart';
import '../themes/color.dart';

class EmployInfoShowModal extends StatefulWidget {
  const EmployInfoShowModal({Key? key}) : super(key: key);

  @override
  State<EmployInfoShowModal> createState() => _EmployInfoShowModalState();
}

class _EmployInfoShowModalState extends State<EmployInfoShowModal> {
  late EmployModel employModel = EmployModel(
      id: "",
      date: "",
      empNumber: "",
      full_name: "",
      designation: "",
      mobile_no: "",
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
  GlobalKey<FormState> Empkey = GlobalKey<FormState>();

  late TextEditingController emailcontroller = TextEditingController();
  late TextEditingController fullnamecontroller = TextEditingController();
  late TextEditingController designationcontroller = TextEditingController();
  late TextEditingController mobilecontroller = TextEditingController();
  late TextEditingController altermobilecontrol = TextEditingController();
  late TextEditingController pancontroller = TextEditingController();
  late TextEditingController aadharcontroller = TextEditingController();
  late TextEditingController addresscontroller = TextEditingController();

  late List<bool> isSelectedForGender;
  List<String> GenderType = ["Male", "Female", "Other"];

  void initState() {
    // this is for 3 buttons, add "false" same as the number of buttons here
    isSelectedForGender = [true, false, false];
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1975),
      lastDate: DateTime(2099),
    );
    if (d != null)
      setState(() {
        employModel.date_of_birth = DateFormat("dd-MM-yyyy").format(d);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Employee"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                primary: appBarButtonBackColor,
                onPrimary: textColor,
                shadowColor: appBarButtonBackColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                minimumSize: Size(120, 45),
              ),
              onPressed: () {
                setState(() {
                  if (!Empkey.currentState!.validate()) {
                    return;
                  }
                  Empkey.currentState?.save();
                  print("step 1 ${employModel.email}");
                  Provider.of<EmployeeOperation>(context, listen: false)
                      .submitForm(employModel);
                });
              },
            ),
          )
        ],
      ),
      body: Form(
        key: Empkey,
        child: Center(
          child: Column(
            children: [
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, right: 15, left: 15),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  employModel.email = value;
                                },
                                decoration: InputDecoration(
                                    hintText: ' abc@gmail.com',
                                    prefixIcon:
                                        Icon(Icons.mail_outline_outlined),
                                    labelText: 'Email',
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value)) {
                                    return 'Required';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  employModel.full_name = value;
                                },
                                controller: fullnamecontroller,
                                decoration: InputDecoration(
                                    hintText: 'Full Name',
                                    prefixIcon: Icon(Icons.person),
                                    labelText: 'Full Name',
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
                                height: 8,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  employModel.designation = value;
                                },
                                controller: designationcontroller,
                                decoration: InputDecoration(
                                    hintText: 'Designation',
                                    prefixIcon: Icon(Icons.person),
                                    labelText: 'Designation',
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
                                height: 8,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  employModel.mobile_no = value;
                                },
                                controller: mobilecontroller,
                                maxLength: 10,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    hintText: 'Mobile No',
                                    prefixIcon: Icon(Icons.call),
                                    labelText: 'Mobile no',
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
                                height: 8,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  employModel.alternate_no = value;
                                },
                                controller: altermobilecontrol,
                                maxLength: 10,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    hintText: 'Alternate Mobile No',
                                    prefixIcon: Icon(Icons.call),
                                    labelText: 'Alternate Mobile no',
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
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Select Gender :"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ToggleSwitch(
                                    initialLabelIndex: 1,
                                    cornerRadius: 20.0,
                                    activeFgColor: Colors.white,
                                    inactiveBgColor: Colors.grey,
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 3,
                                    labels: GenderType,
                                    activeBgColors: [
                                      [Colors.lightBlueAccent],
                                      [Colors.pinkAccent],
                                      [Colors.yellowAccent]
                                    ],
                                    onToggle: (index) {
                                      print('switched to: $index');
                                      setState(() {
                                        employModel.gender = GenderType[index!];
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date Of Birth :",
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectDate(context);
                                      });
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
                                          Text(
                                            employModel.date_of_birth,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  employModel.address = value;
                                },
                                controller: addresscontroller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                    hintText: 'Address',
                                    prefixIcon: Icon(Icons.location_on_sharp),
                                    labelText: 'Address',
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
                                height: 8,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  employModel.pan_card = value;
                                },
                                controller: pancontroller,
                                decoration: InputDecoration(
                                    hintText: 'Pan Card Number',
                                    prefixIcon: Icon(Icons.person),
                                    labelText: 'Pan Card',
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
                                height: 8,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  employModel.aadhar_card = value;
                                },
                                controller: aadharcontroller,
                                decoration: InputDecoration(
                                    hintText: 'Aadhar Card Number',
                                    prefixIcon: Icon(Icons.person),
                                    labelText: 'Aadhar Card',
                                    border: OutlineInputBorder()),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Required';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
