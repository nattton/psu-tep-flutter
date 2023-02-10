import 'package:flutter/material.dart';
import 'package:psutep/constants.dart';

class AdminQuizCard extends StatelessWidget {
  const AdminQuizCard(
      {super.key,
      required this.seq,
      required this.onTapPlay,
      required this.onTapUpload});

  final int seq;
  final VoidCallback onTapPlay;
  final VoidCallback onTapUpload;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Quiz $seq',
                style: const TextStyle(
                    fontFamily: kDefaultFont,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: onTapPlay,
                child: const Icon(
                  Icons.play_arrow,
                  size: 30.0,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: onTapUpload,
                child: const Icon(
                  Icons.upload_file,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
