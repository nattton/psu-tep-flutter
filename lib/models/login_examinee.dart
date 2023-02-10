import 'package:psutep/models/examinee.dart';

class LoginExaminee {
  final String token;
  final Examinee examinee;

  LoginExaminee(this.token, this.examinee);

  LoginExaminee.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        examinee = Examinee.fromJson(json['examinee']);
}
