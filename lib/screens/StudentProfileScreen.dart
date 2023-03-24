import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stums_app/models/Student.dart';
import 'package:stums_app/providers/user.dart';

class StudentProfileScreen extends StatefulWidget {
  static const String routeName = "/student-profile-screen";
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool isLoading = false;
  late StudentModel student;

  @override
  Widget build(BuildContext context) {
    student = Provider.of<User>(context, listen: false).getStudent;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
          ),
          body: Container(
            decoration: BoxDecoration(color: Colors.grey.shade200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 2,
                ),
                Container(
                  child: Column(
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
                      SizedBox(height: 7,),
                      Text(
                        student.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 224, 238, 245),
                      // border: Border.all(
                      //     color: const Color.fromARGB(255, 2, 48, 71),
                      //     width: 1),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            blurStyle: BlurStyle.normal)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Registration Number",
                          style: TextStyle(
                              color: Color.fromARGB(255, 2, 48, 71),
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          student.registrationNo,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 16,
                ),
                Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 224, 238, 245),
                      // border: Border.all(
                      //     color: const Color.fromARGB(255, 2, 48, 71),
                      //     width: 1),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            blurStyle: BlurStyle.normal)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Phone Number",
                          style: TextStyle(
                              color: Color.fromARGB(255, 2, 48, 71),
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          student.phoneNumber,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 16,
                ),
                Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 224, 238, 245),
                      // border: Border.all(
                      //     color: const Color.fromARGB(255, 2, 48, 71),
                      //     width: 1),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            blurStyle: BlurStyle.normal)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email Id",
                          style: TextStyle(
                              color: Color.fromARGB(255, 2, 48, 71),
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          student.emailId,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 16,
                ),
                Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 224, 238, 245),
                      // border: Border.all(
                      //     color: const Color.fromARGB(255, 2, 48, 71),
                      //     width: 1),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            blurStyle: BlurStyle.normal)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Date of Birth",
                          style: TextStyle(
                              color: Color.fromARGB(255, 2, 48, 71),
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          DateFormat.yMd().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(student.dob))),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )),
              ],
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
          )
      ],
    );
  }
}
