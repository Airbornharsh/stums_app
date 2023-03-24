import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stums_app/Utils/snackBar.dart';
import 'package:stums_app/models/Student.dart';
import 'package:stums_app/providers/user.dart';
import "package:stums_app/Utils/razorpayCredentials.dart";

class MessBillScreen extends StatefulWidget {
  static const String routeName = "/mess-bill";
  MessBillScreen({super.key});
  bool start = true;

  @override
  State<MessBillScreen> createState() => _MessBillScreenState();
}

class _MessBillScreenState extends State<MessBillScreen> {
  final _razorpay = Razorpay();
  final _roomNoController = TextEditingController();
  final _hostelController = TextEditingController();
  bool isLoading = false;
  late StudentModel studentData;
  String _selectedSemester = "0";
  List<dynamic> studentMessBills = [];

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

  @override
  void dispose() {
    // TODO: implement dispose
    _hostelController.dispose();
    _roomNoController.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print(response);
    setState(() {
      isLoading = true;
    });

    Provider.of<User>(context, listen: false)
        .verifyMessBillOrder(
            razorpaySignature: response.signature as String,
            razorpayPaymentId: response.paymentId as String,
            razorpayOrderId: response.orderId as String,
            semester: _selectedSemester)
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
  void createOrder(int amount, String currency, String semester) async {
    String orderId = await Provider.of<User>(context, listen: false)
        .createMessBillOrder(
            amount: amount,
            currency: currency,
            semester: semester,
            roomNo: int.parse(_roomNoController.text),
            hostel: _hostelController.text.trim());

    setState(() {
      isLoading = false;
    });
    print(orderId);

    if (orderId.isNotEmpty) {
      openGateway(orderId, amount, currency, semester);
    } else {
      snackBar(context, "Error");
    }
  }

  openGateway(String orderId, int amount, String currency, String semester) {
    var options = {
      'key': keyId,
      'amount': amount, //in the smallest currency sub-unit.
      'name': 'Mess Bill',
      'order_id': orderId, // Generate order_id using Orders API
      'description': '$semester Semester Payment',
      'timeout': 60 * 5, // in seconds // 5 minutes
    };
    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    studentData = Provider.of<User>(context).getStudent;

    List<String> messBillKeys = studentData.messBills.keys.toList();

    studentMessBills = Provider.of<User>(context).getStudentMessBills;

    if (widget.start) {
      setState(() {
        isLoading = true;
      });
      messBillKeys.forEach((element) {
        studentMessBills.add({"isPaid": false});
      });
      Provider.of<User>(context, listen: false).studentMessBillList().then(
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
          appBar: AppBar(title: const Text("Mess Bill")),
          body: ListView.builder(
            itemCount: messBillKeys.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                  title: Row(children: [
                    Text("${messBillKeys[index]} Semester"),
                    const SizedBox(
                      width: 7,
                    ),
                    if (studentMessBills[index]["isPaid"] as bool)
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    if (!studentMessBills[index]["isPaid"])
                      const Icon(
                        Icons.pending,
                        color: Color.fromARGB(255, 255, 191, 105),
                      )
                  ]),
                  subtitle: const Text("amount 21900"),
                  children: [
                    Container(
                        color: Colors.white,
                        // height: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (!studentMessBills[index]["isPaid"])
                              Row(
                                children: [
                                  const Text(
                                    "Amount ",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "₹21900 ",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            if (!studentMessBills[index]["isPaid"])
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 14),
                                padding: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 0, 190, 184))),
                                child: TextField(
                                  style: const TextStyle(color: Colors.black),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelText: "Hostel Name",
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                  controller: _hostelController,
                                ),
                              ),
                            if (!studentMessBills[index]["isPaid"])
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 14),
                                padding: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 0, 190, 184))),
                                child: TextField(
                                  style: const TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelText: "Room No",
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                  controller: _roomNoController,
                                ),
                              ),
                            if (!studentMessBills[index]["isPaid"])
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                      _selectedSemester = messBillKeys[index];
                                    });
                                    createOrder(
                                        2190000, "INR", messBillKeys[index]);
                                  },
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              Color.fromARGB(255, 2, 48, 71))),
                                  child: const Text(
                                    "Pay",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            if (studentMessBills[index]["isPaid"])
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Room No ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    studentMessBills[index]["messBill"]
                                            .containsKey("roomNo")
                                        ? studentMessBills[index]["messBill"]
                                                ["roomNo"]
                                            .toString()
                                        : "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            if (studentMessBills[index]["isPaid"])
                              const SizedBox(
                                height: 3,
                              ),
                            if (studentMessBills[index]["isPaid"])
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Hostel Name ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    studentMessBills[index]["messBill"]
                                            .containsKey("hostel")
                                        ? studentMessBills[index]["messBill"]
                                                ["hostel"]
                                            .toString()
                                        : "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            if (studentMessBills[index]["isPaid"])
                              const SizedBox(
                                height: 3,
                              ),
                            if (studentMessBills[index]["isPaid"])
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Leave Days ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    studentMessBills[index]["messBill"]
                                            .containsKey("leaveDays")
                                        ? studentMessBills[index]["messBill"]
                                                ["leaveDays"]
                                            .toString()
                                        : "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            if (studentMessBills[index]["isPaid"])
                              const SizedBox(
                                height: 3,
                              ),
                            if (studentMessBills[index]["isPaid"])
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total Days ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    studentMessBills[index]["messBill"]
                                            .containsKey("totalDays")
                                        ? studentMessBills[index]["messBill"]
                                                ["totalDays"]
                                            .toString()
                                        : "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            if (studentMessBills[index]["isPaid"])
                              const SizedBox(
                                height: 3,
                              ),
                            if (studentMessBills[index]["isPaid"])
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
                                    studentMessBills[index]["messBill"]
                                            .containsKey("orderId")
                                        ? studentMessBills[index]["messBill"]
                                            ["orderId"]
                                        : "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            if (studentMessBills[index]["isPaid"])
                              const SizedBox(
                                height: 3,
                              ),
                            if (studentMessBills[index]["isPaid"])
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
                                    studentMessBills[index]["messBill"]
                                            .containsKey("paymentId")
                                        ? studentMessBills[index]["messBill"]
                                            ["paymentId"]
                                        : "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            if (studentMessBills[index]["isPaid"])
                              const SizedBox(
                                height: 3,
                              ),
                            if (studentMessBills[index]["isPaid"])
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
                                    studentMessBills[index]["messBill"]
                                            .containsKey("amount")
                                        ? "₹${(studentMessBills[index]["messBill"]["amount"] / 100).toString()}"
                                        : "",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            if (studentMessBills[index]["isPaid"])
                              const SizedBox(
                                height: 3,
                              ),
                            if (studentMessBills[index]["isPaid"])
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
                                    studentMessBills[index]["messBill"]
                                            .containsKey("date")
                                        ? DateFormat.yMMMMEEEEd().format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(
                                                    studentMessBills[index]
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
