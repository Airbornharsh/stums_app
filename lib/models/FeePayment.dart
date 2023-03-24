class FeePaymentModel {
  String key;
  bool isPaid;
  int amount;
  String currency;
  String orderId;
  String paymentId;
  String year;
  String institute;
  String date;

  FeePaymentModel({
    required this.key,
    required this.isPaid,
    required this.amount,
    required this.currency,
    required this.orderId,
    required this.paymentId,
    required this.year,
    required this.institute,
    required this.date,
  });
}
