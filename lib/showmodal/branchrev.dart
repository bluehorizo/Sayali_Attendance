import 'package:flutter/material.dart';

import 'package:provider/provider.dart';



import '../operations/pacientFormOpeation.dart';


class branch_rev extends StatefulWidget {
  @override
  State<branch_rev> createState() => _branch_revState();
}

class _branch_revState extends State<branch_rev> {
  DateTime? fromDate;
  DateTime? toDate;
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

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
                                      TextButton.icon(

                                        icon: Icon(Icons.date_range),
                                        label: Text("Today's Date"),

                                        onPressed: () async {
                                          final DateTime? picked =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: orderData.selectedDate,
                                            firstDate: DateTime(2023),
                                            lastDate: DateTime(2030),
                                          );
                                          if (picked != null &&
                                              picked !=
                                                  orderData.selectedDate) {
                                            orderData
                                                .getpatientMonthlyList(picked);
                                          }

                                        },
                                      ),
                                    ],
                                  ),

                                  Container(

                                    child: Consumer<PacientForamOperation>(
                                      builder: (context, myDataModel, child) {
                                        return SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            columns: [
                                              DataColumn(label: Text('ID')),
                                              DataColumn(label: Text('Date')),
                                              DataColumn(
                                                  label: Text('Branch Name')),
                                              DataColumn(
                                                  label:
                                                      Text('Number of Patient')),
                                              DataColumn(label: Text('Amount')),
                                              DataColumn(
                                                  label: Text('User Names')),
                                            ],
                                            rows: myDataModel.listrev.map((item) {
                                              return DataRow(
                                                cells: [
                                                  DataCell(Text(item.id)),
                                                  DataCell(Text(item.date)),
                                                  DataCell(
                                                      Text(item.branch_name)),
                                                  DataCell(
                                                      Text(item.patientName)),
                                                  DataCell(Text(item.amount)),
                                                  DataCell(Text(item.user_names)),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        );
                                      },
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
