class PatientReportModel {
  String date;
  String patientName;
  String branch_name;
  String amount;
  String user_names;

  PatientReportModel({
    required this.date,
    required this.patientName,
    required this.branch_name,
    required this.amount,
    required this.user_names,
  });

  factory PatientReportModel.fromJson(dynamic json) {
    return PatientReportModel(
      date: "${json['date']}",
      patientName: "${json['patientName']}",
      branch_name: "${json['branch_name']}",
      amount: "${json['amount']}",
      user_names: "${json['user_names']}",
    );
  }

  Map toJson() => {
        "id": 0,
        "date": date,
        "patient_name": patientName,
        "branch_name": branch_name,
        "amount": amount,
        "user_names": user_names,
      };
  String toParams() =>
      "?date=$date&patientName=$patientName&branch_name=$branch_name&amount=$amount&user_names=$user_names";
}
