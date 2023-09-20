import 'package:flutter/material.dart';
import 'package:googlesheet/model/inTimeEntry.dart';
import 'package:googlesheet/operations/inTimePatientOperation.dart';
import 'package:googlesheet/operations/patientOperation.dart';
import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../../operations/dropDownListOperation.dart';
import '../createPatients.dart';

class CreateAppointment extends StatefulWidget {
  const CreateAppointment({Key? key}) : super(key: key);

  @override
  State<CreateAppointment> createState() => _CreatePatientState();
}

class _CreatePatientState extends State<CreateAppointment> {
  GlobalKey<FormState> patientKey = GlobalKey<FormState>();
  late String branchName;
  late String inTimeDefault;

  AppointemenetModel appointemenetModel = AppointemenetModel(
      id: "",
      patientId: "",
      patientName: "",
      consult_ther: "",
      inTime: "",
      outTime: "",
      branchName: "",
      staffName: "",
      refer: "",
      isSend: "false",
      diagnosisTherepyId: "0",
      isPaymentDone: "false",
      receiptID: "0",
      doctorId: "0",
      user_id: "");
  @override
  void initState() {
   Provider.of<PatientOperation>(context).getPatientFromSheet();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TextEditingController cityController = TextEditingController();
    return FutureBuilder(
        future: Provider.of<DropDownListMasterOperation>(context, listen: false)
            .getDropDownListFromSheet()
            .then((value) =>
                Provider.of<PatientOperation>(context, listen: false)
                    .getPatientFromSheet()),
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
              branchName = Provider.of<DropDownListMasterOperation>(context,
                      listen: false)
                  .getBranchNameSuggestions()[3];
              appointemenetModel.consult_ther =
                  Provider.of<AppointementOperation>(context, listen: false)
                      .inTimeType;
              return SingleChildScrollView(
                child: Form(
                    key: patientKey,
                    child: Column(
                      children: [
                        Consumer<AppointementOperation>(
                          builder: (context, orderData, child) => Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text.rich(TextSpan(
                                        text: ' ID :- ',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                        children: <InlineSpan>[
                                          TextSpan(
                                              text:
                                                  '0${orderData.getAppointmentId()}',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20))
                                        ])),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        20.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (!patientKey.currentState!
                                                  .validate()) {
                                                return;
                                              }
                                              patientKey.currentState?.save();
                                              var now = DateTime.now();
                                              String actualTime =
                                                  now.toString();
                                              appointemenetModel.id = Provider
                                                      .of<AppointementOperation>(
                                                          context,
                                                          listen: false)
                                                  .getAppointmentId()
                                                  .toString();
                                              appointemenetModel.inTime =
                                                  actualTime;
                                              appointemenetModel
                                                  .patientId = Provider.of<
                                                          AppointementOperation>(
                                                      context,
                                                      listen: false)
                                                  .getAppointmentId()
                                                  .toString();
                                              appointemenetModel.patientName =
                                                  cityController.text;
                                              appointemenetModel.outTime =
                                                  "--:--";
                                              Provider.of<AppointementOperation>(
                                                      context,
                                                      listen: false)
                                                  .submitForm(
                                                      appointemenetModel);
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
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              '${appointemenetModel.patientName} added'),
                                                          Icon(
                                                            Icons.cloud_done,
                                                            color: Colors.blue,
                                                          )
                                                        ],
                                                      ),
                                                      content: Text(
                                                          'Send Appointment Number to 8097000212'),
                                                      actions: <Widget>[
                                                        MaterialButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child: Text(
                                                              'Send Later',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue)),
                                                        ),
                                                        MaterialButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child: Text(
                                                            'Send Appointment number',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                              //     }
                                              //   });
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                TextFieldSearch(
                                    decoration: InputDecoration(
                                      suffix: IconButton(
                                          icon: Icon(Icons.add_circle_outline,
                                              color: Colors.black45),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  40.0)), //this right here
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Container(
                                                            height:
                                                                height * 0.9,
                                                            child:
                                                                CreatePatient()),
                                                      ));
                                                });
                                          }),
                                      labelText: "Select Patient name",
                                    ),
                                    initialList: Provider.of<PatientOperation>(
                                            context,
                                            listen: false)
                                        .getBranchNameSuggestions(),
                                    label: "label",
                                    controller: cityController),
                              ),
                              Consumer<AppointementOperation>(
                                  builder: (context, orderData, child) =>
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DropdownButton(
                                            hint: Text(
                                                "Select Consultation Or Therapy"),
                                            // Initial Value
                                            value: orderData.inTimeType,

                                            // Down Arrow Icon
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),

                                            // Array list of items
                                            items: <String>[
                                              'Diagnosis',
                                              'Therapy',
                                            ].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            // After selecting the desired option,it will
                                            // change button value to selected value
                                            onChanged: (newValue) {
                                              orderData.setInTime(
                                                  newValue.toString());
                                              appointemenetModel.consult_ther =
                                                  orderData.inTimeType;
                                            },
                                          ))),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton(
                                  hint: Text("Select Branch Name"),
                                  // Initial Value
                                  value: branchName,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items:
                                      Provider.of<DropDownListMasterOperation>(
                                              context,
                                              listen: false)
                                          .getBranchNameSuggestions()
                                          .map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16)),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (newValue) {
                                    branchName = newValue.toString();
                                    appointemenetModel.branchName =
                                        newValue.toString();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Reference'),
                                  onSaved: (value) {
                                    appointemenetModel.patientName = value!;
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.close)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              );
            }
          }
        });
  }
}
