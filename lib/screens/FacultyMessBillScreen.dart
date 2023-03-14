import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stums_app/providers/user.dart';

class FacultyMessBillScreen extends StatefulWidget {
  static const String routeName = "/faculty-mess-bills";
  FacultyMessBillScreen({super.key});
  bool start = true;

  @override
  State<FacultyMessBillScreen> createState() => _FacultyMessBillScreenState();
}

class _FacultyMessBillScreenState extends State<FacultyMessBillScreen> {
  List<dynamic> facultyMessBill = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    facultyMessBill = Provider.of<User>(context).getFacultyMessBills;

    if (widget.start) {
      setState(() {
        isLoading = true;
      });
      Provider.of<User>(context, listen: false).facultyMessBillList().then(
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

    print(facultyMessBill.length);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Fee Payment")),
          body: ListView.builder(
            itemCount: facultyMessBill.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                  title: Row(children: [
                    Text(facultyMessBill[index]["userData"]["registrationNo"]),
                    Text(" - "),
                    Text(facultyMessBill[index]["userData"]["name"]),
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
                                  "Room No ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  facultyMessBill[index]["messBill"]
                                          .containsKey("roomNo")
                                      ? facultyMessBill[index]["messBill"]
                                          ["roomNo"].toString()
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
                                  "Hostel Name ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  facultyMessBill[index]["messBill"]
                                          .containsKey("hostel")
                                      ? facultyMessBill[index]["messBill"]
                                          ["hostel"]
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
                                  "Leave Days ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  facultyMessBill[index]["messBill"]
                                          .containsKey("leaveDays")
                                      ? facultyMessBill[index]["messBill"]
                                          ["leaveDays"].toString()
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
                                  "Total Days ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  facultyMessBill[index]["messBill"]
                                          .containsKey("totalDays")
                                      ? facultyMessBill[index]["messBill"]
                                          ["totalDays"].toString()
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
                                  "Order Id ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  facultyMessBill[index]["messBill"]
                                          .containsKey("orderId")
                                      ? facultyMessBill[index]["messBill"]
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
                                  facultyMessBill[index]["messBill"]
                                          .containsKey("paymentId")
                                      ? facultyMessBill[index]["messBill"]
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
                                  facultyMessBill[index]["messBill"]
                                          .containsKey("amount")
                                      ? "₹${(facultyMessBill[index]["messBill"]["amount"] / 100).toString()}"
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
                                  facultyMessBill[index]["messBill"]
                                          .containsKey("date")
                                      ? DateFormat.yMMMMEEEEd().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(facultyMessBill[index]
                                                  ["messBill"]["date"])))
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
