import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_go/model/user_model.dart';

class TripPlanModel {
  final String? id;
  final String owner;
  final String? ownerId;
  final String tripName;
  final String destination;
  final String startDate;
  final String endDate;
  final String paymentDueDate;
  final int budget;

  final List<Plans>? plans;
  final DateTime createdAt;
  final List<UserModel>? participants;
  TripPlanModel({
    this.id,
    this.ownerId,
    required this.owner,
    required this.tripName,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.paymentDueDate,
    this.plans,
    this.participants,
  }) : createdAt = DateTime.now();

  Map<String, dynamic> toJson() => {
        'owner': owner,
        'owner_id': ownerId,
        'trip_name': tripName,
        'destination': destination,
        'start_date': startDate,
        'end_date': endDate,
        'due_date': paymentDueDate,
        'budget': budget,
        'participants': participants,
        'plans': plans,
        'created_at': createdAt,
      };

  factory TripPlanModel.fromJson(
    dynamic data,
    String id,
  ) {
    return TripPlanModel(
      id: id,
      owner: data['owner'],
      ownerId: data['owner_id'],
      tripName: data['trip_name'],
      destination: data['destination'],
      startDate: data['start_date'],
      endDate: data['end_date'],
      paymentDueDate: data['due_date'],
      budget: int.tryParse(data['budget'].toString()) ?? 0,
      participants: (data['participants'] as List? ?? [])
          .map(
            (e) => UserModel.fromInvite(
              e,
            ),
          )
          .toList(),
      plans:
          (data['plans'] as List? ?? []).map((e) => Plans.fromJson(e)).toList(),
    );
  }

  factory TripPlanModel.fromLocal(
    TripPlanModel data,
  ) {
    return TripPlanModel(
      id: data.id,
      owner: data.owner,
      ownerId: data.ownerId,
      tripName: data.tripName,
      destination: data.destination,
      startDate: data.startDate,
      endDate: data.endDate,
      paymentDueDate: data.paymentDueDate,
      budget: data.budget,
      participants: data.participants,
      plans: data.plans,
    );
  }

  @override
  operator ==(covariant TripPlanModel other) => other.id == id;
  @override
  int get hashCode => id.hashCode;
}

class Plans {
  final String? id;
  final int day;
  final String title;
  final String content;
  final List<String> likes;
  final List<String> unlikes;
  final DateTime? createdAt;
  Plans({
    this.id,
    required this.day,
    required this.title,
    required this.content,
    required this.likes,
    required this.unlikes,
    this.createdAt,
  });

  factory Plans.fromJson(dynamic data) => Plans(
        id: data['id'],
        day: int.parse(data['day'].toString()),
        title: data['title'],
        content: data['content'],
        likes: (data['likes'] as List).map((e) => e.toString()).toList(),
        unlikes: (data['unlikes'] as List).map((e) => e.toString()).toList(),
        createdAt: (data['created_at'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'day': day,
        'title': title,
        'content': content,
        'likes': likes,
        'unlikes': unlikes,
        'created_at': createdAt,
      };

  @override
  operator ==(covariant Plans other) => other.id == id;
  @override
  int get hashCode => id.hashCode;
}
