import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stums_app/Utils/snackBar.dart';
import 'package:stums_app/providers/user.dart';
import 'package:stums_app/screens/FacultyLoginScreen.dart';
import 'package:stums_app/screens/StudentScreen.dart';

class StudentLoginScreen extends StatefulWidget {
  static const String routeName = "/student-auth";
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  bool isLoading = false;

  final _registrationNoController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _registrationNoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 20, left: 10, right: 10, bottom: 20),
                width: (MediaQuery.of(context).size.width - 70),
                // height: 500,
                constraints: const BoxConstraints(maxHeight: 310),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0.1, 2),
                          blurRadius: 7,
                          spreadRadius: 0.6,
                          blurStyle: BlurStyle.outer)
                    ]),
                child: Container(
                  child: Column(
                    children: [
                      const Text(
                        "Student Login",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                                blurStyle: BlurStyle.normal)
                          ],
                        ),
                        child: TextField(
                          style: const TextStyle(color: Colors.black),
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
                            horizontal: 15, vertical: 10),
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                                blurStyle: BlurStyle.normal)
                          ],
                        ),
                        child: TextField(
                          style: const TextStyle(color: Colors.black),
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
                      const SizedBox(
                        height: 4,
                      ),
                      TextButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });

                            if (_registrationNoController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              snackBar(context, "Fill all Details");
                              setState(() {
                                isLoading = false;
                              });
                              return;
                            }

                            String loginRes =
                                await Provider.of<User>(context, listen: false)
                                    .studentLogin(
                                        _registrationNoController.text.trim(),
                                        _passwordController.text.trim());
                            // await Provider.of<User>(context, listen: false)
                            //     .studentLogin("2101110032", "2002_40383");

                            if (loginRes == "Done") {
                              var snackBar = SnackBar(
                                content: const Text('Logged In'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              Navigator.of(context)
                                  .popAndPushNamed(StudentScreen.routeName);
                            } else {
                              var snackBar = SnackBar(
                                content: Text(loginRes),
                                // action: SnackBarAction(
                                //   label: 'Undo',
                                //   onPressed: () {
                                //     // Some code to undo the change.
                                //   },
                                // ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              // _authController.clear();
                              // _passwordController.clear();
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 2, 48, 71))),
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          )),
                      const SizedBox(
                        height: 7,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .popAndPushNamed(FacultyLoginScreen.routeName);
                        },
                        child: const Text(
                          "Login as Faculty Instead",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 2, 48, 71)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
          ),
      ],
    );
  }
}
