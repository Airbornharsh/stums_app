import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stums_app/screens/FacultyLoginScreen.dart';
import 'package:stums_app/screens/StudentLoginScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    void onLoad() async {
      final prefs = await SharedPreferences.getInstance();
      // prefs.setString("hopl_backend_uri", "http://localhost:3000");
      prefs.setString("stums_backend_uri", "http://10.0.2.2:3000");
      // prefs.setString("shore_backend_uri", "https://shore.vercel.app");
    }

    onLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onload() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        String domainUri = prefs.get("shore_backend_uri") as String;
      } catch (e) {
        print(e);
      }
    }

    onload();

    return Scaffold(
      appBar: AppBar(title: const Text("Stums")),
      body: Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .popAndPushNamed(StudentLoginScreen.routeName);
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              blurStyle: BlurStyle.normal)
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    height: 250,
                    width: (MediaQuery.of(context).size.width) / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "lib/assets/student.png",
                          height: 190,
                          width: (MediaQuery.of(context).size.width - 80) / 2,
                        ),
                        const Text(
                          "Login as Student",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 190, 184)),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 60,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .popAndPushNamed(FacultyLoginScreen.routeName);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            blurStyle: BlurStyle.normal)
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  height: 250,
                  width: (MediaQuery.of(context).size.width) / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "lib/assets/teacher.png",
                        height: 190,
                        width: (MediaQuery.of(context).size.width - 80) / 2,
                      ),
                      const Text(
                        "Login as Faculty",
                        style:
                            TextStyle(color: Color.fromARGB(255, 0, 190, 184)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
