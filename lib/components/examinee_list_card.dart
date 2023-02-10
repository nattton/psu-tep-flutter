import 'package:flutter/material.dart';
import 'package:psutep/constants.dart';
import 'package:psutep/models/examinee.dart';

class ExamineeListCard extends StatelessWidget {
  const ExamineeListCard(
      {super.key, required this.examinee, required this.onTap});

  final Examinee examinee;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  examinee.firstname ?? '',
                  style: const TextStyle(
                      fontFamily: kDefaultFont,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  examinee.lastname ?? '',
                  style: const TextStyle(
                      fontFamily: kDefaultFont,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.edit),
            ],
          ),
        ),
      ),
    );
  }
}
