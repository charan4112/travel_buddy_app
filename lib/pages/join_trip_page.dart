import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chat_page.dart';
import 'itinerary_page.dart';

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
            final tripData = trips[index].data() as Map<String, dynamic>;
            final docId = trips[index].id;

            final startDate = (tripData['startDate'] as Timestamp).toDate();
            final endDate   = (tripData['endDate']   as Timestamp).toDate();

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  tripData['name'] ?? 'Unnamed Trip',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "From ${tripData['startLocation']} to ${tripData['endLocation']}\n"
                  "${DateFormat.yMMMd().format(startDate)} - ${DateFormat.yMMMd().format(endDate)}\n"
                  "Cost: \$${tripData['cost']}",
                ),
                isThreeLine: true,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ItineraryPage(
                              tripId: docId,
                              tripName: tripData['name'] ?? '',
                            ),
                          ),
                        );
                      },
                      child: const Text("Itinerary"),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(
                              tripId: docId,
                              tripName: tripData['name'] ?? '',
                            ),
                          ),
                        );
                      },
                      child: const Text("Chat"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
