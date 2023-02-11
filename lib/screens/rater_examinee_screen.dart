// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:psutep/components/rater_examinee_card.dart';
import 'package:psutep/models/exam.dart';
import 'package:psutep/models/examinee.dart';
import 'package:psutep/screens/rater_answer_screen.dart';
import 'package:psutep/services/app_service.dart';

class RaterExamineeScreen extends StatefulWidget {
  static const String id = 'rater_examinee_screen';
  const RaterExamineeScreen({super.key});

  @override
  State<RaterExamineeScreen> createState() => _RaterExamineeScreenState();
}

class _RaterExamineeScreenState extends State<RaterExamineeScreen> {
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
      appBar: AppBar(
        title: const Text('PSU-TEP Rater'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                appService.logout().then((value) {
                  html.window.location.href = "/";
                });
              },
              child: const Icon(
                Icons.exit_to_app,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: examinees.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            var examinee = Examinee(0, []);
            return RaterExamineeCard(examinee: examinee, onTap: () {});
          }
          return RaterExamineeCard(
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
    appService.fetchExamineeByRaterList().then((value) {
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
