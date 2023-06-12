class LeaveSummaryModel {
  String emp_id;
  String emp_name;
  String op_bal;
  String totalCasualLeave;

  String totalSickLeave;
  String totalPrivilageLeave;
  String totalMonthlyOff;
  String countCasualLeave;
  String countSickLeave;
  String countPrivilageLeave;
  String countMonthlyOff;
  String addition;
  String approved;
  String rejected;
  String cancelled;
  String closing_balance;

  LeaveSummaryModel(
      {required this.emp_id,
      required this.emp_name,
      required this.op_bal,
      required this.totalCasualLeave,
      required this.totalSickLeave,
      required this.totalPrivilageLeave,
      required this.totalMonthlyOff,
      required this.countCasualLeave,
      required this.countSickLeave,
      required this.countPrivilageLeave,
      required this.countMonthlyOff,
      required this.addition,
      required this.approved,
      required this.rejected,
      required this.cancelled,
      required this.closing_balance});

  List<String> getAttendanceData = [
    "emp_id",
    "emp_name",
    "op_bal",
    "totalCasualLeave",
    "totalSickLeave",
    "totalPrivilageLeave",
    "totalMonthlyOff",
    "countCasualLeave",
    "countSickLeave",
    "countPrivilageLeave",
    "countMonthlyOff",
    "addition",
    "approved",
    "rejected",
    "cancelled",
    "closing_balance"
  ];

  factory LeaveSummaryModel.fromJson(dynamic json) {
    return LeaveSummaryModel(
        emp_id: "${json['emp_id']}",
        emp_name: "${json['emp_name']}",
        op_bal: "${json['op_bal']}",
        totalCasualLeave: "${json['totalCasualLeave']}",
        totalSickLeave: "${json['totalSickLeave']}",
        totalPrivilageLeave: "${json['totalPrivilageLeave']}",
        totalMonthlyOff: "${json['totalMonthlyOff']}",
        countCasualLeave: "${json['countCasualLeave']}",
        countSickLeave: "${json['countSickLeave']}",
        countPrivilageLeave: "${json['countPrivilageLeave']}",
        countMonthlyOff: "${json['countMonthlyOff']}",
        addition: "${json['addition']}",
        approved: "${json['approved']}",
        rejected: "${json['rejected']}",
        cancelled: "${json['cancelled']}",
        closing_balance: "${json['closing_balance']}");
  }
}
