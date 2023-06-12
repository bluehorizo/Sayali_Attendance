class EmployModel {
  String id;
  String date;
  String empNumber;
  String full_name;
  String designation;
  String mobile_no;
  String alternate_no;

  String email;
  String gender;
  String date_of_birth;
  String address;
  String pan_card;
  String aadhar_card;
  String user_identification;
  String In_Time_1st;
  String Out_Time_1st;
  String In_Time_2nd;
  String Out_Time_2nd;
  String total_working_hours;
  String working_days;
  String sun_In_Time;
  String sun_out_Time;
  String sun_working_hours;
  String number_of_sunday;
  String salary;
  String days;
  String sal_per_days;

  EmployModel(
      {required this.id,
      required this.date,
      required this.empNumber,
      required this.full_name,
      required this.designation,
      required this.mobile_no,
      required this.alternate_no,
      required this.email,
      required this.gender,
      required this.date_of_birth,
      required this.address,
      required this.pan_card,
      required this.aadhar_card,
      required this.user_identification,
      required this.In_Time_1st,
      required this.Out_Time_1st,
      required this.In_Time_2nd,
      required this.Out_Time_2nd,
      required this.total_working_hours,
      required this.working_days,
      required this.sun_In_Time,
      required this.sun_out_Time,
      required this.sun_working_hours,
      required this.number_of_sunday,
      required this.salary,
      required this.days,
      required this.sal_per_days});
  factory EmployModel.fromJson(dynamic json) {
    return EmployModel(
        id: "${json['id']}",
        date: "${json['date']}",
        empNumber: "${json['empNumber']}",
        full_name: "${json['full_name']}",
        designation: "${json['designation']}",
        mobile_no: "${json['mobile_no']}",
        alternate_no: "${json['alternate_no']}",
        email: "${json['email']}",
        gender: "${json['gender']}",
        date_of_birth: "${json['date_of_birth']}",
        address: "${json['address']}",
        pan_card: "${json['pan_card']}",
        aadhar_card: "${json['aadhar_card']}",
        user_identification: "${json['user_identification']}",
        In_Time_1st: "${json['in_Time_1st']}",
        Out_Time_1st: "${json['out_Time_1st']}",
        In_Time_2nd: "${json['in_Time_2nd']}",
        Out_Time_2nd: "${json['out_Time_2nd']}",
        total_working_hours: "${json['total_working_hours']}",
        working_days: "${json['working_days']}",
        sun_In_Time: "${json['sun_In_Time']}",
        sun_out_Time: "${json['sun_out_Time']}",
        sun_working_hours: "${json['sun_working_hours']}",
        number_of_sunday: "${json['number_of_sunday']}",
        salary: "${json['salary']}",
        days: "${json['days']}",
        sal_per_days: "${json['sal_per_days']}");
  }

  Map toJson() => {
        "date": date,
        "empNumber": empNumber,
        "full_name": full_name,
        'designation': designation,
        'mobile_no': mobile_no,
        'alternate_no': alternate_no,
        'email': email,
        'gender': gender,
        'date_of_birth': date_of_birth,
        'address': address,
        'pan_card': pan_card,
        'aadhar_card': aadhar_card,
        'user_identification': user_identification,
        "in_Time_1st": In_Time_1st,
        "out_Time_1st": Out_Time_1st,
        "in_Time_2nd": In_Time_2nd,
        "Out_Time_2nd": Out_Time_2nd,
        "total_working_hours": total_working_hours,
        "working_days": working_days,
        "sun_In_Time": sun_In_Time,
        "sun_out_Time": sun_out_Time,
        "sun_working_hours": sun_working_hours,
        "number_of_sunday": number_of_sunday,
        "salary": salary,
        "days": days,
        "sal_per_days": sal_per_days
      };
  String toParams() =>
      "?date=$date&full_name=$full_name&designation=$designation&mobile_no=$mobile_no&alternate_no=$alternate_no&email=$email&gender=$gender&date_of_birth=$date_of_birth&address=$address&pan_card=$pan_card&aadhar_card=$aadhar_card&user_identification=$user_identification";
}
