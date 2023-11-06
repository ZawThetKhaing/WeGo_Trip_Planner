class UserModel {
  final String? uid;
  final String? userName;
  final String? profilePhoto;
  final String? phoneNumber;
  final String? email;
  UserModel(
      {this.uid,
      this.userName,
      this.profilePhoto,
      this.phoneNumber,
      this.email});

  factory UserModel.fromJson(dynamic data, String id) => UserModel(
        uid: id,
        userName: data["user_name"],
        profilePhoto: data["profile_photo"],
        phoneNumber: data["phone_number"],
        email: data["email"],
      );

  factory UserModel.fromInvite(
    dynamic data,
  ) =>
      UserModel(
        uid: data["uid"],
        userName: data["user_name"],
        profilePhoto: data["profile_photo"],
        phoneNumber: data["phone_number"],
        email: data["email"],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'user_name': userName,
        'profile_photo': profilePhoto,
        'phone_number': phoneNumber,
        'email': email,
      };

  Map<String, dynamic> toInvite() => {
        'uid': uid,
        'user_name': userName,
        'profile_photo': profilePhoto,
        'phone_number': phoneNumber,
        'email': email,
      };

  @override
  operator ==(covariant UserModel other) => uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
