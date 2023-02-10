import 'package:flutter/material.dart';
import 'package:psutep/constants.dart';
import 'package:psutep/screens/admin_screen.dart';
import 'package:psutep/screens/exam_screen.dart';
import 'package:psutep/screens/welcome_screen.dart';
import 'login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PSU-TEP',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: kDefaultFont,
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        AdminScreen.id: (context) => const AdminScreen(),
        ExamScreen.id: (context) => const ExamScreen(),
      },
      onGenerateRoute: (settings) {
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
