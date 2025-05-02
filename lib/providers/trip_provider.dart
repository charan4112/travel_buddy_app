import 'dart:async';
import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../services/firestore_service.dart';

/// Manages fetching and providing trip data to the UI.
class TripProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<TripModel> _allTrips = [];
  StreamSubscription<List<TripModel>>? _allSub;

  List<TripModel> get allTrips => _allTrips;

  /// Start listening to all public trips.
  void loadAllTrips() {
    _allSub = _firestoreService.streamAllTrips().listen((trips) {
      _allTrips = trips;
      notifyListeners();
    });
  }

  /// Stop listening to free resources.
  @override
  void dispose() {
    _allSub?.cancel();
    super.dispose();
  }
}
