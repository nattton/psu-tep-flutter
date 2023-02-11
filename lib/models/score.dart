import 'package:psutep/models/user.dart';

class Score {
  double answer1;
  double answer2;
  double answer3;
  User user;

  Score(
    this.answer1,
    this.answer2,
    this.answer3,
    this.user,
  );

  Score.fromJson(Map<String, dynamic> json)
      : answer1 = json['answer1'],
        answer2 = json['answer2'],
        answer3 = json['answer3'],
        user = User.fromJson(json['user']);
}
