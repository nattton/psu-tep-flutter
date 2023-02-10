import 'package:flutter/material.dart';
import 'package:psutep/constants.dart';
import 'package:psutep/models/user.dart';

class UserListCard extends StatelessWidget {
  const UserListCard({super.key, required this.user, required this.onTap});

  final User user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: user.id == 0
          ? Card(
              color: Colors.red.shade100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.name,
                        style: const TextStyle(
                            fontFamily: kDefaultFont,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        user.role,
                        style: const TextStyle(
                          fontFamily: kDefaultFont,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 30.0),
                  ],
                ),
              ),
            )
          : Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          fontFamily: kDefaultFont,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        user.role,
                        style: const TextStyle(
                          fontFamily: kDefaultFont,
                          fontSize: 16.0,
                        ),
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
