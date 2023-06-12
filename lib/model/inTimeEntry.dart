class AppointemenetModel {
  String id;
  String patientId;
  String patientName;
  String consult_ther;
  String inTime;
  String outTime;
  String branchName;
  String staffName;
  String refer;
  String isSend;
  String diagnosisTherepyId;
  String isPaymentDone;
  String receiptID;
  String doctorId;
  String user_id;

  AppointemenetModel(
      {required this.id,
      required this.patientId,
      required this.patientName,
      required this.consult_ther,
      required this.inTime,
      required this.outTime,
      required this.branchName,
      required this.staffName,
      required this.refer,
      required this.isSend,
      required this.diagnosisTherepyId,
      required this.isPaymentDone,
      required this.receiptID,
      required this.doctorId,
      required this.user_id});
  factory AppointemenetModel.fromJson(dynamic json) {
    return AppointemenetModel(
        id: "${json['id']}",
        patientId: "${json['patientId']}",
        patientName: "${json['patientName']}",
        consult_ther: "${json['consult_ther']}",
        inTime: "${json['inTime']}",
        outTime: "${json['outTime']}",
        branchName: "${json['branchName']}",
        staffName: "${json['staffName']}",
        refer: "${json['refer']}",
        isSend: "${json['isSend']}",
        diagnosisTherepyId: "${json['diagnosisTherepyId']}",
        isPaymentDone: "${json['isPaymentDone']}",
        receiptID: "${json['receiptID']}",
        doctorId: "${json['doctorId']}",
        user_id: "${json['user_id']}");
  }
  Map toJson() => {
        "id": id,
        "patientId": patientId,
        "patientName": patientName,
        "consult_ther": consult_ther,
        "inTime": inTime,
        "outTime": outTime,
        "branchName": branchName,
        "staffName": staffName,
        "refer": refer,
        "isSend": isSend,
        "diagnosisTherepyId": diagnosisTherepyId,
        "isPaymentDone": isPaymentDone,
        "receiptID": receiptID,
        "doctorId": doctorId,
        "user_id": user_id
      };
  String toParams() =>
      "?id=$id&patientId=$patientId&patientName=$patientName&consult_ther=$consult_ther&inTime=$inTime&outTime=$outTime&branchName=$branchName&staffName=$staffName&refer=$refer&isSend=$isSend&diagnosisTherepyId=$diagnosisTherepyId&receiptID=$receiptID&doctorId=$doctorId&user_id=$user_id";
  String toUpdate() =>
      "?id=$id";
}
