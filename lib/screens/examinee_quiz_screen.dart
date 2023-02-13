// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:psutep/constants.dart';
import 'package:psutep/models/exam.dart';
import 'package:psutep/services/app_service.dart';
import 'package:record/record.dart';
import 'package:video_player/video_player.dart';

class ExamineeQuizScreen extends StatefulWidget {
  static const String id = "ExamineeQuizScreen";
  const ExamineeQuizScreen({super.key, required this.quiz});

  final Quiz quiz;
  @override
  State<ExamineeQuizScreen> createState() => _ExamineeQuizScreenState();
}

class _ExamineeQuizScreenState extends State<ExamineeQuizScreen> {
  late AppService appService;
  late VideoPlayerController _controller;
  final _audioRecorder = Record();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  bool startedPlaying = false;
  int quizNumber = 1;

  @override
  void initState() {
    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });
    super.initState();
    AppService.getInstance().then((value) => appService = value);
    setUpVideo(widget.quiz.quiz1);
  }

  void setUpVideo(String videoUrl) {
    _controller = VideoPlayerController.network(
      videoUrl,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
      if (!_controller.value.isPlaying && _recordState == RecordState.record) {
        stopRecord();
      }
    });

    _controller.initialize();
  }

  @override
  void dispose() {
    _recordSub?.cancel();
    _controller.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz $quizNumber'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_controller),
                    ClosedCaption(text: _controller.value.caption.text),
                    _ControlsOverlay(
                      controller: _controller,
                      onPlay: () => startRecord(),
                    ),
                    VideoProgressIndicator(_controller, allowScrubbing: true),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _recordState == RecordState.record,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(Icons.mic),
                  SizedBox(width: 20),
                  Text(
                    'Microphone is recording...',
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: kDefaultFont,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void startRecord() async {
    await _audioRecorder.start();
  }

  void stopRecord() async {
    final path = await _audioRecorder.stop();
    appService.sendAnswer(quizNumber, path!).then((value) {
      setState(() {
        quizNumber++;
        if (quizNumber == 2) {
          setUpVideo(widget.quiz.quiz2);
        } else if (quizNumber == 3) {
          setUpVideo(widget.quiz.quiz3);
        } else if (quizNumber == 4) {
          appService.logout().then((value) {
            alertMessage();
          });
        }
      });
    });
  }

  void alertMessage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Info'),
            content: const Text('Test Finish'),
            actions: [
              TextButton(
                  onPressed: () {
                    html.window.location.href = "/";
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay(
      {Key? key, required this.controller, required this.onPlay})
      : super(key: key);

  final VideoPlayerController controller;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            if (!controller.value.isPlaying) {
              controller.play();
              onPlay();
            }
          },
        ),
      ],
    );
  }
}
