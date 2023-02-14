import 'package:flutter/material.dart';
import 'package:psutep/constants.dart';

class AdminTaskCard extends StatelessWidget {
  const AdminTaskCard(
      {super.key,
      required this.title,
      required this.enabled,
      required this.onTapPlay,
      required this.onTapUpload});

  final String title;
  final bool enabled;
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
                title,
                style: const TextStyle(
                    fontFamily: kDefaultFont,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: onTapPlay,
                child: enabled
                    ? const Icon(
                        Icons.play_arrow,
                        size: 30.0,
                      )
                    : const Icon(
                        Icons.play_disabled,
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
