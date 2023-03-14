import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stums_app/models/Student.dart';
import 'package:stums_app/providers/user.dart';
import 'package:stums_app/screens/FeePaymentScreen.dart';
import 'package:stums_app/screens/LeaveApplicationScreen.dart';
import 'package:stums_app/screens/LeaveApplications.dart';
import 'package:stums_app/screens/MessBillScreen.dart';
import 'package:stums_app/screens/StudentProfileScreen.dart';

class StudentScreen extends StatefulWidget {
  static const String routeName = "/student";
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  bool isLoading = false;
  late StudentModel student;

  @override
  Widget build(BuildContext context) {
    student = Provider.of<User>(context, listen: false).getStudent;

    // if (!Provider.of<User>(context).isStudentLoggedIn()) {
    //   Navigator.of(context).popAndPushNamed("/");
    // }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text(student.name), actions: [
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
                        child: Image.asset("lib/assets/student.png"))),
              ),
            ),
          ]),
          drawer: Drawer(
              child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 0, 190, 184)),
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
                                child: Image.asset("lib/assets/student.png"))),
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
                width: MediaQuery.of(context).size.width - 10,
                child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(LeaveApplicationScreen.routeName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "lib/assets/addApplication.png",
                                  // height: 190,
                                  width: (MediaQuery.of(context).size.width -
                                          230) /
                                      2,
                                ),
                                const SizedBox(
                                  height: 28,
                                ),
                                const Text(
                                  "Add Leave Application",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 190, 184),
                                      fontWeight: FontWeight.w500),
                                )
                              ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(FeePaymentScreen.routeName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3)),
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
                                  "Fee Payment",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 190, 184),
                                      fontWeight: FontWeight.w500),
                                )
                              ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(MessBillScreen.routeName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3)),
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
                                  "Mess Bill",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 190, 184),
                                      fontWeight: FontWeight.w500),
                                )
                              ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(LeaveApplicartions.routeName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3)),
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
                                      color: Color.fromARGB(255, 0, 190, 184),
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
