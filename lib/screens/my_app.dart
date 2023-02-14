import 'package:flutter/material.dart';
import 'package:psutep/constants.dart';
import 'package:psutep/models/exam.dart';
import 'package:psutep/screens/admin_screen.dart';
import 'package:psutep/screens/exam_screen.dart';
import 'package:psutep/screens/examinee_task_screen.dart';
import 'package:psutep/screens/player_video_screen.dart';
import 'package:psutep/screens/rater_answer_screen.dart';
import 'package:psutep/screens/rater_examinee_screen.dart';
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
        RaterExamineeScreen.id: (context) => const RaterExamineeScreen(),
        TestRecordScreen.id: (context) => const TestRecordScreen(),
        ExamScreen.id: (context) => const ExamScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case PlayerVideoScreen.id:
            final videoUrl = settings.arguments as String;
            return MaterialPageRoute(builder: (context) {
              return PlayerVideoScreen(videoUrl: videoUrl);
            });

          case ExamineeTaskScreen.id:
            final quiz = settings.arguments as Task;
            return MaterialPageRoute(builder: (context) {
              return ExamineeTaskScreen(quiz: quiz);
            });
          case RaterAnswerScreen.id:
            final map = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (context) {
              return RaterAnswerScreen(
                  quiz: map["quiz"], examinee: map["examinee"]);
            });
          default:
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
