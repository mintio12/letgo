import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String password;
  final String avatar;
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.avatar,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? password,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'avatar': avatar,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      password: map['password'],
      avatar: map['avatar'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, phone: $phone, email: $email, password: $password, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.password == password &&
        other.avatar == avatar;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        password.hashCode ^
        avatar.hashCode;
  }
}
