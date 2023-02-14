// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html' as html;

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:psutep/models/exam.dart';
import 'package:psutep/models/examinee.dart';
import 'package:psutep/services/app_service.dart';

class RaterAnswerScreen extends StatefulWidget {
  static const String id = "rater_answer_screen";
  const RaterAnswerScreen(
      {super.key, required this.quiz, required this.examinee});

  final Task quiz;
  final Examinee examinee;
  @override
  State<RaterAnswerScreen> createState() => _RaterAnswerScreenState();
}

class _RaterAnswerScreenState extends State<RaterAnswerScreen> {
  late AppService appService;
  late VideoPlayerController _controller;
  final _audioPlayer = ap.AudioPlayer();
  bool canRateScore = false;
  int quizNumber = 1;
  final _score1Controller = TextEditingController();
  final _score2Controller = TextEditingController();
  final _score3Controller = TextEditingController();

  Task get quiz => widget.quiz;
  Examinee get examinee => widget.examinee;

  @override
  void initState() {
    super.initState();
    AppService.getInstance().then((value) {
      appService = value;
      setState(() {
        canRateScore = appService.getRole() == "rater";
      });
    });
    setUpVideo(quiz.task1);
  }

  void selectQuiz(int selectedQuiz) async {
    if (quizNumber == selectedQuiz) return;
    await _controller.pause();
    await _audioPlayer.pause();
    setState(() {
      quizNumber = selectedQuiz;
    });
    switch (selectedQuiz) {
      case 1:
        setUpVideo(quiz.task1);
        break;
      case 2:
        setUpVideo(quiz.task2);
        break;
      case 3:
        setUpVideo(quiz.task3);
        break;
      default:
    }
  }

  Future<void> playAudio() {
    switch (quizNumber) {
      case 1:
        return _audioPlayer.play(ap.UrlSource(examinee.answer1!));
      case 2:
        return _audioPlayer.play(ap.UrlSource(examinee.answer2!));
      case 3:
        return _audioPlayer.play(ap.UrlSource(examinee.answer3!));
      default:
    }
    return Future.error('invalid quizNumber');
  }

  Future<void> pause() => _audioPlayer.pause();

  Future<void> stop() => _audioPlayer.stop();

  void setUpVideo(String videoUrl) {
    _controller = VideoPlayerController.network(
      videoUrl,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.initialize();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    _score1Controller.dispose();
    _score2Controller.dispose();
    _score3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${examinee.code} : ${examinee.firstname} ${examinee.lastname}'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1024,
                ),
                child: Container(
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
                          onPlay: () => playAudio(),
                          onPause: () => pause(),
                        ),
                        _VideoAudioProgressIndicator(_controller, _audioPlayer,
                            allowScrubbing: true),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: QuizSelectButton(
                    title: 'Quiz 1',
                    selected: quizNumber == 1,
                    onPressed: () => selectQuiz(1),
                  )),
                  Expanded(
                      child: QuizSelectButton(
                    title: 'Quiz 2',
                    selected: quizNumber == 2,
                    onPressed: () => selectQuiz(2),
                  )),
                  Expanded(
                      child: QuizSelectButton(
                    title: 'Quiz 3',
                    selected: quizNumber == 3,
                    onPressed: () => selectQuiz(3),
                  )),
                ],
              ),
              Visibility(
                visible: canRateScore,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _score1Controller,
                          autofocus: false,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Score Quiz 1',
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _score2Controller,
                          autofocus: false,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Score Quiz 2',
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _score3Controller,
                          autofocus: false,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Score Quiz 3',
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Visibility(
                visible: canRateScore,
                child: ElevatedButton(
                    onPressed: () => onSubmitScore(),
                    child: const Text('Submit Score')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSubmitScore() {
    appService
        .rateScore(
            examinee.id,
            double.parse(_score1Controller.text),
            double.parse(_score2Controller.text),
            double.parse(_score3Controller.text))
        .then((value) {
      alertMessage('Save Score.');
    }).catchError((error) {
      alertMessage(error);
    });
  }

  void alertMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Info'),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }
}

class QuizSelectButton extends StatelessWidget {
  const QuizSelectButton({
    super.key,
    required this.title,
    required this.selected,
    required this.onPressed,
  });

  final String title;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: selected ? Colors.red : Colors.blue),
          child: Text(title)),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay(
      {Key? key,
      required this.controller,
      required this.onPlay,
      required this.onPause})
      : super(key: key);

  final VideoPlayerController controller;
  final VoidCallback onPlay;
  final VoidCallback onPause;

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
            if (controller.value.isPlaying) {
              controller.pause();
              onPause();
            } else {
              controller.play();
              onPlay();
            }
          },
        ),
      ],
    );
  }
}

