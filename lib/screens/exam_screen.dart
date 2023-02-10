import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:psutep/components/audio_player.dart';
import 'package:psutep/components/audio_recorder.dart';
import 'package:psutep/services/app_service.dart';

class ExamScreen extends StatefulWidget {
  static const String id = 'exam_screen';

  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: showPlayer
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: AudioPlayer(
                  source: audioPath!,
                  onDelete: () {
                    setState(() => showPlayer = false);
                  },
                ),
              )
            : AudioRecorder(
                onStop: (path) async {
                  AppService appService = await AppService.getInstance();
                  await appService.sendAnswer(1, path);

                  if (kDebugMode) print('Recorded file path: $path');
                  setState(() {
                    audioPath = path;
                    showPlayer = true;
                  });
                },
              ),
      ),
    );
  }
}
