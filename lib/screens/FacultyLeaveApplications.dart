import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stums_app/providers/user.dart';

class FacultyLeaveApplications extends StatefulWidget {
  static const String routeName = "/faculty-leave-applications";
  FacultyLeaveApplications({super.key});
  bool start = true;

  @override
  State<FacultyLeaveApplications> createState() =>
      _FacultyLeaveApplicationsState();
}

class _FacultyLeaveApplicationsState extends State<FacultyLeaveApplications> {
  List<dynamic> facultyLeaveApplications = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    facultyLeaveApplications =
        Provider.of<User>(context).getFacultyLeaveApplications;

    if (widget.start) {
      setState(() {
        isLoading = true;
      });
      Provider.of<User>(context, listen: false)
          .facultyLeaveApplicationsList()
          .then(
        (value) {
          setState(() {
            isLoading = false;
          });
        },
      ).catchError((e) {
        setState(() {
          isLoading = false;
        });
      });
      setState(() {
        widget.start = false;
      });
    }

    print(facultyLeaveApplications.length);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Leave Applications")),
          body: ListView.builder(
            itemCount: facultyLeaveApplications.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        "${((int.parse(facultyLeaveApplications[index]['leaveApplication']['to']) - int.parse(facultyLeaveApplications[index]['leaveApplication']['from'])) / (1000 * 60 * 60 * 24)).floor()}"),
                    Text("Days")
                  ],
                ),
                title: Text(
                  facultyLeaveApplications[index]["userData"]["name"],
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                    "${DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(facultyLeaveApplications[index]["leaveApplication"]['from'])))} - ${DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(facultyLeaveApplications[index]["leaveApplication"]['to'])))}"),
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
                        Text(facultyLeaveApplications[index]["leaveApplication"]
                            ["subject"]),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                          "Body",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(facultyLeaveApplications[index]["leaveApplication"]
                            ["description"]),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                          "Hostel Name",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(facultyLeaveApplications[index]["leaveApplication"]
                            ["hostel"]),
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
                                facultyLeaveApplications[index]
                                    ["leaveApplication"]["submissionDate"])))),
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
