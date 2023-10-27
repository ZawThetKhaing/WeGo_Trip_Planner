import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? uid;
  final User? user;
  final String? userName;
  final String? profilePhoto;
  final String? phoneNumber;
  UserModel({
    this.uid,
    this.user,
    this.userName,
    this.profilePhoto,
    this.phoneNumber,
  });

  factory UserModel.fromJson(dynamic data, String id) => UserModel(
        uid: id,
        userName: data["user_name"],
        profilePhoto: data["profile_photo"],
        phoneNumber: data["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        'user_name': userName,
        'profile_photo': profilePhoto,
        'phone_number': phoneNumber,
      };
}
