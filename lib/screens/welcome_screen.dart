import 'package:flutter/material.dart';
import 'package:psutep/constants.dart';
import 'package:psutep/screens/admin_screen.dart';
import 'package:psutep/screens/exam_screen.dart';
import 'package:psutep/screens/login_screen.dart';
import 'package:psutep/screens/rater_examinee_screen.dart';
import 'package:psutep/screens/test_record_screen.dart';
import 'package:psutep/services/app_service.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    AppService appService = await AppService.getInstance();
    await Future.delayed(const Duration(seconds: 1));
    if (!appService.isLogIn()) {
      appService.logout().then((value) {
        goLoginPage();
      });
      return;
    }
    if (appService.getRole() == "admin") {
      goAdminScreen();
      return;
    }

    if (appService.getRole() == "rater") {
      goRaterScreen();
      return;
    }
    if (appService.getRole() == "examinee") {
      goTestRecordScreen();
    }
  }

  void goLoginPage() {
    Navigator.of(context).pushNamed(LoginScreen.id);
  }

  void goAdminScreen() {
    Navigator.of(context).pushNamed(AdminScreen.id).then((value) {
      goLoginPage();
    });
  }

  void goRaterScreen() {
    Navigator.of(context).pushNamed(RaterExamineeScreen.id).then((value) {
      goLoginPage();
    });
  }

  void goTestRecordScreen() {
    Navigator.of(context).pushNamed(TestRecordScreen.id).then((value) {
      goLoginPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 2.0;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: kBackgroundGradiant),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Hero(
                    tag: 'Logo',
                    child: Image(
                      image: AssetImage('images/psu_logo.png'),
                    ),
                  ),
                  Text(
                    'PSU-TEP',
                    style: TextStyle(
                      fontSize: 56.0,
                      fontFamily: kDefaultFont,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Prince of Songkla University Test of English Proficiency',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: kDefaultFont,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
