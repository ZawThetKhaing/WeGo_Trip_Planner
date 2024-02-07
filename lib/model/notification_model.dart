import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String? id;
  final String senderId;
  final String senderName;

  final String message;
  final String content;
  final List<String?> receivers;
  final DateTime createdAt;
  final bool? isread;
  NotificationModel({
    this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.message,
    required this.receivers,
    required this.createdAt,
    this.isread = false,
  });

  NotificationModel.forAllParticipants({
    this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.receivers,
    required this.message,
    this.isread = false,
  }) : createdAt = DateTime.now();

  Map<String, dynamic> toJson() => {
        'sender_id': senderId,
        'message': message,
        'receivers': receivers,
        'sender_name': senderName,
        'content': content,
        'created_at': createdAt,
        'isRead': isread,
      };

  factory NotificationModel.fromJson(dynamic data, String id) =>
      NotificationModel(
        id: id,
        senderName: data['sender_name'],
        content: data['content'],
        senderId: data['sender_id'],
        message: data['message'],
        isread: data['isRead'],
        receivers:
            (data['receivers'] as List).map((e) => e?.toString()).toList(),
        createdAt: (data['created_at'] as Timestamp).toDate(),
      );
}
