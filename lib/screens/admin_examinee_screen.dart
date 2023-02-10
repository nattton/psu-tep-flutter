import 'package:flutter/material.dart';
import 'package:psutep/components/admin_examinee_card.dart';
import 'package:psutep/models/examinee.dart';
import 'package:psutep/services/app_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AdminExamineeScreen extends StatefulWidget {
  const AdminExamineeScreen({super.key});

  @override
  State<AdminExamineeScreen> createState() => _AdminExamineeScreenState();
}

class _AdminExamineeScreenState extends State<AdminExamineeScreen> {
  late AppService appService;
  List<Examinee> examineeList = [];
  final _codeController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();

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
    _codeController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: examineeList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          var examinee = Examinee(0);
          return AdminExamineeCard(
              examinee: examinee, onTap: () => onPressedAdd(context, examinee));
        }
        return AdminExamineeCard(
            examinee: examineeList[index - 1],
            onTap: () => onPressedEdit(context, examineeList[index - 1]));
      },
    );
  }

  Future<void> getExaminee() async {
    appService.fetchExamineeList().then((value) {
      setState(() {
        examineeList = value;
      });
    }).catchError((error) {});
  }

  void addExaminee(Examinee examinee) {
    appService
        .addExaminee(
      examinee.id,
      _codeController.text,
      _firstnameController.text,
      _lastnameController.text,
    )
        .then((value) {
      Navigator.pop(context);
      getExaminee();
    }).catchError((error) {
      alertError(error);
    });
  }

  void saveExaminee(Examinee examinee) {
    appService
        .saveExaminee(
      examinee.id,
      _codeController.text,
      _firstnameController.text,
      _lastnameController.text,
    )
        .then((value) {
      Navigator.pop(context);
      getExaminee();
    }).catchError((error) {
      alertError(error);
    });
  }

  void onPressedAdd(BuildContext context, Examinee examinee) {
    _codeController.text = examinee.code ?? '';
    _firstnameController.text = examinee.firstname ?? '';
    _lastnameController.text = examinee.lastname ?? '';

    Alert(
        context: context,
        title: "Add New Examinee",
        content: Column(
          children: [
            const SizedBox(height: 8.0),
            TextField(
              controller: _codeController,
              autofocus: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Student Code',
                suffixIcon: const Icon(Icons.numbers),
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
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
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
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
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              onSubmitted: (value) => addExaminee(examinee),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              saveExaminee(examinee);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  void onPressedEdit(BuildContext context, Examinee examinee) {
    _codeController.text = examinee.code ?? '';
    _firstnameController.text = examinee.firstname ?? '';
    _lastnameController.text = examinee.lastname ?? '';

    Alert(
        context: context,
        title: "Edit Examinee",
        content: Column(
          children: [
            const SizedBox(height: 8.0),
            TextField(
              controller: _codeController,
              autofocus: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Student Code',
                suffixIcon: const Icon(Icons.numbers),
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
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
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
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
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              onSubmitted: (value) => saveExaminee(examinee),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              saveExaminee(examinee);
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
