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
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Name",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 190, 184),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 2,
                ),
                Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 0, 190, 184),
                            width: 1)),
                    child: Text(
                      student.name,
                      overflow: TextOverflow.ellipsis,
                    )),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Phone Number",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 190, 184),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 2,
                ),
                Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 0, 190, 184),
                            width: 1)),
                    child: Text(
                      student.phoneNumber,
                      overflow: TextOverflow.ellipsis,
                    )),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Email Id",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 190, 184),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 2,
                ),
                Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 0, 190, 184),
                            width: 1)),
                    child: Text(
                      student.emailId,
                      overflow: TextOverflow.ellipsis,
                    )),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Date of Birth",
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 190, 184),
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 2,
                ),
                Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 0, 190, 184),
                            width: 1)),
                    child: Text(
                      DateFormat.yMd().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(student.dob))),
                      overflow: TextOverflow.ellipsis,
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
