import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stums_app/Utils/snackBar.dart';
import 'package:stums_app/providers/user.dart';

class FacultyAddStudent extends StatefulWidget {
  static const String routeName = "/faculty-add-student";
  const FacultyAddStudent({super.key});

  @override
  State<FacultyAddStudent> createState() => _FacultyAddStudentState();
}

class _FacultyAddStudentState extends State<FacultyAddStudent> {
  bool _isLoading = false;
  final _registrationNoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailIdController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  DateTime _dob = DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch);

  @override
  void dispose() {
    // TODO: implement dispose

    _registrationNoController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailIdController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 0, 190, 184),
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
                                  color:
                                      const Color.fromARGB(255, 0, 190, 184))),
                          child: TextField(
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "Name",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            controller: _nameController,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          padding: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 0, 190, 184))),
                          child: TextField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "Registration Number",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            controller: _registrationNoController,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          padding: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 0, 190, 184))),
                          child: DateTimeField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "Date of Birth",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            selectedDate: _dob,
                            dateFormat: DateFormat.yMMMMEEEEd(),
                            onDateSelected: (value) {
                              setState(() {
                                _dob = value;
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
                                  color:
                                      const Color.fromARGB(255, 0, 190, 184))),
                          child: TextField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "Password",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            controller: _passwordController,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          padding: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 0, 190, 184))),
                          child: TextField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "Phone Number",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            controller: _phoneNumberController,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          padding: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 0, 190, 184))),
                          child: TextField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "Email Id",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            controller: _emailIdController,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              setState(() {
                                _isLoading = true;
                              });

                              if (_emailIdController.text.isEmpty ||
                                  _nameController.text.isEmpty ||
                                  _phoneNumberController.text.isEmpty ||
                                  _passwordController.text.isEmpty ||
                                  _registrationNoController.text.isEmpty) {
                                snackBar(context, "Fill all Details");
                                return;
                              }

                              bool res = (await Provider.of<User>(context,
                                      listen: false)
                                  .facultyCreateStudent(
                                      name: _nameController.text,
                                      password: _passwordController.text,
                                      phoneNumber: _phoneNumberController.text,
                                      registrationNo:
                                          _registrationNoController.text,
                                      emailId: _emailIdController.text,
                                      dob: _dob.millisecondsSinceEpoch
                                          .toString()));

                              _emailIdController.clear();
                              _nameController.clear();
                              _phoneNumberController.clear();
                              _passwordController.clear();
                              _registrationNoController.clear();

                              setState(() {
                                _isLoading = false;
                              });

                              if (res == true) {
                                snackBar(context, "Student Created");
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
                                  const Color.fromARGB(255, 0, 190, 184))),
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
