class approvalmodel {
  String id;
  String name;
  String outTime;
  String reason;
  String approved;
  String rejected;

  approvalmodel({
    required this.id,
    required this.name,
    required this.outTime,
    required this.reason,
    required this.approved,
    required this.rejected,
  });
  factory approvalmodel.fromJson(Map<String, dynamic> json) {
    print(json['outTime']);
    return approvalmodel(


      id: "${json['id']}",
      name: "${json['name']}",
      outTime: "${json['outTime']}",
      reason: "${json['reason']}",
      approved: "${json['approved']}",
      rejected: "${json['rejected']}",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'outTime': outTime,
      'reason': reason,
      'approved': approved,
      'rejected': rejected,
    };
  }


  String toParams() =>
      "?id=$id&name=$name&outTime=$outTime&reason=$reason&approved=$approved&rejected=$rejected";
}
