import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  final String id;
  final String name;
  final String startLocation;
  final String endLocation;
  final DateTime startDate;
  final DateTime endDate;
  final double cost;
  final String userId;
  final DateTime createdAt;

  TripModel({
    required this.id,
    required this.name,
    required this.startLocation,
    required this.endLocation,
    required this.startDate,
    required this.endDate,
    required this.cost,
    required this.userId,
    required this.createdAt,
  });

  /// Create a TripModel from a Firestore document snapshot
  factory TripModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TripModel(
      id: doc.id,
      name: data['name'] as String,
      startLocation: data['startLocation'] as String,
      endLocation: data['endLocation'] as String,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      cost: (data['cost'] as num).toDouble(),
      userId: data['userId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert a TripModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'cost': cost,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
