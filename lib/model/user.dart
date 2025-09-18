class User {
  int? id;
  String username;
  String password;
  String role;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Username': username,
      'Password': password,
      'Role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['Id'],
      username: map['Username'],
      password: map['Password'],
      role: map['Role'],
    );
  }
}