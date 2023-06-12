import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceModel {
  int id;
  String date;
  String name;
  String in_time;
  String out_time;
  String target;
  String completion;
  String reviews;
  String location;
  String latitude;
  String longitude;
  String imagesemp;
  String acceptOrNot;
  String isWorking;
  String latitudeOff;
  String longitudeOff;
  String imagesemp2;
  String totalHour;
  String weekOff;
  String leave;
  String reqWorkigHours;
  String workedDays;
  String dailyPayment;
  String month;

  AttendanceModel(
      {required this.id,
      required this.date,
      required this.name,
      required this.in_time,
      required this.out_time,
      required this.target,
      required this.completion,
      required this.reviews,
      required this.location,
      required this.latitude,
      required this.longitude,
      required this.imagesemp,
      required this.acceptOrNot,
      required this.isWorking,
      required this.latitudeOff,
      required this.longitudeOff,
      required this.imagesemp2,
      required this.totalHour,
      required this.weekOff,
      required this.leave,
      required this.reqWorkigHours,
      required this.workedDays,
      required this.dailyPayment,
      required this.month});
  factory AttendanceModel.fromJson(dynamic json) {
    return AttendanceModel(
      id:  int.parse("${json['id']}"),
      date: "${json['date']}",
      name: "${json['name']}",
      in_time: "${json['in_time']}",
      out_time: "${json['out_time']}",
      target: "${json['target']}",
      completion: "${json['completion']}",
      reviews: "${json['reviews']}",
      location: "${json['location']}",
      latitude: "${json['latitude']}",
      longitude: "${json['longitude']}",
      imagesemp: "${json['imagesemp']}",
      acceptOrNot: "${json['acceptOrNot']}",
      isWorking: "${json['isWorking']}",
      latitudeOff: "${json['latitudeOff']}",
      longitudeOff: "${json['longitudeOff']}",
      imagesemp2: "${json['imagesemp2']}",
      totalHour: "${json['totalHour']}",
      weekOff: "${json['weekOff']}",
      leave: "${json['leave']}",
      reqWorkigHours: "${json['reqWorkigHours']}",
      workedDays: "${json['workedDays']}",
      dailyPayment: "${json['dailyPayment']}",
      month: "${json['month']}",
    );
  }
  Map toJson() => {
        "id": id,
        "date": date,
        'name': name,
        'in_time': in_time,
        'out_time': out_time,
        'target': target,
        'completion': completion,
        'reviews': reviews,
        'location': location,
        'latitude': latitude,
        "longitude": longitude,
        'imagesemp': imagesemp,
        'acceptOrNot': acceptOrNot,
        "isWorking": isWorking,
        "latitudeOff": latitudeOff,
        "longitudeOff": longitudeOff,
        "imagesemp2": imagesemp2,
        "totalHour": totalHour,
        "weekOff": weekOff,
        "leave": leave,
        "reqWorkigHours": reqWorkigHours,
        "workedDays": workedDays,
        "dailyPayment": dailyPayment,
        "month": month
      };
  List<String> getAttendanceData = [
    "id",
    "date",
    "name",
    "in_time",
    "out_time",
    "target",
    "completion",
    "reviews",
    "location",
    "latitude",
    "longitude",
    "imagesemp",
    'acceptOrNot',
    "isWorking",
    "latitudeOff",
    "longitudeOff",
    "imagesemp2",
    "totalHour",
  ];
  String toParams() =>
      "?id=$id&date=$date&name=$name&in_time=$in_time&out_time=$out_time&target=$target&completion=$completion&reviews=$reviews&location=$location&latitude=$latitude&longitude=$longitude&imagesemp=$imagesemp&acceptOrNot=$acceptOrNot&isWorking=$isWorking&latitudeOff=$latitudeOff&longitudeOff=$longitudeOff&imagesemp2=$imagesemp2&imagesemp2=$imagesemp2&totalHour=$totalHour&weekOff=$weekOff&leave=$leave&reqWorkigHours=$reqWorkigHours&workedDays=$workedDays&dailyPayment=$dailyPayment&month=$month";
}
