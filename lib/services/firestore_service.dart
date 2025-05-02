import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trip_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Create a new trip document
  Future<void> createTrip(TripModel trip) {
    return _db.collection('trips').add(trip.toMap());
  }

  /// Get stream of all trips ordered by startDate
  Stream<List<TripModel>> streamAllTrips() {
    return _db
        .collection('trips')
        .orderBy('startDate')
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => TripModel.fromDoc(doc))
            .toList());
  }

  /// Get stream of trips for a specific user
  Stream<List<TripModel>> streamUserTrips(String userId) {
    return _db
        .collection('trips')
        .where('userId', isEqualTo: userId)
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => TripModel.fromDoc(doc))
            .toList());
  }

  /// Add an itinerary activity
  Future<void> addItineraryItem(String tripId, String activity) {
    return _db
        .collection('trips')
        .doc(tripId)
        .collection('itinerary')
        .add({
      'activity': activity,
      'timestamp': Timestamp.now(),
    });
  }

  /// Stream itinerary items for a trip
  Stream<List<Map<String, dynamic>>> streamItinerary(String tripId) {
    return _db
        .collection('trips')
        .doc(tripId)
        .collection('itinerary')
        .orderBy('timestamp')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => doc.data()).toList());
  }

  /// Send a chat message
  Future<void> sendChatMessage(String tripId, String sender, String text) {
    return _db
        .collection('trips')
        .doc(tripId)
        .collection('chat')
        .add({
      'sender': sender,
      'text': text,
      'timestamp': Timestamp.now(),
    });
  }

  /// Stream chat messages for a trip
  Stream<List<Map<String, dynamic>>> streamChat(String tripId) {
    return _db
        .collection('trips')
        .doc(tripId)
        .collection('chat')
        .orderBy('timestamp')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => doc.data()).toList());
  }

  /// Post a travel tip
  Future<void> postTip(String author, String text) {
    return _db.collection('travel_tips').add({
      'author': author,
      'text': text,
      'timestamp': Timestamp.now(),
    });
  }

  /// Stream travel tips
  Stream<List<Map<String, dynamic>>> streamTips() {
    return _db
        .collection('travel_tips')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => doc.data()).toList());
  }
}
