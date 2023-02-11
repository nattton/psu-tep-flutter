import 'dart:convert';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:psutep/models/exam.dart';
import 'package:psutep/models/examinees.dart';
import 'package:psutep/models/message_response.dart';
import 'package:psutep/models/examinee.dart';
import 'package:psutep/models/login_examinee.dart';

import 'package:psutep/models/login_user.dart';
import 'package:psutep/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kHostUrl = 'http://localhost:4000';
const kLoginUrl = '$kHostUrl/api/login';
const kLoginExamineeUrl = '$kHostUrl/api/login_examinee';
const kSendAnswerUrl = '$kHostUrl/api/answer';
const kExamineeListUrl = '$kHostUrl/api/examinees';
const kAdminExamineeListUrl = '$kHostUrl/api/admin/examinees';
const kRaterExamineeListUrl = '$kHostUrl/api/rater/examinees';
const kRaterScoreUrl = '$kHostUrl/api/rater/score';
const kExamineeUrl = '$kHostUrl/api/examinee';
const kUserListUrl = '$kHostUrl/api/users';
const kUserUrl = '$kHostUrl/api/user';
const kQuizUrl = '$kHostUrl/api/quiz';

const kTokenKey = 'TOKEN_KEY';
const kRoleKey = 'ROLE_KEY';
const kUserKey = 'USER_KEY';
const kExamineeKey = 'EXAMINEE_KEY';

