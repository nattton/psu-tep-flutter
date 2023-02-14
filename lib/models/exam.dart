class Task {
  String task0;
  String task1;
  String task2;
  String task3;

  Task(
    this.task0,
    this.task1,
    this.task2,
    this.task3,
  );

  Task.fromJson(Map<String, dynamic> json)
      : task0 = json['task0'],
        task1 = json['task1'],
        task2 = json['task2'],
        task3 = json['task3'];
}
