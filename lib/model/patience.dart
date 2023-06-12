class PatientModel {
  String id;
  String patient_ID;
  String date;
  String patient_name;
  String branch_name;
  String patient_mobile_number;
  String email;
  String alergies;
  String preExistingDecease;
  String patient_photo;
  String patientDOB;
  String age;
  String patient_gender;
  String emerg_contact_person;
  String emerg_mobile_number;
  String patient_weight_kg;
  String height;
  String patient_adhaar_number;
  String patient_PAN;
  String user_identification;
  String userEmailId;

  PatientModel(
      {required this.id,
      required this.patient_ID,
      required this.date,
      required this.patient_name,
      required this.branch_name,
      required this.patient_mobile_number,
      required this.email,
      required this.alergies,
      required this.preExistingDecease,
      required this.patient_photo,
      required this.patientDOB,
      required this.age,
      required this.patient_gender,
      required this.emerg_contact_person,
      required this.emerg_mobile_number,
      required this.patient_weight_kg,
      required this.height,
      required this.patient_adhaar_number,
      required this.patient_PAN,
      required this.user_identification,
      required this.userEmailId});

  factory PatientModel.fromJson(dynamic json) {
    return PatientModel(
        id: "${json['id']}",
        patient_ID: "${json['patient_ID']}",
        date: "${json['date']}",
        patient_name: "${json['patient_name']}",
        branch_name: "${json['branch_name']}",
        patient_mobile_number: "${json['patient_mobile_number']}",
        email: "${json['email']}",
        alergies: "${json['alergies']}",
        preExistingDecease: "${json['preExistingDecease']}",
        patient_photo: "${json['patient_photo']}",
        patientDOB: "${json['patientDOB']}",
        age: "${json['age']}",
        patient_gender: "${json['patient_gender']}",
        emerg_contact_person: "${json['emerg_contact_person']}",
        emerg_mobile_number: "${json['emerg_mobile_number']}",
        patient_weight_kg: "${json['patient_weight_kg']}",
        height: "${json['height']}",
        patient_adhaar_number: "${json['patient_adhaar_number']}",
        patient_PAN: "${json['patient_PAN']}",
        user_identification: "${json['user_identification']}",
        userEmailId: "${json['userEmailId']}");
  }

  Map toJson() => {
        "id": id,
        "patient_ID": patient_ID,
        "date": date,
        "patient_name": patient_name,
        "branch_name": branch_name,
        "patient_mobile_number": patient_mobile_number,
        "email": email,
        "alergies": alergies,
        "preExistingDecease": preExistingDecease,
        "patient_photo": patient_photo,
        "patientDOB": patientDOB,
        "age": age,
        "patient_gender": patient_gender,
        "emerg_contact_person": emerg_contact_person,
        "emerg_mobile_number": emerg_mobile_number,
        "patient_weight_kg": patient_weight_kg,
        "height": height,
        "patient_adhaar_number": patient_adhaar_number,
        "patient_PAN": patient_PAN,
        "user_identification": user_identification,
        "userEmailId": userEmailId
      };
  String toParams() =>
      "?id=$id&patient_ID=$patient_ID&date=$date&patient_name=$patient_name&branch_name=$branch_name&patient_mobile_number=$patient_mobile_number&email=$email&alergies=$alergies&preExistingDecease=$preExistingDecease&patient_photo=$patient_photo&patientDOB=$patientDOB&age=$age&patient_gender=$patient_gender&emerg_contact_person=$emerg_contact_person&emerg_mobile_number=$emerg_mobile_number&patient_weight_kg=$patient_weight_kg&height=$height&height=$height&patient_adhaar_number=$patient_adhaar_number&patient_PAN=$patient_PAN&user_identification=$user_identification&userEmailId=$userEmailId";
}
