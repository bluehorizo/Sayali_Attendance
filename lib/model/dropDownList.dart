class DropDownListModel {
  String id;
  String frequncy;
  String method;
  String branch;
  String equipment;
  String condition;
  String therepyType;
  String excersise;

  DropDownListModel(
      {required this.id,
      required this.frequncy,
      required this.method,
      required this.branch,
      required this.equipment,
      required this.condition,
      required this.therepyType,
      required this.excersise});
  factory DropDownListModel.fromJson(dynamic json) {
    return DropDownListModel(
        id: "${json['id']}",
        frequncy: "${json['frequncy']}",
        method: "${json['method']}",
        branch: "${json['branch']}",
        equipment: "${json['equipment']}",
        condition: "${json['condition']}",
        therepyType: "${json['therepyType']}",
        excersise: "${json['excersise']}");
  }
  Map toJson() => {
        "id": id,
        "frequncy": frequncy,
        "method": method,
        "branch": branch,
        "equipment": equipment,
        "condition": condition,
        "therepyType": therepyType,
        "excersise": excersise
      };
  String toParams() => "?id=$id&frequncy=$frequncy";
}