/// A scrubber to control [VideoPlayerController]s
class _VideoAudioScrubber extends StatefulWidget {
  /// Create a [_VideoAudioScrubber] handler with the given [child].
  ///
  /// [controller] is the [VideoPlayerController] that will be controlled by
  /// this scrubber.
  const _VideoAudioScrubber({
    Key? key,
    required this.child,
    required this.controller,
    required this.audioPlayer,
  }) : super(key: key);

  /// The widget that will be displayed inside the gesture detector.
  final Widget child;

  /// The [VideoPlayerController] that will be controlled by this scrubber.
  final VideoPlayerController controller;

  final ap.AudioPlayer audioPlayer;

  @override
  State<_VideoAudioScrubber> createState() => _VideoAudioScrubberState();
}

class _VideoAudioScrubberState extends State<_VideoAudioScrubber> {
  bool _controllerWasPlaying = false;

  VideoPlayerController get controller => widget.controller;
  ap.AudioPlayer get audioPlayer => widget.audioPlayer;

  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      final RenderBox box = context.findRenderObject()! as RenderBox;
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = controller.value.duration * relative;
      controller.seekTo(position);
      audioPlayer.seek(position);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.child,
      onHorizontalDragStart: (DragStartDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        _controllerWasPlaying = controller.value.isPlaying;
        if (_controllerWasPlaying) {
          controller.pause();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_controllerWasPlaying &&
            controller.value.position != controller.value.duration) {
          controller.play();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
    );
  }
}

class _VideoAudioProgressIndicator extends StatefulWidget {
  /// Construct an instance that displays the play/buffering status of the video
  /// controlled by [controller].
  ///
  /// Defaults will be used for everything except [controller] if they're not
  /// provided. [allowScrubbing] defaults to false, and [padding] will default
  /// to `top: 5.0`.
  const _VideoAudioProgressIndicator(
    this.controller,
    this.audioPlayer, {
    Key? key,
    this.colors = const VideoProgressColors(),
    required this.allowScrubbing,
    this.padding = const EdgeInsets.only(top: 5.0),
  }) : super(key: key);

  /// The [VideoPlayerController] that actually associates a video with this
  /// widget.
  final VideoPlayerController controller;
  final ap.AudioPlayer audioPlayer;

  /// The default colors used throughout the indicator.
  ///
  /// See [VideoProgressColors] for default values.
  final VideoProgressColors colors;

  /// When true, the widget will detect touch input and try to seek the video
  /// accordingly. The widget ignores such input when false.
  ///
  /// Defaults to false.
  final bool allowScrubbing;

  /// This allows for visual padding around the progress indicator that can
  /// still detect gestures via [allowScrubbing].
  ///
  /// Defaults to `top: 5.0`.
  final EdgeInsets padding;

  @override
  State<_VideoAudioProgressIndicator> createState() =>
      _VideoAudioProgressIndicatorState();
}

class _VideoAudioProgressIndicatorState
    extends State<_VideoAudioProgressIndicator> {
  _VideoAudioProgressIndicatorState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  late VoidCallback listener;

  VideoPlayerController get controller => widget.controller;
  ap.AudioPlayer get audioPlayer => widget.audioPlayer;

  VideoProgressColors get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (controller.value.isInitialized) {
      final int duration = controller.value.duration.inMilliseconds;
      final int position = controller.value.position.inMilliseconds;

      // audioPlayer.seek(controller.value.duration);

      int maxBuffering = 0;
      for (final DurationRange range in controller.value.buffered) {
        final int end = range.end.inMilliseconds;
        if (end > maxBuffering) {
          maxBuffering = end;
        }
      }

      progressIndicator = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          LinearProgressIndicator(
            value: maxBuffering / duration,
            valueColor: AlwaysStoppedAnimation<Color>(colors.bufferedColor),
            backgroundColor: colors.backgroundColor,
          ),
          LinearProgressIndicator(
            value: position / duration,
            valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
            backgroundColor: Colors.transparent,
          ),
        ],
      );
    } else {
      progressIndicator = LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
        backgroundColor: colors.backgroundColor,
      );
    }
    final Widget paddedProgressIndicator = Padding(
      padding: widget.padding,
      child: progressIndicator,
    );
    if (widget.allowScrubbing) {
      return _VideoAudioScrubber(
        controller: controller,
        audioPlayer: audioPlayer,
        child: paddedProgressIndicator,
      );
    } else {
      return paddedProgressIndicator;
    }
  }
}
