class StudentModel {
  String id;
  String institute;
  String name;
  String phoneNumber;
  String emailId;
  String dob;
  List<String> leaveApplications;
  Map<String, dynamic> feePayments;
  Map<String, dynamic> messBills;

  StudentModel(
      {required this.id,
      required this.institute,
      required this.name,
      required this.phoneNumber,
      required this.emailId,
      required this.dob,
      required this.leaveApplications,
      required this.feePayments,
      required this.messBills});
}

  // name: { type: String },
  // password: { type: String, required: true },
  // registrationNo: { type: String, required: true, unique: true },
  // emailId: { type: String, required: true },
  // phoneNumber: { type: String, required: true },
  // institute: { type: String },
  // dob: {type:String,required:true},
  // leaveApplications: [
  //   { type: Schema.Types.ObjectId, ref: "LeaveApplication", default: [] },
  // ],
  // feePayments: {
  //   type: Schema.Types.Mixed,
  // },
  // messBills: {
  //   type: Schema.Types.Mixed,
  // },