import 'package:flutter/material.dart';
import 'package:googlesheet/model/patience.dart';
import 'package:googlesheet/operations/dropDownListOperation.dart';
import 'package:googlesheet/operations/patientOperation.dart';
import 'package:googlesheet/pages/Patients/Appointment/createAppointment.dart';
import 'package:provider/provider.dart';

import 'createDiagnosisMainPage.dart';
import 'Therapy/therapy_page.dart';

class CreatePatient extends StatefulWidget {
  @override
  _StepperDemoState createState() => _StepperDemoState();
}

class _StepperDemoState extends State<CreatePatient> {
  int _currentStep = 0;
  int number = 0;
  StepperType stepperType = StepperType.vertical;
  GlobalKey<FormState> patientKey = GlobalKey<FormState>();
  int patientNewId = 0;
  PatientModel patientModel = PatientModel(
      id: "",
      patient_ID: "",
      date: "",
      patient_name: "",
      branch_name: "",
      patientDOB: "",
      age: "",
      patient_gender: "",
      patient_adhaar_number: "",
      patient_PAN: "",
      patient_mobile_number: "",
      email: "",
      patient_weight_kg: "",
      alergies: "",
      patient_photo: "",
      emerg_contact_person: "",
      emerg_mobile_number: "",
      height: "",
      preExistingDecease: "",
      user_identification: "",
      userEmailId: "");

  List<String> graphList = [
    "Patient",
    "Appointment",
    "Diagnosis",
    "Therapy",
    "Receipt",
    "Medicine"
  ];
  List<String> branchList = [];
  late String dropdownvalue;
  late String branchName;
  TextEditingController dateController = TextEditingController();
  @override
  void initState() {
    dropdownvalue = graphList[0];

    // branchName = branchList[4];
    // patientNewId = int.parse(
    //         Provider.of<PatientOperation>(context, listen: false).getId()) +
    //     1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        if (!patientKey.currentState!.validate()) {
                          return;
                        }
                        patientKey.currentState?.save();