class AppService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String _token;
  late String _role;
  late User _user;
  late Examinee _examinee;

  static Future<AppService> getInstance() async {
    AppService appService = AppService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appService._token = prefs.getString(kTokenKey) ?? '';
    appService._role = prefs.getString(kRoleKey) ?? '';
    String? userString = prefs.getString(kUserKey);
    if (userString != null) {
      appService._user = User.fromJson(jsonDecode(userString));
    } else {
      appService._user = User(0, "", "");
    }

    String? examineeString = prefs.getString(kExamineeKey);
    if (examineeString != null) {
      appService._examinee = Examinee.fromJson(jsonDecode(examineeString));
    } else {
      appService._examinee = Examinee(0, []);
    }
    return appService;
  }

  bool isLogIn() {
    return _token != '';
  }

  String getRole() {
    return _role;
  }

  User getUser() {
    return _user;
  }

  Examinee getExaminee() {
    return _examinee;
  }

  Future<void> _setToken(String token) async {
    _token = token;
    SharedPreferences prefs = await _prefs;
    await prefs.setString(kTokenKey, token);
  }

  Future<void> _setUser(User user) async {
    _user = user;
    _role = user.role;
    SharedPreferences prefs = await _prefs;
    await prefs.setString(kUserKey, jsonEncode(user.toJson()));
    await prefs.setString(kRoleKey, _role);
  }

  Future<void> _setExaminee(Examinee examinee) async {
    _examinee = examinee;
    _role = "examinee";
    SharedPreferences prefs = await _prefs;
    await prefs.setString(kExamineeKey, jsonEncode(examinee.toJson()));
    await prefs.setString(kRoleKey, _role);
    _examinee = examinee;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await _prefs;
    _token = "";
    _user = User(0, "", "");
    await prefs.clear();
  }

  Future<LoginUser> fetchLoginUser(String username, String password) async {
    Map<String, String> body = {
      "username": username,
      "password": password,
    };
    final response = await http.post(
      Uri.parse(kLoginUrl),
      body: jsonEncode(body).toString(),
    );

    if (response.statusCode == 200) {
      LoginUser loginData =
          LoginUser.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      if (loginData.token.isNotEmpty) {
        await _setToken(loginData.token);
        await _setUser(loginData.user);
        return loginData;
      }
    }

    ErrorResponse errorResponse =
        ErrorResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    return Future.error(errorResponse.error);
  }

  Future<LoginExaminee> fetchLoginExaminee(
      String code, String firstname, String lastname) async {
    Map<String, String> body = {
      "code": code,
      "firstname": firstname,
      "lastname": lastname,
    };
    final response = await http.post(
      Uri.parse(kLoginExamineeUrl),
      body: jsonEncode(body).toString(),
    );

    if (response.statusCode == 200) {
      LoginExaminee loginData =
          LoginExaminee.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      if (loginData.token.isNotEmpty) {
        await _setToken(loginData.token);
        await _setExaminee(loginData.examinee);
        return loginData;
      }
    }

    ErrorResponse errorResponse =
        ErrorResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    return Future.error(errorResponse.error);
  }

  Future<String> sendAnswer(int seq, String path) async {
    final file = XFile(path);
    final audioBytes = await file.readAsBytes();
    print('lengthInBytes: ${audioBytes.lengthInBytes}');
    Uri uri = Uri.parse(kSendAnswerUrl);
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = _token;
    request.files.add(http.MultipartFile.fromBytes(
        'answer$seq', await file.readAsBytes(),
        filename: 'answer$seq.wav', contentType: MediaType('audio', 'wav')));
    http.StreamedResponse streamedResponse = await request.send();
    if (streamedResponse.statusCode != 201) {
      return '';
    }
    final response = await http.Response.fromStream(streamedResponse);
    if (kDebugMode) {
      print(response.body);
    }

    return "";
  }

  Future<List<Examinee>> fetchExamineeList() async {
    final response = await http.get(Uri.parse(kExamineeListUrl),
        headers: {'Authorization': 'Bearer $_token'});

    if (response.statusCode == 200) {
      try {
        final res = jsonDecode(utf8.decode(response.bodyBytes))["examinees"];
        return (res as List).map((data) => Examinee.fromJson(data)).toList();
      } catch (e) {
        if (kDebugMode) {
          print('fetchExamineeList: $e');
        }
        return Future.error(response);
      }
    }
    return Future.error(response);
  }

  Future<List<Examinee>> fetchExamineeByRaterList() async {
    final response = await http.get(Uri.parse(kRaterExamineeListUrl),
        headers: {'Authorization': 'Bearer $_token'});
    if (response.statusCode == 200) {
      try {
        final res = jsonDecode(utf8.decode(response.bodyBytes))["examinees"];
        return (res as List).map((data) => Examinee.fromJson(data)).toList();
      } catch (e) {
        if (kDebugMode) {
          print('fetchExamineeByRaterList: $e');
        }
        return Future.error(response);
      }
    }
    return Future.error(response);
  }

  Future<List<Examinee>> fetchExamineeByAdminList() async {
    final response = await http.get(Uri.parse(kAdminExamineeListUrl),
        headers: {'Authorization': 'Bearer $_token'});
    if (response.statusCode == 200) {
      try {
        final res = jsonDecode(utf8.decode(response.bodyBytes))["examinees"];
        return (res as List).map((data) => Examinee.fromJson(data)).toList();
      } catch (e) {
        if (kDebugMode) {
          print('fetchExamineeByAdminList: $e');
        }
        return Future.error(response);
      }
    }
    return Future.error(response);
  }

  Future rateScore(
      int examineeID, double answer1, double answer2, double answer3) async {
    Map<String, dynamic> body = {
      "examinee_id": examineeID,
      "answer1": answer1,
      "answer2": answer2,
      "answer3": answer3,
    };
    final response = await http.post(
      Uri.parse(kRaterScoreUrl),
      headers: {'Authorization': 'Bearer $_token'},
      body: jsonEncode(body).toString(),
    );
    if (response.statusCode == 200) {
      MessageResponse msgResponse =
          MessageResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return msgResponse;
    } else if (response.statusCode == 304) {
      return Future.error("not modified");
    }
    return Future.error(response.body);
  }

  Future createExaminee(
      int id, String code, String firstname, String lastname) async {
    Map<String, String> body = {
      "code": code,
      "firstname": firstname,
      "lastname": lastname,
    };
    final response = await http.post(
      Uri.parse(kExamineeUrl),
      headers: {'Authorization': 'Bearer $_token'},
      body: jsonEncode(body).toString(),
    );
    if (response.statusCode == 201) {
      MessageResponse msgResponse =
          MessageResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return msgResponse;
    } else if (response.statusCode == 304) {
      return Future.error("not modified");
    }
    return Future.error(response.body);
  }

  Future addExaminee(
      int id, String code, String firstname, String lastname) async {
    Map<String, String> body = {
      "code": code,
      "firstname": firstname,
      "lastname": lastname,
    };
    final response = await http.post(
      Uri.parse(kExamineeUrl),
      headers: {'Authorization': 'Bearer $_token'},
      body: jsonEncode(body).toString(),
    );
    if (response.statusCode == 201) {
      MessageResponse msgResponse =
          MessageResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return msgResponse;
    } else if (response.statusCode == 304) {
      return Future.error("not modified");
    }

    ErrorResponse errorResponse =
        ErrorResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

    return Future.error(errorResponse.error);
  }

  Future saveExaminee(
      int id, String code, String firstname, String lastname) async {
    Map<String, String> body = {
      "code": code,
      "firstname": firstname,
      "lastname": lastname,
    };
    final response = await http.patch(
      Uri.parse('$kExamineeUrl/$id'),
      headers: {'Authorization': 'Bearer $_token'},
      body: jsonEncode(body).toString(),
    );
    if (response.statusCode == 200) {
      MessageResponse msgResponse =
          MessageResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return msgResponse;
    } else if (response.statusCode == 304) {
      return Future.error("not modified");
    }
    ErrorResponse errorResponse =
        ErrorResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

    return Future.error(errorResponse.error);
  }

  Future<List<User>> fetchUserList() async {
    final response = await http.get(Uri.parse(kUserListUrl),
        headers: {'Authorization': 'Bearer $_token'});

    if (response.statusCode == 200) {
      try {
        final res = jsonDecode(utf8.decode(response.bodyBytes))["users"];
        return (res as List).map((data) => User.fromJson(data)).toList();
      } catch (e) {
        if (kDebugMode) {
          print('fetchUserList: $e');
        }
        return Future.error(response);
      }
    }
    return Future.error(response);
  }

  Future saveUser(int id, String username, String password) async {
    Map<String, String> body = {
      "username": username,
      "password": password,
    };
    final response = await http.patch(
      Uri.parse('$kUserUrl/$id'),
      headers: {'Authorization': 'Bearer $_token'},
      body: jsonEncode(body).toString(),
    );
    if (response.statusCode == 200) {
      MessageResponse msgResponse =
          MessageResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return msgResponse;
    } else if (response.statusCode == 304) {
      return Future.error("not modified");
    }
    return Future.error(response.body);
  }

  Future<Quiz> fetchQuiz() async {
    final response = await http.get(
      Uri.parse(kQuizUrl),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      Quiz exam = Quiz.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return exam;
    }

    return Future.error(response.body);
  }

  Future saveQuiz(int seq, Uint8List videoBytes) async {
    Uri uri = Uri.parse(kQuizUrl);
    var request = http.MultipartRequest('PATCH', uri);
    request.headers['Authorization'] = _token;
    request.files.add(http.MultipartFile.fromBytes('quiz$seq', videoBytes,
        filename: 'quiz$seq.mp4', contentType: MediaType('video', 'mp4')));
    http.StreamedResponse streamedResponse = await request.send();
    if (streamedResponse.statusCode != 201) {
      return '';
    }
    final response = await http.Response.fromStream(streamedResponse);
    if (kDebugMode) {
      print(response.body);
    }

    if (response.statusCode == 200) {
      return "Save file succeed.";
    } else if (response.statusCode == 304) {
      return Future.error("not modified");
    }
    return Future.error(response.body);
  }
}
