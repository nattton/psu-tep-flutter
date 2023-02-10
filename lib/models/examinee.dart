class Examinee {
  int? id;
  String? code;
  String? firstname;
  String? lastname;
  String? answer1;
  String? answer2;
  String? answer3;
  bool? finish;

  Examinee({this.id,
    this.code,
    this.firstname,
    this.lastname,
    this.answer1,
    this.answer2,
    this.answer3,
    this.finish});

  Examinee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    answer1 = json['answer1'];
    answer2 = json['answer2'];
    answer3 = json['answer3'];
    finish = json['finish'];
  }

}
