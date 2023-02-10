class Quiz {
  String quiz1;
  String quiz2;
  String quiz3;

  Quiz(
    this.quiz1,
    this.quiz2,
    this.quiz3,
  );

  Quiz.fromJson(Map<String, dynamic> json)
      : quiz1 = json['quiz1'],
        quiz2 = json['quiz2'],
        quiz3 = json['quiz3'];
}
