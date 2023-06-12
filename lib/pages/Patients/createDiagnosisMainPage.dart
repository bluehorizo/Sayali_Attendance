import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googlesheet/model/diagnosis.dart';
import 'package:googlesheet/model/receipt.dart';
import 'package:googlesheet/model/therepy.dart';
import 'package:googlesheet/operations/LeavesOperation.dart';
import 'package:googlesheet/operations/inTimePatientOperation.dart';
import 'package:googlesheet/operations/diagnosisOperation.dart';
import 'package:googlesheet/pages/Patients/patientListWidget.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
import 'package:textfield_search/textfield_search.dart';

import '../../operations/dropDownListOperation.dart';
import '../../operations/patientOperation.dart';
import '../../operations/receiptOperation.dart';
import '../../operations/therepyOperation.dart';
import '../../themes/color.dart';
import 'ReceiptFormat/Receipt.dart';
import 'createPatients.dart';

class CreateDiagnosisMainPage extends StatefulWidget {
  const CreateDiagnosisMainPage({Key? key}) : super(key: key);

  @override
  State<CreateDiagnosisMainPage> createState() => _CreatePatientState();
}

class _CreatePatientState extends State<CreateDiagnosisMainPage> {
  int _currentStep = 0;
  int number = 0;
  bool isDiagnosis = false;
  StepperType stepperType = StepperType.vertical;
  int patientNewId = 0;
  ReceiptModel receiptModel = ReceiptModel(
      id: "0",
      patientId: "",
      petientName: "",
      date: DateTime.now().toString(),
      therepy: "Diagnosis",
      amount: "",
      modeOfPayment: "Gpay",
      dignosisId: "",
      user_id: "");
  TextEditingController cityController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  GlobalKey<FormState> patientKey = GlobalKey<FormState>();
  List<String> branchList = [];
  late String dropdownvalue;
  late String branchName;
  late TextEditingController _otherController;

  int _index = 0;

  @override
  void initState() {
    // branchName = branchList[4];
    // patientNewId = int.parse(
    //         Provider.of<PatientOperation>(context, listen: false).getId()) +
    //     1;
    Provider.of<PatientOperation>(context, listen: false).getPatientFromSheet();
    Provider.of<RceiptOperation>(context, listen: false)
        .getReceiptFromSheet()
        .then((value) => receiptModel.id =
            Provider.of<RceiptOperation>(context, listen: false)
                .getId()
                .toString());
    _otherController = TextEditingController();
    Provider.of<DiagnosisOperation>(context, listen: false)
        .getDiagnosisFromSheet();
    Provider.of<TherepyOperation>(context, listen: false).getTherepyFromSheet();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25.0)),
                child: TabBar(
                  indicator: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(25.0)),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text: 'Receipt'),
                    Tab(text: 'History'),
                  ],
                ),
              ),
              Expanded(
                  child: TabBarView(
                children: [
                  Form(
                      key: patientKey,
                      child: Column(
                        children: [
                          Consumer<AppointementOperation>(
                            builder: (context, orderData, child) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 24.0),
                                      child: Text(
                                        "Patient Receipt",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32,
                                            color: textColor),
                                      ),
                                    ),
                                    Consumer<PatientOperation>(
                                        builder: (context, orderData, child) =>
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 8),
                                                child: TextFieldSearch(
                                                    decoration: InputDecoration(
                                                      isCollapsed: true,
                                                      prefixIcon: Icon(Icons
                                                          .perm_contact_calendar_sharp),
                                                      contentPadding:
                                                          EdgeInsets.all(9),
                                                      labelText:
                                                          "Select Patient Name",
                                                      filled: true,
                                                    ),
                                                    initialList: Provider.of<
                                                                PatientOperation>(
                                                            context,
                                                            listen: false)
                                                        .getBranchNameSuggestions(),
                                                    label: "label",
                                                    controller:
                                                        _otherController))),
                                    Consumer<RceiptOperation>(
                                        builder: (context, orderData, child) =>
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: DropdownButton(
                                                  hint: Text(
                                                      "Select Consultation Or Therapy"),
                                                  // Initial Value
                                                  value: orderData.therepyOrd,

                                                  // Down Arrow Icon
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down),

                                                  // Array list of items
                                                  items: <String>[
                                                    'Diagnosis',
                                                    'Therapy',
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
                                                    receiptModel.therepy =
                                                        newValue.toString();
                                                    orderData.setTherapyMode(
                                                        newValue.toString());
                                                  },
                                                ))),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: cityController,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                signed: false),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter a number';
                                          }
                                          final n = num.tryParse(value!);
                                          if (n == null) {
                                            return 'Invalid number';
                                          }
                                          if (n <= 0) {
                                            return 'Please enter a positive number';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Amount '),
                                        onSaved: (value) {
                                          receiptModel.amount = value!;
                                        },
                                      ),
                                    ),
                                    Consumer<RceiptOperation>(
                                        builder: (context, orderData, child) =>
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: DropdownButton(
                                                  hint: Text(
                                                      "Select Mode Of Payment"),
                                                  // Initial Value
                                                  value: orderData.modePayment,

                                                  // Down Arrow Icon
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down),

                                                  // Array list of items
                                                  items: <String>[
                                                    'Cash',
                                                    'Gpay',
                                                    'Phone Pay',
                                                    'Bhim UPI ',
                                                    'Card',
                                                    'Other'
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
                                                    receiptModel.modeOfPayment =
                                                        newValue.toString();
                                                    orderData.setPaymentMode(
                                                        newValue.toString());
                                                  },
                                                ))),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                shape:
                                                    new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                              onPressed: () async {
                                                var now = DateTime.now();
                                                String actualTime =
                                                    now.toString();
                                                if (!patientKey.currentState!
                                                    .validate()) {
                                                  return;
                                                }

                                                receiptModel.petientName =
                                                    _otherController.text;

                                                patientKey.currentState?.save();
                                                Provider.of<RceiptOperation>(
                                                        context,
                                                        listen: false)
                                                    .submitForm(receiptModel);
                                                await GenerateDonatorVersionDonationPdf(
                                                        receiptModel, true)
                                                    .generateInvoice(
                                                        receiptModel);
                                                cityController.clear();
                                                _otherController.clear();

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
                          ),
                        ],
                      )),

                  Consumer<RceiptOperation>(
                    builder: (context, orderData, child) => ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (_, i) => Column(
                        children: [
                          PatietListWidget(
                              receiptModel: Provider.of<RceiptOperation>(
                                      context,
                                      listen: false)
                                  .receiptsData[i],id: i,),

                          // SevaHistoryBillInfo(
                          //     sevaTransactionList[i],
                          //     sevaTransactionList[i].id,
                          //     sevaTransactionList[i].srNumber,
                          //     sevaTransactionList[i].donatorName),
                          Divider()
                        ],
                      ),
                      itemCount:
                          Provider.of<RceiptOperation>(context, listen: false)
                              .receiptsData
                              .length,
                    ),
                  ),
                  // LeaveApplyScreen(),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
