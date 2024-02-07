import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_go/global.dart';
import 'package:we_go/utils/collection.dart';

class UserModel {
  final String? uid;
  final String? userName;
  final String? profilePhoto;
  final String? phoneNumber;
  final String? email;
  final String? budgetPaidStatus;
  final int? budgetPaid;
  final DateTime? createdAt;
  final String? addBy;
  UserModel({
    this.uid,
    this.userName,
    this.profilePhoto,
    this.phoneNumber,
    this.email,
    this.budgetPaid,
    this.budgetPaidStatus = Collections.unPaid,
    this.createdAt,
    this.addBy,
  });

  factory UserModel.fromJson(dynamic data, String id) => UserModel(
        uid: id,
        userName: data["user_name"],
        profilePhoto: data["profile_photo"],
        phoneNumber: data["phone_number"],
        email: data["email"],
        budgetPaidStatus: data["budget_paid_status"],
        createdAt: (data["created_at"] as Timestamp?)?.toDate(),
        addBy: data["add_by"],
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
        budgetPaidStatus: data["budget_paid_status"],
        budgetPaid: int.parse((data["budget_paid"] ?? 0).toString()),
        addBy: data["add_by"],
        createdAt: (data["created_at"] as Timestamp?)?.toDate(),
      );

  UserModel copyWith({UserModel? data}) => UserModel(
        uid: data?.uid ?? uid,
        userName: data?.userName ?? userName,
        profilePhoto: data?.profilePhoto ?? profilePhoto,
        phoneNumber: data?.phoneNumber ?? phoneNumber,
        email: data?.email ?? email,
        budgetPaid: data?.budgetPaid ?? budgetPaid,
        budgetPaidStatus: data?.budgetPaidStatus ?? budgetPaidStatus,
        createdAt: data?.createdAt ?? createdAt,
        addBy: data?.addBy,
      );

  factory UserModel.fromUser(
    User data,
  ) =>
      UserModel(
        uid: data.uid,
        userName: data.displayName,
        profilePhoto: data.photoURL,
        phoneNumber: data.phoneNumber,
        email: data.email,
      );

  factory UserModel.forBudgetPaid(
    UserModel data,
  ) =>
      UserModel(
        uid: data.uid,
        userName: data.userName,
        profilePhoto: data.profilePhoto,
        phoneNumber: data.phoneNumber,
        email: data.email,
        budgetPaidStatus: data.budgetPaidStatus,
        budgetPaid: data.budgetPaid,
        createdAt: data.createdAt,
        addBy: data.addBy,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'user_name': userName,
        'profile_photo': profilePhoto,
        'phone_number': phoneNumber,
        'email': email,
        'budget_paid_status': budgetPaidStatus,
        'budget_paid': budgetPaid,
        'created_at': createdAt,
        "add_by": addBy,
      };

  Map<String, dynamic> toInvite() => {
        'uid': uid,
        'user_name': userName,
        'profile_photo': profilePhoto,
        'phone_number': phoneNumber,
        'email': email,
        'budget_paid_status': budgetPaidStatus,
        'budget_paid': budgetPaid,
        "add_by": authService.auth.currentUser?.displayName,
        'created_at': createdAt ?? DateTime.now(),
      };

  @override
  operator ==(covariant UserModel other) => uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
