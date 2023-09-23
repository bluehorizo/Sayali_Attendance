import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_month_picker/flutter_month_picker.dart';
import 'package:googlesheet/operations/employeeOperation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../model/employeemodel.dart';
import '../operations/attendanceOperations.dart';
import '../operations/pacientFormOpeation.dart';
import '../themes/color.dart';

class branch_rev extends StatefulWidget {
  @override
  State<branch_rev> createState() => _branch_revState();
}

class _branch_revState extends State<branch_rev> {
  DateTime? fromDate;
  DateTime? toDate;
  DateTime ? selectedDate;

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
              return Scaffold(
                  appBar: AppBar(
                    title: Text('Branch Collection'),
                  ),
                  body: Consumer<PacientForamOperation>(
                    builder: (context, orderData, child) =>
                        SingleChildScrollView(
                      child: Column(
                        children: [
                          // Card for the bar graph
                          Card(
                            elevation:
                                4, // Add elevation for a card-like appearance
                            margin:
                                EdgeInsets.all(10), // Add margin for spacing
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  // Add your bar graph here (using the FLChart library)
                                ],
                              ),
                            ),
                          ),



                          Card(
                            elevation: 4,
                            margin: EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      // TextButton(
                                      //   onPressed: () async {
                                      //     DateTime? selectedDate =
                                      //         await showDatePicker(
                                      //       context: context,
                                      //       initialDate:
                                      //           fromDate ?? DateTime.now(),
                                      //       firstDate: DateTime(2000),
                                      //       lastDate: DateTime(2101),
                                      //       builder: (BuildContext context,
                                      //           Widget? child) {
                                      //         return Theme(
                                      //           data: ThemeData
                                      //               .light(), // You can customize the theme
                                      //           child: child!,
                                      //         );
                                      //       },
                                      //     );
                                      //     if (selectedDate != null) {
                                      //       setState(() {
                                      //         fromDate = selectedDate;
                                      //       });
                                      //     }
                                      //   },
                                      //   child: Text(
                                      //     fromDate != null
                                      //         ? 'From: ${DateFormat.yMMM().format(fromDate!)}'
                                      //         : 'Select From Month',
                                      //   ),
                                      // ),

                                      TextButton.icon(
                                          onPressed: () async {
                                             selectedDate =
                                                (await showMonthPicker(
                                              context: context,
                                                  initialDate: selectedDate ?? DateTime.now(),
                                              firstDate: DateTime(
                                                  DateTime.now().year - 1, 5),
                                              lastDate: DateTime(
                                                  DateTime.now().year + 1, 9),
                                            ));
                                             if (selectedDate != null) {


                                                  Provider.of<PacientForamOperation>(context, listen: false)
                                                     .getpatientMonthlyList(selectedDate!);

                                             }


                                            // dateController.text =
                                            //     date.toString().substring(0, 10);
                                          },
                                          icon: Icon(Icons.date_range),
                                          label: Text("huhuhaha")),
                                    ],
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      horizontalMargin: 10,
                                      columns: <DataColumn>[
                                        DataColumn(label: Text('Month')),
                                        DataColumn(label: Text('ID')),
                                        DataColumn(label: Text('Date')),
                                        DataColumn(label: Text('Branch Name')),
                                        DataColumn(
                                            label: Text('Number of Patient')),
                                        DataColumn(label: Text('Amount')),
                                        DataColumn(label: Text('User Names')),
                                      ],
                                      rows: orderData.receiptsformData.where((formData) {
                                        final formDataDate =
                                            DateTime.parse(formData.date);
                                        if (fromDate != null &&
                                            toDate != null) {
                                          return formDataDate
                                                  .isAfter(fromDate!) &&
                                              formDataDate.isBefore(toDate!
                                                  .add(Duration(days: 1)));
                                        } else if (fromDate != null) {
                                          return formDataDate
                                              .isAfter(fromDate!);
                                        } else if (toDate != null) {
                                          return formDataDate.isBefore(
                                              toDate!.add(Duration(days: 1)));
                                        }
                                        return true;
                                      }).map((formData) {
                                        final month = DateFormat.yMMMM().format(
                                            DateTime.parse(formData.date));

                                        return DataRow(
                                          cells: <DataCell>[
                                            DataCell(Text(month)),
                                            DataCell(Text(formData.id)),
                                            DataCell(Text(formData.date)),
                                            DataCell(
                                                Text(formData.branch_name)),
                                            DataCell(
                                                Text(formData.patientName)),
                                            DataCell(Text(formData.amount)),
                                            DataCell(Text(formData.user_names)),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
            }
          }
        });
  }
}
