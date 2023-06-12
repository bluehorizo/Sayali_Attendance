import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../../model/therepy.dart';
import '../../../operations/dropDownListOperation.dart';
import '../../../operations/inTimePatientOperation.dart';
import '../../../operations/patientOperation.dart';
import '../../../operations/therepyOperation.dart';
import '../createPatients.dart';

class therapyPage extends StatefulWidget {
  const therapyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Therapy();
}

class _Therapy extends State<therapyPage> {
  GlobalKey<FormState> patientKey = GlobalKey<FormState>();
  late String branchName;
  late String inTimeDefault;

  Therepy therepyModel = Therepy(
      id: '',
      inTimeId: '',
      patientId: '',
      patientName: '',
      excercise_name: '',
      feed_back_from_patient: '',
      feesAmount: '',
      inTime: '',
      outTime: '',
      user_id: '');
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TextEditingController cityController = TextEditingController();
    return FutureBuilder(
        future: Provider.of<DropDownListMasterOperation>(context, listen: false)
            .getDropDownListFromSheet()
            .then((value) =>
                Provider.of<TherepyOperation>(context, listen: false)
                    .getTherepyFromSheet())
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
              inTimeDefault =
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
                                children: [],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFieldSearch(
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Exercise name'),
                                  onSaved: (value) {
                                    therepyModel.excercise_name = value!;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'feed back form'),
                                  onSaved: (value) {
                                    therepyModel.feed_back_from_patient =
                                        value!;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'inTime'),
                                  onSaved: (value) {
                                    therepyModel.feed_back_from_patient =
                                        value!;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'outTime'),
                                  onSaved: (value) {
                                    therepyModel.feed_back_from_patient =
                                        value!;
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
