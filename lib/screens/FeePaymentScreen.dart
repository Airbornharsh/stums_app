import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stums_app/Utils/snackBar.dart';
import 'package:stums_app/models/Student.dart';
import 'package:stums_app/providers/user.dart';
import "package:stums_app/Utils/razorpayCredentials.dart";

class FeePaymentScreen extends StatefulWidget {
  static const String routeName = "/fee-payment";
  FeePaymentScreen({super.key});
  bool start = true;

  @override
  State<FeePaymentScreen> createState() => _FeePaymentScreenState();
}

class _FeePaymentScreenState extends State<FeePaymentScreen> {
  final _razorpay = Razorpay();
  bool isLoading = false;
  late StudentModel studentData;
  String _selectedYear = "0";
  List<dynamic> studentFeePayments = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isLoading = true;
      });
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print(response);
    setState(() {
      isLoading = true;
    });

    Provider.of<User>(context, listen: false)
        .verifyFeePaymentOrder(
            razorpaySignature: response.signature as String,
            razorpayPaymentId: response.paymentId as String,
            razorpayOrderId: response.orderId as String,
            year: _selectedYear)
        .then((value) {
      if (value) {
        snackBar(context, "Payment SuccessFull");
        Navigator.of(context).pop();
      } else {
        snackBar(context, "Payment Failed");
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    // Do something when payment fails
    setState(() {
      isLoading = false;
    });
    snackBar(context, response.message ?? '');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
    // Do something when an external wallet is selected
    setState(() {
      isLoading = false;
    });
    snackBar(context, response.walletName ?? "");
  }

  // create order
  void createOrder(int amount, String currency, String year) async {
    String orderId = await Provider.of<User>(context, listen: false)
        .createFeePaymentOrder(amount: amount, currency: currency, year: year);

    setState(() {
      isLoading = false;
    });
    print(orderId);

    if (orderId.isNotEmpty) {
      openGateway(orderId, amount, currency, year);
    } else {
      snackBar(context, "Error");
    }
  }

  openGateway(String orderId, int amount, String currency, String year) {
    var options = {
      'key': keyId,
      'amount': amount, //in the smallest currency sub-unit.
      'name': 'Fee Payment',
      'order_id': orderId, // Generate order_id using Orders API
      'description': '$year year Payment',
      'timeout': 60 * 5, // in seconds // 5 minutes
    };
    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    studentData = Provider.of<User>(context).getStudent;

    List<String> feePaymentKeys = studentData.feePayments.keys.toList();

    studentFeePayments = Provider.of<User>(context).getStudentFeePayments;

    if (widget.start) {
      setState(() {
        isLoading = true;
      });
      feePaymentKeys.forEach((element) {
        studentFeePayments.add({"isPaid": false});
      });
      Provider.of<User>(context, listen: false).studentFeePaymentList().then(
        (value) {
          setState(() {
            isLoading = false;
          });
        },
      );
      setState(() {
        widget.start = false;
      });
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Fee Payment")),
          body: ListView.builder(
            itemCount: feePaymentKeys.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                  title: Row(children: [
                    Text("${feePaymentKeys[index]} Year"),
                    const SizedBox(
                      width: 7,
                    ),
                    if (studentFeePayments[index]["isPaid"] as bool)
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    if (!studentFeePayments[index]["isPaid"])
                      const Icon(
                        Icons.pending,
                        color: Color.fromARGB(255, 255, 191, 105),
                      )
                  ]),
                  subtitle: const Text("amount 22900"),
                  children: [
                    Container(
                        color: Colors.white,
                        // height: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (!studentFeePayments[index]["isPaid"])
                              Row(
                                children: [
                                  const Text(
                                    "Amount ",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "₹22900 ",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            if (!studentFeePayments[index]["isPaid"])
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                      _selectedYear = feePaymentKeys[index];
                                    });
                                    createOrder(
                                        2290000, "INR", feePaymentKeys[index]);
                                  },
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              Color.fromARGB(255, 2, 48, 71))),
                                  child: const Text(
                                    "Pay",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            if (studentFeePayments[index]["isPaid"])
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Order Id ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    studentFeePayments[index]["feePayment"]
                                            .containsKey("orderId")
                                        ? studentFeePayments[index]
                                            ["feePayment"]["orderId"]
                                        : "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            if (studentFeePayments[index]["isPaid"])
                              const SizedBox(
                                height: 3,
                              ),
                            if (studentFeePayments[index]["isPaid"])
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Payment Id ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    studentFeePayments[index]["feePayment"]
                                            .containsKey("paymentId")
                                        ? studentFeePayments[index]
                                            ["feePayment"]["paymentId"]
                                        : "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            if (studentFeePayments[index]["isPaid"])
                              const SizedBox(
                                height: 3,
                              ),
                            if (studentFeePayments[index]["isPaid"])
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Paid ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    studentFeePayments[index]["feePayment"]
                                            .containsKey("amount")
                                        ? "₹${(studentFeePayments[index]["feePayment"]["amount"] / 100).toString()}"
                                        : "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            if (studentFeePayments[index]["isPaid"])
                              const SizedBox(
                                height: 3,
                              ),
                            if (studentFeePayments[index]["isPaid"])
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Payment Date ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    studentFeePayments[index]["feePayment"]
                                            .containsKey("date")
                                        ? DateFormat.yMMMMEEEEd().format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(
                                                    studentFeePayments[index]
                                                            ["feePayment"]
                                                        ["date"])))
                                        : "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                          ],
                        ))
                  ]);
            },
          ),
        ),
        if (isLoading)
          Positioned(
            top: 0,
            left: 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: const Color.fromRGBO(80, 80, 80, 0.3),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(child: CircularProgressIndicator()),
            ),
          )
      ],
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
