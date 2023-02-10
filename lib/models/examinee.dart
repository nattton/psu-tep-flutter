class Examinee {
  int id = 0;
  String? code;
  String? firstname;
  String? lastname;
  String? answer1;
  String? answer2;
  String? answer3;
  bool? finish;

  Examinee(
    this.id, {
    this.code,
    this.firstname,
    this.lastname,
    this.answer1,
    this.answer2,
    this.answer3,
    this.finish,
  });

  Examinee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    answer1 = json['answer1'] ?? '';
    answer2 = json['answer2'] ?? '';
    answer3 = json['answer3'] ?? '';
    finish = json['finish'] ?? false;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'firstname': firstname,
        'lastname': lastname,
        'answer1': answer1,
        'answer2': answer2,
        'answer3': answer3,
        'finish': finish,
      };
}
