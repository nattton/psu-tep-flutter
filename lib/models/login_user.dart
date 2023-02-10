import 'package:psutep/models/user.dart';

class LoginUser {
  final String token;
  final User user;

  LoginUser(this.token, this.user);

  LoginUser.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        user = User.fromJson(json['user']);
}
