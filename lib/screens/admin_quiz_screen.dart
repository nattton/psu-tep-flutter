import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:psutep/components/admin_quiz_card.dart';
import 'package:psutep/models/exam.dart';
import 'package:psutep/screens/player_video_screen.dart';
import 'package:psutep/services/app_service.dart';

class AdminQuizScreen extends StatefulWidget {
  const AdminQuizScreen({super.key});

  @override
  State<AdminQuizScreen> createState() => _AdminQuizScreenState();
}

class _AdminQuizScreenState extends State<AdminQuizScreen> {
  late AppService appService;
  Quiz quiz = Quiz("", "", "");

  @override
  void initState() {
    super.initState();
    AppService.getInstance().then((value) {
      appService = value;
      getQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdminQuizCard(
            seq: 1,
            onTapPlay: () => onPlayVideo(quiz.quiz1),
            onTapUpload: () => onEditVideo(1)),
        AdminQuizCard(
            seq: 2,
            onTapPlay: () => onPlayVideo(quiz.quiz2),
            onTapUpload: () => onEditVideo(2)),
        AdminQuizCard(
            seq: 3,
            onTapPlay: () => onPlayVideo(quiz.quiz3),
            onTapUpload: () => onEditVideo(3)),
      ],
    );
  }

  Future<void> getQuiz() async {
    appService.fetchQuiz().then((value) {
      quiz = value;
    }).catchError((error) {});
  }

  void onPlayVideo(String videoUrl) {
    Navigator.of(context).pushNamed(PlayerVideoScreen.id, arguments: videoUrl);
  }

  void onEditVideo(int seq) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );

    if (result != null) {
      appService.saveQuiz(seq, result.files.first.bytes!).then((value) {
        alertMessage('Save quiz succeed.');
        getQuiz();
      }).catchError((error) {
        alertMessage(error);
      });
    } else {
      // User canceled the picker
    }
  }

  void alertMessage(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Info'),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }
}
