import 'package:flutter/material.dart';
import 'package:psutep/constants.dart';
import 'package:psutep/models/examinee.dart';

class RaterExamineeCard extends StatelessWidget {
  const RaterExamineeCard(
      {super.key, required this.examinee, required this.onTap});

  final Examinee examinee;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return examinee.id == 0
        ? Card(
            color: Colors.red.shade100,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
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
                    child: Text(
                      'Score',
                      style: TextStyle(
                          fontFamily: kDefaultFont,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 30.0),
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
                    child: Text(
                      examinee.scores.isEmpty
                          ? ''
                          : '${examinee.scores[0].task1} / ${examinee.scores[0].task2} / ${examinee.scores[0].task3}',
                      style: const TextStyle(
                        fontFamily: kDefaultFont,
                        fontSize: 16.0,
                      ),
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
