class User {
  final int id;
  final String name;
  final String role;

  User(this.id, this.name, this.role);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        role = json['role'] ?? '',
        name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role,
        'name': name,
      };
}
