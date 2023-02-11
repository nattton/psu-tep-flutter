import 'package:psutep/models/examinee.dart';

class Examinees {
  List<Examinee> examinees;

  Examinees(this.examinees);

  Examinees.fromJson(Map<String, dynamic> json)
      : examinees = (json["examinees"] as List)
            .map((data) => Examinee.fromJson(data))
            .toList();
}
