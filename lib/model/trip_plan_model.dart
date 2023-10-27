import 'package:we_go/model/user_model.dart';

class TripPlanModel {
  final String? id;
  final String tripName;
  final String destination;
  final String startDate;
  final String endDate;
  final int budget;

  final List<Locations>? locations;
  final DateTime createdAt;
  final List<UserModel> participants;
  TripPlanModel({
    this.id,
    required this.tripName,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    this.locations,
    this.participants = const [],
  }) : createdAt = DateTime.now();

  Map<String, dynamic> toJson() => {
        'trip_name': tripName,
        'destination': destination,
        'start_date': startDate,
        'end_date': endDate,
        'budget': budget,
        'location': locations,
        'created_at': createdAt,
      };

  factory TripPlanModel.fromJson(Map data) => TripPlanModel(
        tripName: data['trip_name'],
        destination: data['destination'],
        startDate: data['start_date'],
        endDate: data['end_date'],
        budget: int.tryParse(data['budget'].toString()) ?? 0,
        locations: data['location'] ?? "",
      );
}

class Locations {
  final String name;
  final String photo;
  Locations({
    required this.name,
    required this.photo,
  });
}
