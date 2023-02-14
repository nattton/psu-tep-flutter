import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:psutep/models/exam.dart';
import 'package:psutep/models/message_response.dart';
import 'package:psutep/models/examinee.dart';
import 'package:psutep/models/login_examinee.dart';

import 'package:psutep/models/login_user.dart';
import 'package:psutep/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kHostUrl = 'http://localhost:4000';
const kLoginUrl = '$kHostUrl/api/login';
const kAdminUserListUrl = '$kHostUrl/api/admin/users';
const kAdminUserUrl = '$kHostUrl/api/admin/user';
const kAdminTaskUrl = '$kHostUrl/api/admin/task';
const kExamineeUrl = '$kHostUrl/api/admin/examinee';
const kExamineesUrl = '$kHostUrl/api/admin/examinees';
const kAdminExamineesScoreUrl = '$kHostUrl/api/admin/examinees/scores';
const kAdminExamineesScoresDownloadUrl =
    '$kHostUrl/api/admin/examinees/scores/download';
const kAdminAnswersUrl = '$kHostUrl/api/admin/examinees/answers/download';

const kRaterExamineeListUrl = '$kHostUrl/api/rater/examinees';
const kRaterScoreUrl = '$kHostUrl/api/rater/score';

const kRefreshTokenUrl = '$kHostUrl/api/refresh_token';

const kLoginExamineeUrl = '$kHostUrl/api/login_examinee';
const kSendAnswerUrl = '$kHostUrl/api/examinee/answer';

const kTaskUrl = '$kHostUrl/api/task';

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

  Future<LoginUser> fetchRefreshToken() async {
    final response = await http.post(
      Uri.parse(kRefreshTokenUrl),
      headers: {'Authorization': 'Bearer $_token'},
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

  Future<String> sendAnswer(int ansNum, String path) async {
    final file = XFile(path);
    Uri uri = Uri.parse('$kSendAnswerUrl/$ansNum');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = _token;
    request.files.add(http.MultipartFile.fromBytes(
        'answer', await file.readAsBytes(),
        filename: 'answer.wav', contentType: MediaType('audio', 'wav')));
    http.StreamedResponse streamedResponse = await request.send();
    if (streamedResponse.statusCode == 200) {
      return '';
    }
    final response = await http.Response.fromStream(streamedResponse);
    if (kDebugMode) {
      print(response.body);
    }

    return "";
  }

  Future<List<Examinee>> fetchExamineeList() async {
    final response = await http.get(Uri.parse(kExamineesUrl),
        headers: {'Authorization': 'Bearer $_token'});

    if (response.statusCode == 200) {
      try {
        final res = jsonDecode(utf8.decode(response.bodyBytes))["examinees"];
        return (res as List).map((data) => Examinee.fromJson(data)).toList();
      } catch (e) {
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
        return Future.error(response);
      }
    }
    return Future.error(response);
  }

  Future<List<Examinee>> fetchExamineeByAdminList() async {
    final response = await http.get(Uri.parse(kAdminExamineesScoreUrl),
        headers: {'Authorization': 'Bearer $_token'});
    if (response.statusCode == 200) {
      try {
        final res = jsonDecode(utf8.decode(response.bodyBytes))["examinees"];
        return (res as List).map((data) => Examinee.fromJson(data)).toList();
      } catch (e) {
        return Future.error(response);
      }
    }
    return Future.error(response);
  }

  Future rateScore(
      int examineeID, double task1, double task2, double task3) async {
    Map<String, dynamic> body = {
      "examinee_id": examineeID,
      "task1": task1,
      "task2": task2,
      "task3": task3,
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
    }

    return Future.error(response);
  }

  Future<String> uploadExaminees(Uint8List excelBytes) async {
    Uri uri = Uri.parse(kExamineesUrl);
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = _token;
    request.files.add(http.MultipartFile.fromBytes('examinees', excelBytes,
        filename: 'examinees.xlsx',
        contentType: MediaType('application/vnd.ms-excel', 'xlsx')));
    http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      MessageResponse msgResponse =
          MessageResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return msgResponse.message;
    }
    return Future.error(response.body);
  }

  Future createExaminee(String code, String firstname, String lastname) async {
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
    }

    return Future.error(response);
  }

  Future updateExaminee(
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
    }

    return Future.error(response);
  }

  Future<List<User>> fetchUserList() async {
    final response = await http.get(Uri.parse(kAdminUserListUrl),
        headers: {'Authorization': 'Bearer $_token'});

    if (response.statusCode == 200) {
      try {
        final res = jsonDecode(utf8.decode(response.bodyBytes))["users"];
        return (res as List).map((data) => User.fromJson(data)).toList();
      } catch (e) {
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
      Uri.parse('$kAdminUserUrl/$id'),
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

  Future<Task> fetchTask() async {
    final response = await http.get(
      Uri.parse(kTaskUrl),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      Task exam = Task.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return exam;
    }

    return Future.error(response.body);
  }

  Future uploadTask(int seq, Uint8List videoBytes) async {
    Uri uri = Uri.parse('$kAdminTaskUrl/$seq');
    var request = http.MultipartRequest('PATCH', uri);
    request.headers['Authorization'] = _token;
    request.files.add(http.MultipartFile.fromBytes('task', videoBytes,
        filename: 'task.mp4', contentType: MediaType('video', 'mp4')));
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
    }
    return Future.error(response.body);
  }

  Future downloadScoreExcel() async {
    final response = await http.get(
      Uri.parse(kAdminExamineesScoresDownloadUrl),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      webDownloadFile("report_scores.xlsx", response.bodyBytes);
      return "Download file Success.";
    }

    return Future.error(response.body);
  }

  Future<String> downloadAnswersAudio() async {
    final response = await http.get(
      Uri.parse(kAdminAnswersUrl),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      webDownloadFile("answers_audio.zip", response.bodyBytes);
      return "Download file Success.";
    }

    return Future.error(response.body);
  }

  void webDownloadFile(String filename, Uint8List bytes) {
    // Encode our file in base64
    final base64 = base64Encode(bytes);
    // Create the link with the file
    final anchor =
        AnchorElement(href: 'data:application/octet-stream;base64,$base64')
          ..target = 'blank';
    // add the name
    anchor.download = filename;

    // trigger download
    anchor.click();
    anchor.remove();
  }
}
