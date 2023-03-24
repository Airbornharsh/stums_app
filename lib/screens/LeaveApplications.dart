import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stums_app/providers/user.dart';

class LeaveApplicartions extends StatefulWidget {
  static const String routeName = "/leave-applications";
  LeaveApplicartions({super.key});
  bool start = true;

  @override
  State<LeaveApplicartions> createState() => _LeaveApplicartionsState();
}

class _LeaveApplicartionsState extends State<LeaveApplicartions> {
  List<dynamic> studentLeaveApplications = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    studentLeaveApplications =
        Provider.of<User>(context).getStudentLeaveApplications;

    if (widget.start) {
      setState(() {
        isLoading = true;
      });
      Provider.of<User>(context, listen: false).leaveApplicationsList().then(
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
          appBar: AppBar(title: const Text("Leave Applications")),
          body: ListView.builder(
            itemCount: studentLeaveApplications.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        "${((int.parse(studentLeaveApplications[index]['to']) - int.parse(studentLeaveApplications[index]['from'])) / (1000 * 60 * 60 * 24)).floor()}"),
                    Text("Days")
                  ],
                ),
                title: Text(  
                  studentLeaveApplications[index]["subject"],
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                    "${DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(studentLeaveApplications[index]['from'])))} - ${DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(studentLeaveApplications[index]['to'])))}"),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Subject",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(studentLeaveApplications[index]["subject"]),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                          "Body",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(studentLeaveApplications[index]["description"]),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                          "Hostel Name",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(studentLeaveApplications[index]["hostel"]),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                          "Submission Date",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(DateFormat.MMMEd().format(
                            DateTime.fromMillisecondsSinceEpoch(int.parse(
                                studentLeaveApplications[index]
                                    ["submissionDate"])))),
                        const SizedBox(
                          height: 7,
                        ),
                      ],
                    ),
                  )
                ],
              );
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
