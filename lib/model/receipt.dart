class ReceiptModel {
  String id;
  String patientId;
  String petientName;
  String date;
  String therepy;
  String amount;
  String modeOfPayment;
  String dignosisId;
  String user_id;

  ReceiptModel(
      {required this.id,
      required this.patientId,
      required this.petientName,
      required this.date,
      required this.therepy,
      required this.amount,
      required this.modeOfPayment,
      required this.dignosisId,
      required this.user_id});
  factory ReceiptModel.fromJson(dynamic json) {
    return ReceiptModel(
        id: "${json['id']}",
        patientId: "${json['patientId']}",
        petientName: "${json['patientName']}",
        date: "${json['date']}",
        therepy: "${json['therepy']}",
        amount: "${json['amount']}",
        modeOfPayment: "${json['modeOfPayment']}",
        dignosisId: "${json['dignosisId']}",
        user_id: "${json['user_id']}");
  }
  Map toJson() => {
        "id": id,
        "patientId": patientId,
        "petientName": petientName,
        "date": date,
        "therepy": therepy,
        "amount": amount,
        "modeOfPayment": modeOfPayment,
        "dignosisId": dignosisId,
        "user_id": user_id
      };
  String toParams() =>
      "?id=$id&patientId=$patientId&petientName=$petientName&date=$date&therepy=$therepy&amount=$amount&modeOfPayment=$modeOfPayment&dignosisId=$dignosisId&user_id=$user_id";
}
