class Score {
  double answer1;
  double answer2;
  double answer3;

  Score(
    this.answer1,
    this.answer2,
    this.answer3,
  );

  Score.fromJson(Map<String, dynamic> json)
      : answer1 = json['answer1'],
        answer2 = json['answer2'],
        answer3 = json['answer3'];
}
