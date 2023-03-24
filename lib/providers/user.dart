import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stums_app/models/Faculty.dart';
import 'package:stums_app/models/FeePayment.dart';
import 'package:stums_app/models/Student.dart';

class User with ChangeNotifier {
  String _isUser = "";
  String _accessToken = "";
  bool _isAuth = false;
  FacultyModel _facultyUser = FacultyModel(
      id: "",
      institute: "",
      phoneNumber: "",
      emailId: "",
      students: [],
      leaveApplications: [],
      feePayments: [],
      messBills: []);
  StudentModel _studentUser = StudentModel(
      id: "",
      institute: "",
      name: "",
      phoneNumber: "",
      registrationNo: "",
      emailId: "",
      dob: "",
      leaveApplications: [],
      feePayments: {},
      messBills: {});

  List<dynamic> studentFeePayments = [];
  List<dynamic> studentMessBills = [];
  List<dynamic> studentLeaveApplications = [];

  List<dynamic> facultyFeePayments = [];
  List<dynamic> facultyMessBills = [];
  List<dynamic> facultyLeaveApplications = [];

  String get getIsUser {
    return _isUser;
  }

  bool isStudentLoggedIn() {
    return _isUser == "student" && _isAuth;
  }

  bool isFacultyLoggedIn() {
    return _isUser == "faculty" && _isAuth;
  }

  FacultyModel get getFaculty {
    return _facultyUser;
  }

  StudentModel get getStudent {
    return _studentUser;
  }

  List<dynamic> get getStudentFeePayments {
    return studentFeePayments;
  }

  List<dynamic> get getStudentMessBills {
    return studentMessBills;
  }

  List<dynamic> get getStudentLeaveApplications {
    return studentLeaveApplications;
  }

  List<dynamic> get getFacultyFeePayments {
    return facultyFeePayments;
  }

  List<dynamic> get getFacultyMessBills {
    return facultyMessBills;
  }

  List<dynamic> get getFacultyLeaveApplications {
    return facultyLeaveApplications;
  }

  void logOut() async {
    _accessToken = "";
    _isAuth = false;
    _isUser = "";
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("stums_accessToken");
    _studentUser = StudentModel(
        id: "",
        institute: "",
        name: "",
        phoneNumber: "",
        registrationNo: "",
        emailId: "",
        dob: "",
        leaveApplications: [],
        feePayments: {},
        messBills: {});
  }

  Future<String> facultyLogin(String institute, String password) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;

    try {
      var tokenRes = await client.post(
          Uri.parse("$domainUri/api/faculty/login"),
          body: json.encode({"institute": institute, "password": password}),
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "*",
          });

      if (tokenRes.statusCode != 200) {
        throw tokenRes.body;
      }

      var parsedBody = json.decode(tokenRes.body);
      prefs.setString("stums_accessToken", parsedBody["accessToken"]);
      _accessToken = parsedBody["accessToken"];
      _isAuth = true;
      var userRes = await client.get(Uri.parse("$domainUri/api/faculty/get"),
          headers: {"authorization": "stums $_accessToken"});

      if (userRes.statusCode != 200) {
        return json.decode(userRes.body)["message"];
      }

      var parsedUserBody = json.decode(userRes.body);

      _facultyUser = FacultyModel(
          id: parsedUserBody["_id"].toString(),
          emailId: parsedUserBody["emailId"].toString(),
          phoneNumber: parsedUserBody["phoneNumber"].toString(),
          institute: parsedUserBody["institute"].toString(),
          students: List<String>.from(parsedUserBody["students"]),
          leaveApplications:
              List<String>.from(parsedUserBody["leaveApplications"]),
          feePayments: List<String>.from(parsedUserBody["feePayments"]),
          messBills: List<String>.from(parsedUserBody["messBills"]));

      _isAuth = true;

      _isUser = "faculty";

