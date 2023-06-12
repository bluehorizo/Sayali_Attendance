class DiagnosisModel {
  String id;
  String inTimeId;
  String patientId;
  String patientName;
  String date;
  String condition;
  String medicines;
  String frequency;
  String method;
  String therepyType;
  String equipment_type;
  String operation;
  String tests;
  String referal_for_other;
  String status;
  String inTime;
  String outTime;
  String feesAmount;
  String user_id;

  DiagnosisModel(
      {required this.id,
      required this.inTimeId,
      required this.patientId,
      required this.patientName,
      required this.date,
      required this.condition,
      required this.medicines,
      required this.frequency,
      required this.method,
      required this.therepyType,
      required this.equipment_type,
      required this.operation,
      required this.tests,
      required this.referal_for_other,
      required this.status,
      required this.inTime,
      required this.outTime,
      required this.feesAmount,
      required this.user_id});
  factory DiagnosisModel.fromJson(dynamic json) {
    return DiagnosisModel(
        id: "${json['id']}",
        inTimeId: "${json['inTimeId']}",
        patientId: "${json['patientId']}",
        patientName: "${json['patientName']}",
        date: "${json['date']}",
        condition: "${json['condition']}",
        medicines: "${json['medicines']}",
        frequency: "${json['frequency']}",
        method: "${json['method']}",
        therepyType: "${json['therepyType']}",
        equipment_type: "${json['equipment_type']}",
        operation: "${json['operation']}",
        tests: "${json['tests']}",
        referal_for_other: "${json['referal_for_other']}",
        status: "${json['status']}",
        inTime: "${json['inTime']}",
        outTime: "${json['outTime']}",
        feesAmount: "${json['feesAmount']}",
        user_id: "${json['user_id']}");
  }

  Map toJson() => {
        "id": id,
        "inTimeId": inTimeId,
        "patientId": patientId,
        "patientName": patientName,
        'date': date,
        'condition': condition,
        'medicines': medicines,
        'frequency': frequency,
        'method': method,
        'therepyType': therepyType,
        'equipment_type': equipment_type,
        'operation': operation,
        'tests': tests,
        'referal_for_other': referal_for_other,
        "status": status,
        'inTime': inTime,
        'outTime': outTime,
        'feesAmount': feesAmount,
        'user_id': user_id,
      };
  String toParams() =>
      "?id=$id&inTimeId=$inTimeId&patientId=$patientId&patientName=$patientName&date=$date&condition=$condition&medicines=$medicines&frequency=$frequency&method=$method&therepyType=$therepyType&equipment_type=$equipment_type&operation=$operation&tests=$tests&referal_for_other=$referal_for_other&status=$status&inTime=$inTime&outTime=$outTime&feesAmount=$feesAmount&user_id=$user_id";
}
