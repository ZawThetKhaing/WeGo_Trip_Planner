import 'package:we_go/model/user_model.dart';

class TripPlanModel {
  final String? id;
  final String owner;
  final String tripName;
  final String destination;
  final String startDate;
  final String endDate;
  final String paymentDueDate;
  final int budget;

  // final List<Locations>? locations;
  final DateTime createdAt;
  final List<UserModel> participants;
  TripPlanModel({
    this.id,
    required this.owner,
    required this.tripName,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.paymentDueDate,
    // this.locations,
    this.participants = const [],
  }) : createdAt = DateTime.now();

  Map<String, dynamic> toJson() => {
        'owner': owner,
        'trip_name': tripName,
        'destination': destination,
        'start_date': startDate,
        'end_date': endDate,
        'due_date': paymentDueDate,
        'budget': budget,
        'participants': participants,
        // 'location': locations ?? [],
        'created_at': createdAt,
      };

  factory TripPlanModel.fromJson(Map data, String id) => TripPlanModel(
        id: id,
        owner: data['owner'],
        tripName: data['trip_name'],
        destination: data['destination'],
        startDate: data['start_date'],
        endDate: data['end_date'],
        paymentDueDate: data['due_date'],
        budget: int.tryParse(data['budget'].toString()) ?? 0,
        participants: [UserModel.fromlocal(data['participants'] ?? {})],
        // locations: [Locations.fromJson(data['location'] as Map? ?? {})],
      );
}

class Locations {
  final String name;
  final String photo;
  Locations({
    required this.name,
    required this.photo,
  });

  factory Locations.fromJson(Map data) =>
      Locations(name: data['name'], photo: data['photo']);
}
