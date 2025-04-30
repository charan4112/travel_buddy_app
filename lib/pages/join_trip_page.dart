import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JoinTripPage extends StatelessWidget {
  const JoinTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('trips')
          .orderBy('startDate', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No trips available right now."));
        }

        final trips = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final trip = trips[index].data() as Map<String, dynamic>;

            final startDate = (trip['startDate'] as Timestamp).toDate();
            final endDate = (trip['endDate'] as Timestamp).toDate();

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(
                  trip['name'] ?? 'Unnamed Trip',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "From ${trip['startLocation']} to ${trip['endLocation']}\n"
                  "${DateFormat.yMMMd().format(startDate)} - ${DateFormat.yMMMd().format(endDate)}\n"
                  "Cost: \$${trip['cost']}",
                ),
                isThreeLine: true,
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Join functionality coming soon!"),
                    ));
                  },
                  child: const Text("Join"),
                ),
              ),
            );
          },
        );
      },
    );
  }
}