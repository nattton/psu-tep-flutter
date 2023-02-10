import 'package:flutter/material.dart';
import 'package:psutep/components/user_list_card.dart';
import 'package:psutep/models/user.dart';
import 'package:psutep/services/app_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AdminUserScreen extends StatefulWidget {
  const AdminUserScreen({Key? key}) : super(key: key);

  @override
  State<AdminUserScreen> createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  late AppService appService;
  List<User> userList = [];
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppService.getInstance().then((value) {
      appService = value;
      getExaminee();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return UserListCard(
            user: User(0, 'Username', 'Role'),
            onTap: () {},
          );
        }
        return UserListCard(
            user: userList[index - 1],
            onTap: () => onPressedRow(context, userList[index - 1]));
      },
    );
  }

  Future<void> getExaminee() async {
    appService.fetchUserList().then((value) {
      setState(() {
        userList = value;
      });
    }).catchError((error) {});
  }

  void saveUser(User user) {
    appService
        .saveUser(user.id, _usernameController.text, _passwordController.text)
        .then((value) {
      Navigator.pop(context);
      getExaminee();
    }).catchError((error) {
      alertError(error);
    });
  }

  void onPressedRow(BuildContext context, User user) {
    _usernameController.text = user.name;
    _passwordController.text = '';

    Alert(
        context: context,
        title: "Edit User",
        content: Column(
          children: [
            const SizedBox(height: 8.0),
            TextField(
              controller: _usernameController,
              autofocus: false,
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'User',
                suffixIcon: const Icon(Icons.account_circle),
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              autofocus: false,
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Password [blank if not change]',
                suffixIcon: const Icon(Icons.lock),
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              saveUser(user);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  void alertError(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alert Message'),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }
}
