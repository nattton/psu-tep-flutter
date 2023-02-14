import 'package:flutter/material.dart';
import 'package:psutep/constants.dart';
import 'package:psutep/models/examinee.dart';

class AdminExamineeCard extends StatelessWidget {
  const AdminExamineeCard(
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
                      'Test Taker ID',
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
                  SizedBox(
                    width: 24.0,
                  )
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
                  GestureDetector(
                    onTap: onTap,
                    child: const Icon(Icons.edit_note),
                  ),
                ],
              ),
            ),
          );
  }
}
