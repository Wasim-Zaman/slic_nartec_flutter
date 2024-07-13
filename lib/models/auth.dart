import 'package:slic/models/user.dart';

class AuthModel {
  final String? token;
  final User? user;

  AuthModel({this.token, this.user});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}
