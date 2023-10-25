import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? uid;
  final User? user;
  final String? userName;
  final String? profilePhoto;
  UserModel({
    this.uid,
    this.user,
    this.userName,
    this.profilePhoto,
  });

  factory UserModel.withUser(User data) => UserModel(
        user: data,
      );

  factory UserModel.fromJson(dynamic data, String id) => UserModel(
        uid: id,
        userName: data["user_name"],
        profilePhoto: data["profile_photo"],
      );

  Map<String, dynamic> toJson() => {
        'user_name': userName,
        'profile_photo': profilePhoto,
      };
}
