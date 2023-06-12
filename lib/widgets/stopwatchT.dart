import 'dart:async';
import 'package:flutter/material.dart';
import 'package:googlesheet/model/attendancemodel.dart';
import 'package:googlesheet/operations/attendanceOperations.dart';
import 'package:provider/provider.dart';

class StopWatchTimerPage extends StatefulWidget {
  @override
  _StopWatchTimerPageState createState() => _StopWatchTimerPageState();
}

class _StopWatchTimerPageState extends State<StopWatchTimerPage> {
  Duration countdownDuration = Duration(minutes: 00, hours: 00);
  Duration duration = Duration();
  DateTime todays = DateTime.now();
  late DateTime inDate;
  int hours = 0, minutes = 0, seconds = 0;
  List<AttendanceModel> workingAttendance = [];
  Timer? timer;

  bool countDown = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    workingAttendance =
        Provider.of<AttendanceOperations>(context, listen: false)
            .workingList;
    inDate = DateTime.parse(workingAttendance[0].in_time);
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());

    seconds = (todays.difference(inDate).inSeconds);

    countdownDuration = Duration(minutes: 00, hours: 00, seconds: seconds);
    print(countdownDuration);
    reset();
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? 1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          buildTime(),
        ],
      );

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(children: [
      buildTimeCard(time: hours, header: 'HH'),
      SizedBox(
        width: 8,
      ),
      buildTimeCard(time: minutes, header: 'MM'),
      SizedBox(
        width: 8,
      ),
      buildTimeCard(time: seconds, header: 'SS'),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(header, style: TextStyle(color: Colors.black45)),
        ],
      );

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;
    return isRunning || isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                  text: 'STOP',
                  onClicked: () {
                    if (isRunning) {
                      stopTimer(resets: false);
                    }
                  }),
              SizedBox(
                width: 12,
              ),
              ButtonWidget(text: "CANCEL", onClicked: stopTimer),
            ],
          )
        : ButtonWidget(
            text: "Start Timer!",
            color: Colors.black,
            backgroundColor: Colors.white,
            onClicked: () {
              startTimer();
            });
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onClicked;

  const ButtonWidget(
      {Key? key,
      required this.text,
      required this.onClicked,
      this.color = Colors.white,
      this.backgroundColor = Colors.black})
      : super(key: key);
  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
      onPressed: onClicked,
      child: Text(
        text,overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 20, color: color),
      ));
}
