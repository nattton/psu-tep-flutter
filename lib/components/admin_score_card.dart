import 'package:flutter/material.dart';
import 'package:psutep/constants.dart';
import 'package:psutep/models/examinee.dart';
import 'package:psutep/models/score.dart';

class AdminScoreCard extends StatelessWidget {
  const AdminScoreCard(
      {super.key, required this.examinee, required this.onTap});

  final Examinee examinee;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return examinee.id == 0
        ? Card(
            color: Colors.red.shade100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  Expanded(
                    child: Text(
                      'Code',
                      style: TextStyle(
                          fontFamily: kDefaultFont,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Firstname',
                      style: TextStyle(
                          fontFamily: kDefaultFont,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
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
                    child: Text(
                      'Score',
                      style: TextStyle(
                          fontFamily: kDefaultFont,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 20.0),
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
                              '${score.user.name} : ${score.answer1} / ${score.answer2}  / ${score.answer1}'),
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
