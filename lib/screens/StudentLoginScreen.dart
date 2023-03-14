import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  final _registrationNoControllerController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _registrationNoControllerController.dispose();
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
            decoration: const BoxDecoration(color: Colors.white),
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 20, left: 10, right: 10, bottom: 20),
                width: (MediaQuery.of(context).size.width - 70),
                // height: 500,
                constraints: const BoxConstraints(maxHeight: 270),
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
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        padding: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 0, 190, 184))),
                        child: TextField(
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Registration Number",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          controller: _registrationNoControllerController,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        padding: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 0, 190, 184))),
                        child: TextField(
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
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
                            String loginRes =
                                await Provider.of<User>(context, listen: false)
                                    .studentLogin(
                                        _registrationNoControllerController.text
                                            .trim(),
                                        _passwordController.text.trim());
                            // await Provider.of<User>(context, listen: false)
                            //     .studentLogin("2101110049", "Password1");

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
                                  const Color.fromARGB(255, 0, 190, 184))),
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
                              color: Color.fromARGB(255, 0, 190, 184)),
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
