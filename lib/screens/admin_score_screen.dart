// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:psutep/components/admin_score_card.dart';
import 'package:psutep/models/exam.dart';
import 'package:psutep/models/examinee.dart';
import 'package:psutep/screens/rater_answer_screen.dart';
import 'package:psutep/services/app_service.dart';

class AdminScoreScreen extends StatefulWidget {
  static const String id = 'admin_score_screen';
  const AdminScoreScreen({super.key});

  @override
  State<AdminScoreScreen> createState() => _AdminScoreScreenState();
}

class _AdminScoreScreenState extends State<AdminScoreScreen> {
  late AppService appService;
  late Quiz quiz;
  List<Examinee> examinees = [];

  @override
  void initState() {
    super.initState();
    AppService.getInstance().then((value) {
      appService = value;
      getQuiz();
      getExamineeByRater();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: examinees.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            var examinee = Examinee(0, []);
            return AdminScoreCard(examinee: examinee, onTap: () {});
          }
          return AdminScoreCard(
              examinee: examinees[index - 1],
              onTap: () => onPressedView(examinees[index - 1]));
        },
      ),
    );
  }

  Future<void> getQuiz() async {
    appService.fetchQuiz().then((value) {
      setState(() {
        quiz = value;
      });
    }).catchError((error) {});
  }

  Future<void> getExamineeByRater() async {
    appService.fetchExamineeByAdminList().then((value) {
      setState(() {
        examinees = value;
      });
    }).catchError((error) {});
  }

  void onPressedView(Examinee examinee) async {
    await Navigator.of(context).pushNamed(RaterAnswerScreen.id,
        arguments: {"quiz": quiz, 'examinee': examinee});
    getExamineeByRater();
  }
}
