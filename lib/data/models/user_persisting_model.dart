import 'package:excel_mind_tasks/data/models/user_model.dart';

class UserPersistingModel {
  final String id;
  final String email;
  final String name;
  final String password;

  UserPersistingModel({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
  });

  factory UserPersistingModel.fromJson(Map<String, dynamic> json) {
    return UserPersistingModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
    };
  }

  UserModel toUserModel() {
    return UserModel(id: id, email: email, name: name);
  }

}