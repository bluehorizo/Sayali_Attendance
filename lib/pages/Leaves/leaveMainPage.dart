import 'package:flutter/material.dart';
import 'package:googlesheet/operations/LeavesOperation.dart';
import 'package:provider/provider.dart';

import '../../operations/authOperations.dart';
import 'leaveListHistory.dart';
import 'createLeaveApplication.dart';

class LeaveMainPage extends StatefulWidget {
  const LeaveMainPage({Key? key}) : super(key: key);

  @override
  State<LeaveMainPage> createState() => _LeaveMainPageState();
}

class _LeaveMainPageState extends State<LeaveMainPage> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<LeaveOperations>(this.context, listen: false)
        .getLeaveSummaryFromSheet(
            Provider.of<AuthOperation>(this.context, listen: false).user.name,
            Provider.of<AuthOperation>(this.context, listen: false).isAdmin());
    Provider.of<LeaveOperations>(this.context, listen: false)
        .getLeaveDataFromSheet(
        Provider.of<AuthOperation>(this.context, listen: false).user.name,
        Provider.of<AuthOperation>(this.context, listen: false).isAdmin());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
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
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(25.0)),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Tab(text: 'Leave'),
                    Tab(text: 'History'),
                  ],
                ),
              ),
              Expanded(
                  child: TabBarView(
                children: [
                  CreateLeaveApplication(),
                  LeaveListHistory(),
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
