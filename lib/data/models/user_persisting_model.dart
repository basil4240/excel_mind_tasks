import 'package:excel_mind_tasks/data/models/user_model.dart';

class UserPersistingModel {
  final String id;
  final String email;
  final String name;
  final String password;
  final String phone;
  final String bio;
  final bool isDark;

  UserPersistingModel({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.phone,
    required this.bio,
    required this.isDark
  });

  factory UserPersistingModel.fromJson(Map<String, dynamic> json) {
    return UserPersistingModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
      phone: json['phone'],
      bio: json['bio'],
      isDark: json['isDark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'phone': phone,
      'bio': bio,
      'isDark': isDark,
    };
  }

  UserModel toUserModel() {
    return UserModel(id: id, email: email, name: name);
  }

}