      return "Done";
    } catch (e) {
      return "Error";
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<String> studentLogin(String registrationNo, String password) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;

    try {
      var tokenRes = await client.post(
          Uri.parse("$domainUri/api/student/login"),
          body: json
              .encode({"registrationNo": registrationNo, "password": password}),
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "*",
          });

      if (tokenRes.statusCode != 200) {
        throw tokenRes.body;
      }

      var parsedBody = json.decode(tokenRes.body);
      prefs.setString("stums_accessToken", parsedBody["accessToken"]);
      _accessToken = parsedBody["accessToken"];
      _isAuth = true;
      var userRes = await client.get(Uri.parse("$domainUri/api/student/get"),
          headers: {
            "authorization": "stums $_accessToken",
            "Content-Type": "application/json"
          });

      if (userRes.statusCode != 200) {
        return json.decode(userRes.body)["message"];
      }

      var parsedUserBody = json.decode(userRes.body);

      _studentUser = StudentModel(
          id: parsedUserBody["_id"].toString(),
          name: parsedUserBody["name"].toString(),
          dob: parsedUserBody["dob"].toString(),
          emailId: parsedUserBody["emailId"].toString(),
          phoneNumber: parsedUserBody["phoneNumber"].toString(),
          registrationNo: parsedUserBody["registrationNo"].toString(),
          institute: parsedUserBody["institute"].toString(),
          leaveApplications:
              List<String>.from(parsedUserBody["leaveApplications"]),
          feePayments: Map<String, dynamic>.from(parsedUserBody["feePayments"]),
          messBills: Map<String, dynamic>.from(parsedUserBody["messBills"]));

      _isAuth = true;
      _isUser = "student";

      return "Done";
    } catch (e) {
      print(e);
      return "Error";
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<String> addLeaveApplication(
      {required String subject,
      required String description,
      required String fromDate,
      required String toDate,
      required String hostel}) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;

    try {
      var res = await client
          .post(Uri.parse("$domainUri/api/student/leave-application/create"),
              body: json.encode({
                "subject": subject,
                "description": description,
                "from": fromDate,
                "to": toDate,
                "hostel": hostel
              }),
              headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "*",
            "authorization": "stums $_accessToken"
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      return "Done";
    } catch (e) {
      return "Error";
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> studentFeePaymentList() async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;
    String? accessToken = prefs.getString("stums_accessToken");
    try {
      var res = await client
          .post(Uri.parse("$domainUri/api/student/fee-payment/list"), headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        "Access-Control-Allow-Methods": "*",
        "authorization": "stums $accessToken"
      });

      if (res.statusCode != 200) {
        throw res.body;
      }

      var parsedBody = json.decode(res.body);

      studentFeePayments.clear();

      studentFeePayments.addAll(parsedBody);

      return true;
    } catch (e) {
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> studentMessBillList() async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;
    String? accessToken = prefs.getString("stums_accessToken");
    try {
      var res = await client
          .post(Uri.parse("$domainUri/api/student/mess-bill/list"), headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        "Access-Control-Allow-Methods": "*",
        "authorization": "stums $accessToken"
      });

      if (res.statusCode != 200) {
        throw res.body;
      }

      var parsedBody = json.decode(res.body);

      studentMessBills.clear();

      studentMessBills.addAll(parsedBody);

      return true;
    } catch (e) {
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<String> createFeePaymentOrder(
      {required int amount,
      required String currency,
      required String year}) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;
    String? accessToken = prefs.getString("stums_accessToken");
    try {
      var res =
          await client.post(Uri.parse("$domainUri/api/student/fee-payment"),
              body: json.encode({
                "amount": amount,
                "currency": currency,
                "year": year,
              }),
              headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "*",
            "authorization": "stums $accessToken"
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      var parsedBody = json.decode(res.body);

      print(parsedBody);

      return parsedBody["orderId"];
    } catch (e) {
      return "";
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> verifyFeePaymentOrder({
    required String razorpaySignature,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String year,
  }) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;
    String? accessToken = prefs.getString("stums_accessToken");
    try {
      var res = await client
          .post(Uri.parse("$domainUri/api/student/fee-payment/verify"),
              body: json.encode({
                "razorpaySignature": razorpaySignature,
                "razorpayPaymentId": razorpayPaymentId,
                "razorpayOrderId": razorpayOrderId,
                "year": year,
              }),
              headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "*",
            "authorization": "stums $accessToken"
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      var parsedBody = json.decode(res.body);

      return parsedBody["isVerified"];
    } catch (e) {
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<String> createMessBillOrder(
      {required int amount,
      required String currency,
      required String semester,
      required String hostel,
      required int roomNo}) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;
    String? accessToken = prefs.getString("stums_accessToken");
    try {
      var res = await client.post(Uri.parse("$domainUri/api/student/mess-bill"),
          body: json.encode({
            "amount": amount,
            "currency": currency,
            "semester": semester,
            "hostel": hostel,
            "roomNo": roomNo,
          }),
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "*",
            "authorization": "stums $accessToken"
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      var parsedBody = json.decode(res.body);

      print(parsedBody);

      return parsedBody["orderId"];
    } catch (e) {
      return "";
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> verifyMessBillOrder({
    required String razorpaySignature,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String semester,
  }) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;
    String? accessToken = prefs.getString("stums_accessToken");
    try {
      var res = await client
          .post(Uri.parse("$domainUri/api/student/mess-bill/verify"),
              body: json.encode({
                "razorpaySignature": razorpaySignature,
                "razorpayPaymentId": razorpayPaymentId,
                "razorpayOrderId": razorpayOrderId,
                "semester": semester,
              }),
              headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "*",
            "authorization": "stums $accessToken"
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      var parsedBody = json.decode(res.body);

      return parsedBody["isVerified"];
    } catch (e) {
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> leaveApplicationsList() async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;
    String? accessToken = prefs.getString("stums_accessToken");
    try {
      var res = await client.post(
          Uri.parse("$domainUri/api/student/leave-application/list"),
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "*",
            "authorization": "stums $accessToken"
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      var parsedBody = json.decode(res.body);

      studentLeaveApplications.clear();

      studentLeaveApplications.addAll(parsedBody);

      return true;
    } catch (e) {
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> facultyLeaveApplicationsList() async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;
    String? accessToken = prefs.getString("stums_accessToken");
    try {
      var res = await client.post(
          Uri.parse("$domainUri/api/faculty/leave-application/list"),
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "*",
            "authorization": "stums $accessToken"
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      var parsedBody = json.decode(res.body);

      facultyLeaveApplications.clear();

      facultyLeaveApplications.addAll(parsedBody);

      return true;
    } catch (e) {
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> facultyFeePaymentsList() async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;
    String? accessToken = prefs.getString("stums_accessToken");
    try {
      print("ok");
      var res = await client
          .post(Uri.parse("$domainUri/api/faculty/fee-payment/list"), headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        "Access-Control-Allow-Methods": "*",
        "authorization": "stums $accessToken"
      });

      if (res.statusCode != 200) {
        throw res.body;
      }

      var parsedBody = json.decode(res.body);

      facultyFeePayments.clear();

      facultyFeePayments.addAll(parsedBody);

      return true;
    } catch (e) {
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> facultyMessBillList() async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;
    String? accessToken = prefs.getString("stums_accessToken");
    try {
      var res = await client
          .post(Uri.parse("$domainUri/api/faculty/mess-bill/list"), headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        "Access-Control-Allow-Methods": "*",
        "authorization": "stums $accessToken"
      });

      if (res.statusCode != 200) {
        throw res.body;
      }

      var parsedBody = json.decode(res.body);

      facultyMessBills.clear();

      facultyMessBills.addAll(parsedBody);

      return true;
    } catch (e) {
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> facultyCreateStudent(
      {required String name,
      required String password,
      required String phoneNumber,
      required String registrationNo,
      required String emailId,
      required String dob}) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.getString("stums_backend_uri") as String;
    String? accessToken = prefs.getString("stums_accessToken");

    try {
      var res =
          await client.post(Uri.parse("$domainUri/api/faculty/student/create"),
              body: json.encode({
                "name": name,
                "password": password,
                "phoneNumber": phoneNumber,
                "registrationNo": registrationNo,
                "emailId": emailId,
                "dob": dob,
              }),
              headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "*",
            "authorization": "stums $accessToken"
          });

      if (res.statusCode != 200) {
        throw res.body;
      }

      var parsedBody = json.decode(res.body);

      return true;
    } catch (e) {
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }
}
