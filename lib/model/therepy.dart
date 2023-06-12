class Therepy {
  String id;
  String inTimeId;
  String patientId;
  String patientName;
  String excercise_name;
  String feed_back_from_patient;
  String feesAmount;
  String inTime;
  String outTime;
  String user_id;

  Therepy(
      {required this.id,
      required this.inTimeId,
      required this.patientId,
      required this.patientName,
      required this.excercise_name,
      required this.feed_back_from_patient,
      required this.feesAmount,
      required this.inTime,
      required this.outTime,
      required this.user_id});
  factory Therepy.fromJson(dynamic json) {
    return Therepy(
        id: "${json['id']}",
        inTimeId: "${json['inTimeId']}",
        patientId: "${json['patientId']}",
        patientName: "${json['patientName']}",
        excercise_name: "${json['excercise_name']}",
        feed_back_from_patient: "${json['feed_back_from_patient']}",
        feesAmount: "${json['feesAmount']}",
        inTime: "${json['inTime']}",
        outTime: "${json['outTime']}",
        user_id: "${json['user_id']}");
  }
  Map toJson() => {
        "id": id,
        "inTimeId": inTimeId,
        "patientId": patientId,
        "patientName": patientName,
        "excercise_name": excercise_name,
        "feed_back_from_patient": feed_back_from_patient,
        "feesAmount": feesAmount,
        "inTime": inTime,
        "outTime": outTime,
        "user_id": user_id
      };
  String toParams() =>
      "?id=$id&inTimeId=$inTimeId&patientId=$patientId&patientName=$patientName&excercise_name=$excercise_name&feed_back_from_patient=$feed_back_from_patient&feesAmount=$feesAmount&inTime=$inTime&outTime=$outTime&user_id=$user_id";
}
