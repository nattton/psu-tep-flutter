// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
      getExaminees();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  void handlerErrorResponse(dynamic error) {
    Response response = error as Response;
    switch (response.statusCode) {
      case 304:
        alertMessage("not modified");
        break;
      case 401:
        appService.logout().then((value) {
          html.window.location.href = "/";
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: examineeList.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Card(
            color: Colors.red.shade100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => uploadExaminees(),
                    child: const Icon(Icons.upload_file),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Text('Upload file excel'),
                  GestureDetector(
                    onTap: () => sampleExaminees(),
                    child: const Icon(
                      Icons.info,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                  GestureDetector(
                    onTap: () => onPressedAdd(context),
                    child: const Icon(Icons.person_add),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Text('Add new'),
                ],
              ),
            ),
          );
        }
        if (index == 1) {
          var examinee = Examinee(0, []);
          return AdminExamineeCard(examinee: examinee, onTap: () {});
        }
        return AdminExamineeCard(
            examinee: examineeList[index - 2],
            onTap: () => onPressedEdit(context, examineeList[index - 2]));
      },
    );
  }

  Future<void> getExaminees() async {
    appService.fetchExamineeList().then((value) {
      setState(() {
        examineeList = value;
      });
    }).catchError((error) {
      handlerErrorResponse(error);
    });
  }

  Future<void> uploadExaminees() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      appService.uploadExaminees(result.files.first.bytes!).then((value) {
        alertMessage(value);
        getExaminees();
      }).catchError((error) {
        alertMessage(error.toString());
      });
    } else {
      // User canceled the picker
    }
  }

  void creatExaminee() {
    appService
        .createExaminee(
      _codeController.text,
      _firstnameController.text,
      _lastnameController.text,
    )
        .then((value) {
      Navigator.pop(context);
      getExaminees();
    }).catchError((error) {
      handlerErrorResponse(error);
    });
  }

  void updateExaminee(Examinee examinee) {
    appService
        .updateExaminee(
      examinee.id,
      _codeController.text,
      _firstnameController.text,
      _lastnameController.text,
    )
        .then((value) {
      getExaminees();
    }).catchError((error) {
      handlerErrorResponse(error);
    });
  }

  void sampleExaminees() {
    Alert(
      context: context,
      title: "Sample Excel template.",
      image: Image.asset("images/sample_examinees.png"),
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          width: 120,
          child: const Text(
            "COOL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  void onPressedAdd(BuildContext context) {
    _codeController.text = '';
    _firstnameController.text = '';
    _lastnameController.text = '';

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
              onSubmitted: (value) => creatExaminee(),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
              creatExaminee();
            },
            child: const Text(
              "Create",
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
              onSubmitted: (value) {
                Navigator.pop(context);
                updateExaminee(examinee);
              },
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
              updateExaminee(examinee);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  void alertMessage(String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Info'),
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
