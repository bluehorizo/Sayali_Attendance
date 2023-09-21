import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googlesheet/operations/employeeOperation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../model/employeemodel.dart';
import '../operations/pacientFormOpeation.dart';
import '../themes/color.dart';

class branch_rev extends StatefulWidget {
  @override
  State<branch_rev> createState() => _branch_revState();
}

class _branch_revState extends State<branch_rev> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<PacientForamOperation>(context, listen: false)
            .getdatafromPacientReport(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              // return  Scaffold(
              //     appBar: AppBar(
              //       title: Text('Expance'),
              //     ),
              //     body: ListView.builder(
              //       itemCount: Provider.of<PacientForamOperation>(context,
              //               listen: false)
              //           .receiptsformData
              //           .length,
              //       itemBuilder: (context, index) {
              //         return ListTile(
              //           title: Column(
              //             children: [
              //               Text(Provider.of<PacientForamOperation>(context,
              //                       listen: false)
              //                   .receiptsformData[index]
              //                   .id),
              //               Text(Provider.of<PacientForamOperation>(context,
              //                       listen: false)
              //                   .receiptsformData[index]
              //                   .date),
              //               Text(Provider.of<PacientForamOperation>(context,
              //                       listen: false)
              //                   .receiptsformData[index]
              //                   .branch_name),
              //               Text(Provider.of<PacientForamOperation>(context,
              //                       listen: false)
              //                   .receiptsformData[index]
              //                   .patientName),
              //               Text(Provider.of<PacientForamOperation>(context,
              //                       listen: false)
              //                   .receiptsformData[index]
              //                   .amount),
              //               Text(Provider.of<PacientForamOperation>(context,
              //                       listen: false)
              //                   .receiptsformData[index]
              //                   .user_names),
              //             ],
              //           ),
              //         );
              //
              //       },
              //     ),
              //   );
              return Scaffold(
                appBar: AppBar(
                  title: Text('Expense'),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                        child: DataTable(
                          horizontalMargin: 10, // Adjust horizontal margin as needed
                          columns: <DataColumn>[
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Branch Name')),
                            DataColumn(label: Text('Number of Patient')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('User Names')),
                          ],
                          rows: Provider.of<PacientForamOperation>(context, listen: false)
                              .receiptsformData
                              .map((formData) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(formData.id)),
                              DataCell(Text(formData.date)),
                              DataCell(Text(formData.branch_name)),
                              DataCell(Text(formData.patientName)),
                              DataCell(Text(formData.amount)),
                              DataCell(Text(formData.user_names)),
                            ],
                          ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );

            }
          }
        });
  }
}

// class EmployInfoShowModal extends StatefulWidget {
//   const EmployInfoShowModal({Key? key}) : super(key: key);
//
//   @override
//   State<EmployInfoShowModal> createState() => _EmployInfoShowModalState();
// }
//
// class _EmployInfoShowModalState extends State<EmployInfoShowModal> {
//   late EmployModel employModel = EmployModel(
//       id: "",
//       date: "",
//       empNumber: "",
//       full_name: "",
//       designation: "",
//       mobile_no: "",
//       alternate_no: "",
//       email: "",
//       gender: "",
//       date_of_birth: "",
//       address: "",
//       pan_card: "",
//       aadhar_card: "",
//       user_identification: "",
//       In_Time_1st: "",
//       Out_Time_1st: "",
//       In_Time_2nd: "",
//       Out_Time_2nd: "",
//       total_working_hours: "",
//       working_days: "",
//       sun_In_Time: "",
//       sun_out_Time: "",
//       sun_working_hours: "",
//       number_of_sunday: "",
//       salary: "",
//       days: "",
//       sal_per_days: "");
//   GlobalKey<FormState> Empkey = GlobalKey<FormState>();
//
//   late TextEditingController emailcontroller = TextEditingController();
//   late TextEditingController fullnamecontroller = TextEditingController();
//   late TextEditingController designationcontroller = TextEditingController();
//   late TextEditingController mobilecontroller = TextEditingController();
//   late TextEditingController altermobilecontrol = TextEditingController();
//   late TextEditingController pancontroller = TextEditingController();
//   late TextEditingController aadharcontroller = TextEditingController();
//   late TextEditingController addresscontroller = TextEditingController();
//
//   late List<bool> isSelectedForGender;
//   List<String> GenderType = ["Male", "Female", "Other"];
//
//   void initState() {
//     // this is for 3 buttons, add "false" same as the number of buttons here
//     isSelectedForGender = [true, false, false];
//   }
//
//   Future<void> selectDate(BuildContext context) async {
//     final DateTime? d = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1975),
//       lastDate: DateTime(2099),
//     );
//     if (d != null)
//       setState(() {
//         employModel.date_of_birth = DateFormat("dd-MM-yyyy").format(d);
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Sheets Data'),
//       ),
//       body: ListView.builder(
//         itemCount:  Provider.of<PacientForamOperation>(context, listen: false).receiptsformData.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(Provider.of<PacientForamOperation>(context, listen: false).receiptsformData[index].patientName),
//           );
//         },
//       ),
//     );
//   }
// }
