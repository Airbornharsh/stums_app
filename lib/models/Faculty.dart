class FacultyModel {
  String id;
  String institute;
  String phoneNumber;
  String emailId;
  List<String> students;
  List<String> leaveApplications;
  List<String> feePayments;
  List<String> messBills;

  FacultyModel(
      {required this.id,
      required this.institute,
      required this.phoneNumber,
      required this.emailId,
      required this.students,
      required this.leaveApplications,
      required this.feePayments,
      required this.messBills});
}
