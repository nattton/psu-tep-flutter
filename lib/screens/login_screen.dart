import 'package:flutter/material.dart';
import 'package:psutep/screens/test_record_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:psutep/constants.dart';
import 'package:psutep/screens/admin_screen.dart';
import 'package:psutep/screens/exam_screen.dart';
import 'package:psutep/services/app_service.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AppService appService;
  final _codeController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool examineeForm = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _codeController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    AppService.getInstance().then((value) => appService = value);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(gradient: kBackgroundGradiant),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    SizedBox(
                      height: 48.0,
                    ),
                    Hero(
                      tag: 'Logo',
                      child: Image(
                        image: AssetImage('images/psu_logo.png'),
                        width: 300.0,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      'PSU-TEP',
                      style: TextStyle(
                        fontSize: 56.0,
                        fontFamily: kDefaultFont,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Prince of Songkla University Test of English Proficiency',
                      style: TextStyle(
                        fontSize: 26.0,
                        fontFamily: kDefaultFont,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 36.0,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: examineeForm,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Examinee Login',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: kDefaultFont,
                            fontWeight: FontWeight.bold,
                            color: kColorTextGrey,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        TextField(
                          controller: _codeController,
                          autofocus: false,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Student Code',
                            suffixIcon: const Icon(Icons.numbers),
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: _firstnameController,
                          autofocus: false,
                          autocorrect: false,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Firstname',
                            suffixIcon: const Icon(Icons.text_fields),
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: _lastnameController,
                          autofocus: false,
                          autocorrect: false,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Lastname',
                            suffixIcon: const Icon(Icons.text_fields),
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          onSubmitted: (_) => loginExaminee(),
                        ),
                        const SizedBox(height: 18.0),
                        Container(
                          height: 50,
                          decoration: const ShapeDecoration(
                            shape: StadiumBorder(),
                            gradient: kBackgroundGradiant,
                          ),
                          child: MaterialButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: const StadiumBorder(),
                            onPressed: loginExaminee,
                            child: const Text(
                              '   Login   ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !examineeForm,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Admin Login',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: kDefaultFont,
                            fontWeight: FontWeight.bold,
                            color: kColorTextGrey,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        TextField(
                          controller: _usernameController,
                          autofocus: false,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            suffixIcon: const Icon(Icons.account_circle),
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: _passwordController,
                          autofocus: false,
                          autocorrect: false,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              child: const Icon(Icons.lock),
                            ),
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 20.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          onSubmitted: (_) => loginUser(),
                        ),
                        const SizedBox(height: 18.0),
                        Container(
                          height: 50,
                          decoration: const ShapeDecoration(
                            shape: StadiumBorder(),
                            gradient: kBackgroundGradiant,
                          ),
                          child: MaterialButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: const StadiumBorder(),
                            onPressed: loginUser,
                            child: const Text(
                              '   Login   ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18.0),
              TextButton(
                onPressed: () {
                  setState(() {
                    examineeForm = !examineeForm;
                  });
                },
                style: TextButton.styleFrom(foregroundColor: kColorBottom),
                child: Text(examineeForm ? 'Admin Login' : 'Examinee Login'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginExaminee() async {
    if (_codeController.text.isEmpty ||
        _firstnameController.text.isEmpty ||
        _lastnameController.text.isEmpty) {
      alertLogin("Please fill student code, firstname, lastname");
      return;
    }
    appService
        .fetchLoginExaminee(_codeController.text, _firstnameController.text,
            _lastnameController.text)
        .then((value) {
      setState(() {
        _codeController.text = '';
        _firstnameController.text = '';
        _lastnameController.text = '';
      });
      goTestRecordScreen();
    }).catchError((error) {
      alertLogin(error.toString());
    });
  }

  void loginUser() async {
    if (_usernameController.text.length < 3 ||
        _passwordController.text.length < 3) {
      alertLogin("Please fill username and password");
      return;
    }
    appService
        .fetchLoginUser(_usernameController.text, _passwordController.text)
        .then((value) {
      setState(() {
        _usernameController.text = '';
        _passwordController.text = '';
      });
      goAdminScreen();
    }).catchError((error) {
      alertLogin(error.toString());
    });
  }

  void goAdminScreen() {
    Navigator.of(context).pushNamed(AdminScreen.id);
  }

  void goTestRecordScreen() {
    Navigator.of(context).pushNamed(TestRecordScreen.id);
  }

  void alertLogin(String desc) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      descStyle: const TextStyle(fontWeight: FontWeight.bold),
      descTextAlign: TextAlign.start,
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: const TextStyle(
        color: Colors.red,
      ),
      alertAlignment: Alignment.center,
    );
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.error,
      title: "Login Failed",
      desc: desc,
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          color: const Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    ).show();
  }
}
