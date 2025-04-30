import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripHistoryPage extends StatelessWidget {
  const TripHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Not logged in.")),
      );
    }

    final userTripsQuery = FirebaseFirestore.instance
        .collection('trips')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('startDate', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text("My Trip History")),
      body: StreamBuilder<QuerySnapshot>(
        stream: userTripsQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text("You haven't created any trips."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final trip = docs[index].data() as Map<String, dynamic>;
              final startDate = (trip['startDate'] as Timestamp).toDate();
              final endDate = (trip['endDate'] as Timestamp).toDate();

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                child: ListTile(
                  title: Text(trip['name'] ?? 'Unnamed Trip'),
                  subtitle: Text(
                    "From ${trip['startLocation']} to ${trip['endLocation']}\n"
                    "${DateFormat.yMMMd().format(startDate)} - ${DateFormat.yMMMd().format(endDate)}\n"
                    "Cost: \$${trip['cost']}",
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
