import 'dart:math';

import 'package:flutter/material.dart';
import 'package:googlesheet/model/dropDownList.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../model/dropDownList.dart';
import '../../model/dropDownList.dart';
import '../../model/patientReport.dart';

import '../../model/user.dart';
import '../../operations/dropDownListOperation.dart';
import '../../operations/pacientFormOpeation.dart';
import '../../operations/patientOperation.dart';

class Pacientform extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<Pacientform> {
  // Form variables
  TextEditingController patientNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController _customerController = TextEditingController();
  TextEditingController cleartext = TextEditingController();
  late AuthData? staff;

  DateTime selectedDate = DateTime.now();
  GlobalKey<FormState> patientKey = GlobalKey<FormState>();
  late TextEditingController _otherController;
  // String selectedLocation;

  PatientReportModel patientReportModel = PatientReportModel(
    date: DateTime.now().toString(),
    patientName: " ",
    branch_name: " ",
    amount: " ",
      user_names: " ",
  );
  DropDownListModel listdata = DropDownListModel(
      branch: '',
      id: '',
      frequncy: '',
      method: '',
      equipment: '',
      condition: '',
      therepyType: '',
      excersise: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: patientKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ).then((date) {
                          if (date != null && date != selectedDate) {
                            setState(() {
                              patientReportModel.date = date.toString();
                              final formatter = DateFormat('dd-MM-yyyy');
                              // DateTime dateTime = DateTime.parse(date);

                              // selectedDate= Provider.of<PacientForamOperation>(context,listen: false).formatDate(date);
                              selectedDate = formatter.format(date) as DateTime;
                              // selectedDate = date;
                            });
                          }
                        });
                      },
                      icon: Icon(
                        Icons.calendar_month,
                        size: 50,
                      )),
                  Text(
                    'Date: ${selectedDate.toString()}',
                    style: TextStyle(fontSize: 19),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Consumer<DropDownListMasterOperation>(
                    builder: (context, MyAsset, child) {
                  return TextFormField(
                    onSaved: (value) {
                      patientReportModel.branch_name = value!;
                    },
                    controller: _customerController,
                    decoration: InputDecoration(
                      hintText: 'Select Branch Location',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Required';
                      } else {
                        return null;
                      }
                    },
                    readOnly: true,
                    onTap: () async {
                      final selected = await showDialog(
                        context: context,
                        builder: (context) {
                          List<String> filteredDepartments =
                              MyAsset.getBranchNameSuggestions();

                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Text('Select a Customer'),
                                content: SizedBox(
                                  width: 300, // Set your desired width here
                                  height: 400, // Set your desired height here
                                  child: Column(
                                    children: [
                                      TextField(
                                        onChanged: (value) {
                                          // Filter the departments based on the search text.
                                          setState(() {
                                            filteredDepartments = MyAsset
                                                    .getBranchNameSuggestions()
                                                .where((department) =>
                                                    department
                                                        .toLowerCase()
                                                        .contains(
                                                          value.toLowerCase(),
                                                        ))
                                                .toList();
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Search Customer Location',
                                          prefixIcon: Icon(Icons.search),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: filteredDepartments.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                  filteredDepartments[index]),
                                              onTap: () {
                                                Navigator.pop(context,
                                                    filteredDepartments[index]);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );

                      if (selected != null) {
                        _customerController.text = selected;
                      }
                    },
                    // onTap: () async {
                    //   final selected = await showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return SimpleDialog(
                    //         title: Text(
                    //             'Select Customer Location'),
                    //         children: MyAsset
                    //                 .getCustomerNameData()
                    //             .map((value) {
                    //           return SimpleDialogOption(
                    //             onPressed: () {
                    //               Navigator.pop(
                    //                   context, value);
                    //             },
                    //             child: Text(value),
                    //           );
                    //         }).toList(),
                    //       );
                    //     },
                    //   );
                    //   if (selected != null) {
                    //     _customerController.text =
                    //         selected;
                    //   }
                    // },
                  );
                }),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: patientNameController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Number Of Patient',
                  hintText: 'Enter the Number of Patient',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                onSaved: (value) {
                  patientReportModel.patientName = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Amount',
                  hintText: 'Enter the Amount',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                onSaved: (value) {
                  patientReportModel.amount = value!;
                },
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () async{
                          if (!patientKey.currentState!.validate()) {
                            return;
                          }

                          patientKey.currentState?.save();
                          Provider.of<PacientForamOperation>(context,
                                  listen: false)
                              .showAlert(context);
                          patientReportModel.user_names="";
                          Provider.of<PacientForamOperation>(context,
                                  listen: false)
                              .addPatientReportSpreadsheet(patientReportModel);
                          patientKey.currentState?.reset();
                        },
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Save",
                          style: TextStyle(fontSize: 24),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveFormData() {
    // Implement your logic to save the form data here
    String patientName = patientNameController.text;
    String amount = amountController.text;

    // For demonstration purposes, you can print the data
    print('Date: $selectedDate');
    // print('Location: $selectedLocation');
    print('Patient Name: $patientName');
    print('Amount: $amount');
  }
}
