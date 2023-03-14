import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stums_app/providers/user.dart';
import 'package:stums_app/screens/FacultyAddStudent.dart';
import 'package:stums_app/screens/FacultyFeePaymentScreen.dart';
import 'package:stums_app/screens/FacultyLeaveApplications.dart';
import 'package:stums_app/screens/FacultyLoginScreen.dart';
import "package:provider/provider.dart";
import 'package:stums_app/screens/FacultyMessBillScreen.dart';
import 'package:stums_app/screens/FacultyScreen.dart';
import 'package:stums_app/screens/FeePaymentScreen.dart';
import 'package:stums_app/screens/HomeScreen.dart';
import 'package:stums_app/screens/LeaveApplicationScreen.dart';
import 'package:stums_app/screens/LeaveApplications.dart';
import 'package:stums_app/screens/MessBillScreen.dart';
import 'package:stums_app/screens/StudentLoginScreen.dart';
import 'package:stums_app/screens/StudentProfileScreen.dart';
import 'package:stums_app/screens/StudentScreen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: User()),
      ],
      child: MaterialApp(
        title: 'MTrace',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromARGB(255, 0, 190, 184),
            // primary: const Color.fromARGB(255, 0, 190, 184),
          ),
        ),
        // home: const HomeScreen(),
        home: const HomeScreen(),
        routes: {
          FacultyLoginScreen.routeName: (ctx) => const FacultyLoginScreen(),
          StudentLoginScreen.routeName: (ctx) => const StudentLoginScreen(),
          StudentScreen.routeName: (ctx) => const StudentScreen(),
          LeaveApplicationScreen.routeName: (ctx) =>
              const LeaveApplicationScreen(),
          FeePaymentScreen.routeName: (ctx) => FeePaymentScreen(),
          MessBillScreen.routeName: (ctx) => MessBillScreen(),
          LeaveApplicartions.routeName: (ctx) => LeaveApplicartions(),
          StudentProfileScreen.routeName: (ctx) => StudentProfileScreen(),
          FacultyScreen.routeName: (ctx) => FacultyScreen(),
          FacultyLeaveApplications.routeName: (ctx) =>
              FacultyLeaveApplications(),
          FacultyAddStudent.routeName: (ctx) => FacultyAddStudent(),
          FacultyFeePaymentScreen.routeName: (ctx) => FacultyFeePaymentScreen(),
          FacultyMessBillScreen.routeName: (ctx) => FacultyMessBillScreen(),
        },
      ),
    );
  }
}
