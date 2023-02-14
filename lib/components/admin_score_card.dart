import 'package:flutter/material.dart';
import 'package:psutep/constants.dart';
import 'package:psutep/models/examinee.dart';
import 'package:psutep/models/score.dart';

class AdminScoreCard extends StatelessWidget {
  const AdminScoreCard(
      {super.key,
      required this.examinee,
      required this.onTap,
      required this.onTapScore});

  final Examinee examinee;
  final VoidCallback onTap;
  final VoidCallback onTapScore;

  @override
  Widget build(BuildContext context) {
    return examinee.id == 0
        ? Card(
            color: Colors.red.shade100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Code',
                      style: TextStyle(
                          fontFamily: kDefaultFont,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Firstname',
                      style: TextStyle(
                          fontFamily: kDefaultFont,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Lastname',
                      style: TextStyle(
                          fontFamily: kDefaultFont,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                                text: 'Score ',
                                style: TextStyle(
                                    fontFamily: kDefaultFont,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            WidgetSpan(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: GestureDetector(
                                  onTap: onTapScore,
                                  child: const Icon(
                                    Icons.table_view,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Icon(Icons.audio_file, color: Colors.green),
                  ),
                ],
              ),
            ),
          )
        : Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      examinee.code ?? '',
                      style: const TextStyle(
                        fontFamily: kDefaultFont,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      examinee.firstname ?? '',
                      style: const TextStyle(
                        fontFamily: kDefaultFont,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      examinee.lastname ?? '',
                      style: const TextStyle(
                        fontFamily: kDefaultFont,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: examinee.scores.length,
                      itemBuilder: (context, index) {
                        Score score = examinee.scores[index];
                        return ListTile(
                          title: Text(
                              '${score.user.name} : ${score.task1} / ${score.task2}  / ${score.task1}'),
                        );
                      },
                    ),
                  ),
                  examinee.answer1 == "" ||
                          examinee.answer2 == "" ||
                          examinee.answer3 == ""
                      ? const Icon(
                          Icons.play_disabled,
                          color: Colors.red,
                        )
                      : GestureDetector(
                          onTap: onTap,
                          child:
                              const Icon(Icons.play_arrow, color: Colors.green),
                        ),
                ],
              ),
            ),
          );
  }
}
