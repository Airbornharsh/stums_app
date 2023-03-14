import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stums_app/models/Student.dart';
import 'package:stums_app/providers/user.dart';
import 'package:stums_app/screens/FacultyAddStudent.dart';
import 'package:stums_app/screens/FacultyFeePaymentScreen.dart';
import 'package:stums_app/screens/FacultyLeaveApplications.dart';
import 'package:stums_app/screens/FacultyMessBillScreen.dart';
import 'package:stums_app/screens/FeePaymentScreen.dart';
import 'package:stums_app/screens/MessBillScreen.dart';
import 'package:stums_app/screens/StudentProfileScreen.dart';

class FacultyScreen extends StatefulWidget {
  static const String routeName = "/faculty";
  const FacultyScreen({super.key});

  @override
  State<FacultyScreen> createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  bool isLoading = false;
  late StudentModel student;

  @override
  Widget build(BuildContext context) {
    student = Provider.of<User>(context, listen: false).getStudent;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text("Faculty"), actions: [
            Container(
              margin: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(StudentProfileScreen.routeName);
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Image.asset("lib/assets/teacher.png"))),
              ),
            ),
          ]),
          drawer: Drawer(
              child: Column(
            children: [
              Container(
                decoration:
                    const BoxDecoration(color: Color.fromARGB(255, 2, 48, 71)),
                height: 200,
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Image.asset("lib/assets/teacher.png"))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        student.name,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Provider.of<User>(context, listen: false).logOut();

                      Navigator.of(context).pop();
                      Navigator.of(context).popAndPushNamed("/");
                    },
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 8,
                        ),
                        Icon(Icons.logout),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Log Out")
                      ],
                    )),
              ),
            ],
          )),
          body: Container(
            color: Colors.grey.shade200,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 25),
                width: MediaQuery.of(context).size.width - 30,
                child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15),
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(FacultyAddStudent.routeName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 223, 241, 250),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4,
                                  blurStyle: BlurStyle.normal)
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "lib/assets/students.png",
                                  // height: 190,
                                  width: (MediaQuery.of(context).size.width -
                                          230) /
                                      2,
                                ),
                                const SizedBox(
                                  height: 28,
                                ),
                                const Text(
                                  "Add Student",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 2, 48, 71),
                                      fontWeight: FontWeight.w500),
                                )
                              ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(FacultyFeePaymentScreen.routeName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 247, 236, 208),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4,
                                  blurStyle: BlurStyle.normal)
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "lib/assets/feePayment.png",
                                  // height: 190,
                                  width: (MediaQuery.of(context).size.width -
                                          230) /
                                      2,
                                ),
                                const SizedBox(
                                  height: 28,
                                ),
                                const Text(
                                  "Fee Payments",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 2, 48, 71),
                                      fontWeight: FontWeight.w500),
                                )
                              ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(FacultyMessBillScreen.routeName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 237, 223, 250),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4,
                                  blurStyle: BlurStyle.normal)
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "lib/assets/messBill.png",
                                  // height: 190,
                                  width: (MediaQuery.of(context).size.width -
                                          230) /
                                      2,
                                ),
                                const SizedBox(
                                  height: 28,
                                ),
                                const Text(
                                  "Mess Bills",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 2, 48, 71),
                                      fontWeight: FontWeight.w500),
                                )
                              ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(FacultyLeaveApplications.routeName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 224, 241, 203),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4,
                                  blurStyle: BlurStyle.normal)
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "lib/assets/leaveApplications.png",
                                  // height: 190,
                                  width: (MediaQuery.of(context).size.width -
                                          230) /
                                      2,
                                ),
                                const SizedBox(
                                  height: 28,
                                ),
                                const Text(
                                  "Leave Applications",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 2, 48, 71),
                                      fontWeight: FontWeight.w500),
                                )
                              ]),
                        ),
                      ),
                    ]),
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
