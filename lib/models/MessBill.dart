class FeePaymentModel {
  String key;
  bool isPaid;
  int amount;
  String currency;
  String orderId;
  String paymentId;
  String semester;
  String institute;
  String date;
  int leaveDays;
  int totalDays;
  int daysLeft;
  String hostel;

  FeePaymentModel({
    required this.key,
    required this.isPaid,
    required this.amount,
    required this.currency,
    required this.orderId,
    required this.paymentId,
    required this.semester,
    required this.institute,
    required this.date,
    required this.daysLeft,
    required this.leaveDays,
    required this.totalDays,
    required this.hostel,
  });
}
