import 'package:flutter/material.dart';
import 'package:psutep/constants.dart';
import 'package:psutep/models/exam.dart';
import 'package:psutep/screens/admin_screen.dart';
import 'package:psutep/screens/exam_screen.dart';
import 'package:psutep/screens/examinee_quiz_screen.dart';
import 'package:psutep/screens/player_video_screen.dart';
import 'package:psutep/screens/test_record_screen.dart';
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
        TestRecordScreen.id: (context) => const TestRecordScreen(),
        ExamScreen.id: (context) => const ExamScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == PlayerVideoScreen.id) {
          final videoUrl = settings.arguments as String;
          return MaterialPageRoute(builder: (context) {
            return PlayerVideoScreen(videoUrl: videoUrl);
          });
        } else if (settings.name == ExamineeQuizScreen.id) {
          final quiz = settings.arguments as Quiz;
          return MaterialPageRoute(builder: (context) {
            return ExamineeQuizScreen(quiz: quiz);
          });
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
