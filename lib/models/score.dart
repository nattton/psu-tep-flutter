import 'package:psutep/models/user.dart';

class Score {
  double task1;
  double task2;
  double task3;
  User user;

  Score(
    this.task1,
    this.task2,
    this.task3,
    this.user,
  );

  Score.fromJson(Map<String, dynamic> json)
      : task1 = json['task1'],
        task2 = json['task2'],
        task3 = json['task3'],
        user = User.fromJson(json['user']);
}
