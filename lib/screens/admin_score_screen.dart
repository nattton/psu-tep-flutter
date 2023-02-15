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
  late Task task;
  List<Examinee> examinees = [];

  @override
  void initState() {
    super.initState();
    AppService.getInstance().then((value) {
      appService = value;
      getTask();
      getExamineeByAdmin();
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
            return AdminScoreCard(
              examinee: examinee,
              onTap: () => onPressedDownloadAnswers(),
              onTapScore: () => onPressedDownloadReport(),
            );
          }
          return AdminScoreCard(
            examinee: examinees[index - 1],
            onTap: () => onPressedView(examinees[index - 1]),
            onTapScore: () {},
          );
        },
      ),
    );
  }

  Future<void> getTask() async {
    appService.fetchTask().then((value) {
      setState(() {
        task = value;
      });
    }).catchError((error) {});
  }

  Future<void> getExamineeByAdmin() async {
    appService.fetchExamineeByAdminList().then((value) {
      setState(() {
        examinees = value;
      });
    }).catchError((error) {});
  }

  void onPressedDownloadReport() {
    appService.downloadScoreExcel().then((value) {}).catchError((error) {});
  }

  void onPressedDownloadAnswers() {
    appService.downloadAnswersAudio().then((value) {}).catchError((error) {});
  }

  void onPressedView(Examinee examinee) async {
    await Navigator.of(context).pushNamed(RaterAnswerScreen.id,
        arguments: {"task": task, 'examinee': examinee});
    getExamineeByAdmin();
  }
}
