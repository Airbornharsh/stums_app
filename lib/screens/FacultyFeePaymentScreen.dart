import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stums_app/providers/user.dart';

class FacultyFeePaymentScreen extends StatefulWidget {
  static const String routeName = "/faculty-fee-payments";
  FacultyFeePaymentScreen({super.key});
  bool start = true;

  @override
  State<FacultyFeePaymentScreen> createState() =>
      _FacultyFeePaymentScreenState();
}

class _FacultyFeePaymentScreenState extends State<FacultyFeePaymentScreen> {
  List<dynamic> facultyFeePayment = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    facultyFeePayment = Provider.of<User>(context).getFacultyFeePayments;

    if (widget.start) {
      setState(() {
        isLoading = true;
      });
      Provider.of<User>(context, listen: false).facultyFeePaymentsList().then(
        (value) {
          setState(() {
            isLoading = false;
          });
        },
      ).catchError((e) {
        setState(() {
          isLoading = false;
        });
      });
      setState(() {
        widget.start = false;
      });
    }

    print(facultyFeePayment.length);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Fee Payment")),
          body: ListView.builder(
            itemCount: facultyFeePayment.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                  title: Row(children: [
                    Text(
                        facultyFeePayment[index]["userData"]["registrationNo"]),
                    Text(" - "),
                    Text(facultyFeePayment[index]["userData"]["name"]),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Order Id ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  facultyFeePayment[index]["feePayment"]
                                          .containsKey("orderId")
                                      ? facultyFeePayment[index]["feePayment"]
                                          ["orderId"]
                                      : "",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Payment Id ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  facultyFeePayment[index]["feePayment"]
                                          .containsKey("paymentId")
                                      ? facultyFeePayment[index]["feePayment"]
                                          ["paymentId"]
                                      : "",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Paid ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  facultyFeePayment[index]["feePayment"]
                                          .containsKey("amount")
                                      ? "₹${(facultyFeePayment[index]["feePayment"]["amount"] / 100).toString()}"
                                      : "",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Payment Date ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  facultyFeePayment[index]["feePayment"]
                                          .containsKey("date")
                                      ? DateFormat.yMMMMEEEEd().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(facultyFeePayment[index]
                                                  ["feePayment"]["date"])))
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
