class LeaveApplyModel {
  String id;
  String emp_id;
  String emp_name;
  String supervisor_name;

  String leave_Type;
  String type_of_Day;

  String from_Date;
  String to_Date;
  String no_of_days;
  String half_Date;
  String full_Date;

  String reason;
  String mob_Avail;
  String email_Avail;
  String op_bal;
  String applied;
  String applicationDate;
  String approved;
  String rejected;
  String cancelled;
  String leave_status;

  LeaveApplyModel(
      {required this.id,
      required this.emp_id,
      required this.emp_name,
      required this.supervisor_name,
      required this.leave_Type,
      required this.type_of_Day,
      required this.from_Date,
      required this.to_Date,
      required this.no_of_days,
      required this.half_Date,
      required this.full_Date,
      required this.reason,
      required this.mob_Avail,
      required this.email_Avail,
      required this.op_bal,
      required this.applied,
      required this.applicationDate,
      required this.approved,
      required this.rejected,
      required this.cancelled,
      required this.leave_status});
  factory LeaveApplyModel.fromJson(dynamic json) {
    return LeaveApplyModel(
        id: "${json['id']}",
        emp_id: "${json['emp_id']}",
        emp_name: "${json['emp_name']}",
        supervisor_name: "${json['supervisor_name']}",
        leave_Type: "${json['leave_type']}",
        type_of_Day: "${json['type_of_Day']}",
        from_Date: "${json['from_Date']}",
        to_Date: "${json['to_Date']}",
        no_of_days: "${json['no_of_days']}",
        half_Date: "${json['half_Date']}",
        full_Date: "${json['full_Date']}",
        reason: "${json['reason']}",
        mob_Avail: "${json['mob_Avail']}",
        email_Avail: "${json['email_Avail']}",
        op_bal: "${json['op_bal']}",
        applied: "${json['applied']}",
        applicationDate: "${json['applicationDate']}",
        approved: "${json['approved']}",
        rejected: "${json['rejected']}",
        cancelled: "${json['cancelled']}",
        leave_status: "${json['leave_status']}");
  }
  Map toJson() => {
        "id": id,
        "emp_id": emp_id,
        "emp_name": emp_name,
        "supervisor_name": supervisor_name,
        "leave_Type": leave_Type,
        "type_of_Day": type_of_Day,
        "from_Date": from_Date,
        "to_Date": to_Date,
        "no_of_days": no_of_days,
        "half_Date": half_Date,
        "full_Date": full_Date,
        "reason": reason,
        "mob_Avail": mob_Avail,
        "email_Avail": email_Avail,
        "op_bal": op_bal,
        "applied": applied,
        "applicationDate": applicationDate,
        "approved": approved,
        "rejected": rejected,
        "cancelled": cancelled,
        "leave_status": leave_status
      };
  String toParams() =>
      "?id=$id&emp_id=$emp_id&emp_name=$emp_name&supervisor_name=$supervisor_name&leave_Type=$leave_Type&type_of_Day=$type_of_Day&from_Date=$from_Date&to_Date=$to_Date&no_of_days=$no_of_days&full_Date=$full_Date&reason=$reason&mob_Avail=$mob_Avail&email_Avail=$email_Avail&op_bal=$op_bal&applied=$applied&applicationDate=$applicationDate&approved=$approved&approved=$approved&rejected=$rejected&cancelled=$cancelled&leave_status=$leave_status";
}
