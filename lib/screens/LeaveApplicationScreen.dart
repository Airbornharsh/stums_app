import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stums_app/Utils/snackBar.dart';
import 'package:stums_app/providers/user.dart';

class LeaveApplicationScreen extends StatefulWidget {
  static const String routeName = "/leave-application";
  const LeaveApplicationScreen({super.key});

  @override
  State<LeaveApplicationScreen> createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  bool _isLoading = false;
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _hostelController = TextEditingController();
  DateTime _fromDate = DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch + 86400000);
  DateTime _toDate = DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch + 172800000);

  @override
  void dispose() {
    // TODO: implement dispose

    _subjectController.dispose();
    _descriptionController.dispose();
    // _fromController.dispose();
    _hostelController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 2, 48, 71),
            title: const Text("Leave Application"),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          padding: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(255, 2, 48, 71))),
                          child: TextField(
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "Subject",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            controller: _subjectController,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          padding: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(255, 2, 48, 71))),
                          child: TextField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "Description",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            controller: _descriptionController,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          padding: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(255, 2, 48, 71))),
                          child: DateTimeField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "From",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            selectedDate: _fromDate,
                            dateFormat: DateFormat.yMMMMEEEEd(),
                            onDateSelected: (value) {
                              setState(() {
                                _fromDate = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          padding: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(255, 2, 48, 71))),
                          child: DateTimeField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "to",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            selectedDate: _toDate,
                            dateFormat: DateFormat.yMMMMEEEEd(),
                            onDateSelected: (value) {
                              setState(() {
                                _toDate = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          padding: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(255, 2, 48, 71))),
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
                        TextButton(
                          onPressed: () async {
                            try {
                              setState(() {
                                _isLoading = true;
                              });

                              if (_subjectController.text.isEmpty ||
                                  _descriptionController.text.isEmpty ||
                                  _hostelController.text.isEmpty) {
                                snackBar(context, "Fill all Details");
                                setState(() {
                                  _isLoading = false;
                                });
                                return;
                              }

                              String res = await Provider.of<User>(context,
                                      listen: false)
                                  .addLeaveApplication(
                                      subject: _subjectController.text,
                                      description: _descriptionController.text,
                                      fromDate: _fromDate.millisecondsSinceEpoch
                                          .toString(),
                                      toDate: _toDate.millisecondsSinceEpoch
                                          .toString(),
                                      hostel: _hostelController.text);

                              _subjectController.clear();
                              _descriptionController.clear();
                              _hostelController.clear();

                              setState(() {
                                _isLoading = false;
                              });

                              if (res == "Done") {
                                snackBar(context, "Application Submitted");
                              } else {
                                snackBar(context, "Try Again");
                              }
                            } catch (e) {
                              setState(() {
                                _isLoading = false;
                              });
                              snackBar(context, "Try Again");
                              print(e);
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 2, 48, 71))),
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
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
          ),
      ],
    );
  }
}