                        Provider.of<PatientOperation>(context, listen: false)
                            .submitForm(patientModel);
                        Navigator.of(context).pop();
                        //       .then((bool success) {
                        //     if (success) {
                        //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //         content: Text(
                        //             "${prospect.nameOfProspect} as Client Added"),
                        //       ));
                        //       Navigator.of(context).pop();
                        //     } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${patientModel.patient_name} added'),
                                    Icon(
                                      Icons.cloud_done,
                                      color: Colors.blue,
                                    )
                                  ],
                                ),
                                content: Text(
                                    'Send Appointment Number to ${patientModel.patient_mobile_number}'),
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Send Later',
                                        style: TextStyle(color: Colors.blue)),
                                  ),
                                  MaterialButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      'Send Appointment number',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              );
                            });
                        //     }
                        //   });
                      },
                      icon: Icon(
                        Icons.flash_on,
                        color: Colors.amber,
                      ),
                      label: Text(
                        _currentStep <= 0 ? "Instant Save" : "Save",
                        style: TextStyle(fontSize: 20),
                      )),
                ],
              ),
              FutureBuilder(
                  future: Provider.of<DropDownListMasterOperation>(context,
                          listen: false)
                      .getDropDownListFromSheet()
                      .then((value) =>
                          Provider.of<PatientOperation>(context, listen: false)
                              .getPatientFromSheet()),
                  builder: (context, dataSnapshot) {
                    if (dataSnapshot.connectionState ==
                        ConnectionState.waiting) {
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
                        branchName = Provider.of<DropDownListMasterOperation>(
                                context,
                                listen: false)
                            .getBranchNameSuggestions()[3];
                        return Form(
                            key: patientKey,
                            child: Consumer<PatientOperation>(
                              builder: (context, orderData, child) => Stepper(
                                type: stepperType,
                                physics: ScrollPhysics(),
                                currentStep: orderData.currentStep,
                                onStepTapped: (step) => orderData.tapped(step),
                                onStepContinue: orderData.continued,
                                onStepCancel: orderData.cancel,
                                steps: <Step>[
                                  Step(
                                    title: new Text('Instant Info'),
                                    content: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text.rich(TextSpan(
                                              text:
                                                  '${graphList[number]} ID :- ',
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                              children: <InlineSpan>[
                                                TextSpan(
                                                    text:
                                                        '0${orderData.getId()}',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16))
                                              ])),
                                        ),
                                        DropdownButton(
                                          hint: Text("Select Branch Name"),
                                          // Initial Value
                                          value: branchName,

                                          // Down Arrow Icon
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),

                                          // Array list of items
                                          items: Provider.of<
                                                      DropDownListMasterOperation>(
                                                  context,
                                                  listen: false)
                                              .getBranchNameSuggestions()
                                              .map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16)),
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (newValue) {
                                            branchName = newValue.toString();
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Patient Name'),
                                          onSaved: (value) {
                                            patientModel.patient_name = value!;
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Phone Number'),
                                          onSaved: (value) {
                                            patientModel.patient_mobile_number =
                                                value!;
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Email Id'),
                                          onSaved: (value) {
                                            patientModel.email = value!;
                                          },
                                        ),
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 0
                                        ? StepState.complete
                                        : StepState.disabled,
                                  ),
                                  Step(
                                    title: new Text('Additional Info'),
                                    content: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'alergies'),
                                          onSaved: (value) {
                                            patientModel.alergies = value!;
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText:
                                                  'pre Existing Decease'),
                                          onSaved: (value) {
                                            patientModel.preExistingDecease =
                                                value!;
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Patient_photo'),
                                          onSaved: (value) {
                                            patientModel.patient_photo = value!;
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'patient DOB'),
                                          onTap: () async {
                                            var date = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100));
                                            dateController.text = date
                                                .toString()
                                                .substring(0, 10);
                                          },
                                          onSaved: (value) {
                                            patientModel.patientDOB = value!;
                                            patientModel.age = "28";
                                          },
                                        ),
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 1
                                        ? StepState.complete
                                        : StepState.disabled,
                                  ),
                                  Step(
                                    title: new Text('Extra Info'),
                                    content: Column(
                                      children: <Widget>[
                                        // TextFormField(
                                        //   decoration: InputDecoration(
                                        //       labelText: 'Patient_photo'),
                                        //   onSaved: (value) {
                                        //     patientModel.patient_photo =
                                        //         value!;
                                        //   },
                                        // ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: DropdownButton(
                                                hint: Text("Select Gender"),
                                                // Initial Value
                                                value: "Patient",

                                                // Down Arrow Icon
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),

                                                // Array list of items
                                                items: <String>[
                                                  'Patient',
                                                  'Male',
                                                  'Female'
                                                ].map((String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                                // After selecting the desired option,it will
                                                // change button value to selected value
                                                onChanged: (newValue) {
                                                  branchName =
                                                      newValue.toString();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText:
                                                  'emerg_ contact_person'),
                                          onSaved: (value) {
                                            patientModel.emerg_contact_person =
                                                value!;
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'emerg_mobile_number'),
                                          onSaved: (value) {
                                            patientModel.emerg_mobile_number =
                                                value!;
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Height'),
                                          onSaved: (value) {
                                            patientModel.height = value!;
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'patient_weight_kg'),
                                          onSaved: (value) {
                                            patientModel.patient_weight_kg =
                                                value!;
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText:
                                                  'patient_adhaar_number'),
                                          onSaved: (value) {
                                            patientModel.patient_adhaar_number =
                                                value!;
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'patient_PAN'),
                                          onSaved: (value) {
                                            patientModel.patient_adhaar_number =
                                                value!;
                                          },
                                        ),
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 2
                                        ? StepState.complete
                                        : StepState.disabled,
                                  ),
                                ],
                              ),
                            ));
                      }
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }
}
