class MedicineModel {
  String id;
  String medicine_name;
  String condition;
  String qty_medicine;
  String manufactature;
  String barcode;
  String user_id;
  MedicineModel(
      {required this.id,
      required this.medicine_name,
      required this.condition,
      required this.qty_medicine,
      required this.manufactature,
      required this.barcode,
      required this.user_id});
  factory MedicineModel.fromJson(dynamic json) {
    return MedicineModel(
        id: "${json['id']}",
        medicine_name: "${json['medicine_name']}",
        condition: "${json['condition']}",
        qty_medicine: "${json['qty_medicine']}",
        manufactature: "${json['manufactature']}",
        barcode: "${json['barcode']}",
        user_id: "${json['user_id']}");
  }
  Map toJson() => {
        "id": id,
        "medicine_name": medicine_name,
        "condition": condition,
        "qty_medicine": qty_medicine,
        "manufactature": manufactature,
        "barcode": barcode,
        "user_id": user_id
      };
  String toParams() =>
      "?id=$id&medicine_name=$medicine_name&condition=$condition&qty_medicine=$qty_medicine&manufactature=$manufactature&user_id=$user_id";
}
