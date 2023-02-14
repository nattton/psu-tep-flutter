import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:psutep/components/admin_task_card.dart';
import 'package:psutep/models/exam.dart';
import 'package:psutep/screens/player_video_screen.dart';
import 'package:psutep/services/app_service.dart';

class AdminTaskScreen extends StatefulWidget {
  const AdminTaskScreen({super.key});

  @override
  State<AdminTaskScreen> createState() => _AdminTaskScreenState();
}

class _AdminTaskScreenState extends State<AdminTaskScreen> {
  late AppService appService;
  Task task = Task("", "", "", "");

  @override
  void initState() {
    super.initState();
    AppService.getInstance().then((value) {
      appService = value;
      getTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdminTaskCard(
            title: 'Instruction',
            enabled: task.task0.isNotEmpty,
            onTapPlay: () => onPlayVideo(task.task0),
            onTapUpload: () => onUploadVideo(0)),
        AdminTaskCard(
            title: 'Task 1',
            enabled: task.task1.isNotEmpty,
            onTapPlay: () => onPlayVideo(task.task1),
            onTapUpload: () => onUploadVideo(1)),
        AdminTaskCard(
            title: 'Task 2',
            enabled: task.task2.isNotEmpty,
            onTapPlay: () => onPlayVideo(task.task2),
            onTapUpload: () => onUploadVideo(2)),
        AdminTaskCard(
            title: 'Task 3',
            enabled: task.task3.isNotEmpty,
            onTapPlay: () => onPlayVideo(task.task3),
            onTapUpload: () => onUploadVideo(3)),
      ],
    );
  }

  void getTask() async {
    appService.fetchTask().then((value) {
      setState(() {
        task = value;
      });
    }).catchError((error) {});
  }

  void onPlayVideo(String videoUrl) {
    if (videoUrl.isNotEmpty) {
      Navigator.of(context)
          .pushNamed(PlayerVideoScreen.id, arguments: videoUrl);
    }
  }

  void onUploadVideo(int seq) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );

    if (result != null) {
      appService.uploadTask(seq, result.files.first.bytes!).then((value) {
        alertMessage('Save task succeed.');
        getTask();
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
