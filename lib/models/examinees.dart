import 'package:psutep/models/examinee.dart';

class Examinees {
  String storePath;
  List<Examinee> examinees;

  Examinees(this.storePath, this.examinees);

  Examinees.fromJson(Map<String, dynamic> json)
      : storePath = json['store_path'],
        examinees = (json["examinees"] as List)
            .map((data) => Examinee.fromJson(data))
            .toList();
}
