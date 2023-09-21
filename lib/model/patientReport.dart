class PatientReportModel {
  String id;
  String date;
  String patientName;
  String branch_name;
  String amount;
  String user_names;

  PatientReportModel({
    required this.id,
    required this.date,
    required this.patientName,
    required this.branch_name,
    required this.amount,
    required this.user_names,
  });

  factory PatientReportModel.fromJson(dynamic json) {
    return PatientReportModel(
      id: "${json['id']}",
      date: "${json['date']}",
      patientName: "${json['patientName']}",
      branch_name: "${json['branch_name']}",
      amount: "${json['amount']}",
      user_names: "${json['user_names']}",
    );
  }

  Map toJson() => {
        "id": id,
        "date": date,
        "patient_name": patientName,
        "branch_name": branch_name,
        "amount": amount,
        "user_names": user_names,
      };
  String toParams() =>
      "?id=$id&date=$date&patientName=$patientName&branch_name=$branch_name&amount=$amount&user_names=$user_names";
}
