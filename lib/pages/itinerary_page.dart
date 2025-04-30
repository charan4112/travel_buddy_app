import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItineraryPage extends StatefulWidget {
  final String tripId;
  final String tripName;

  const ItineraryPage({super.key, required this.tripId, required this.tripName});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  final TextEditingController _activity = TextEditingController();
  bool _isLoading = false;

  Future<void> _addActivity() async {
    final activityText = _activity.text.trim();
    if (activityText.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId)
          .collection('itinerary')
          .add({
        'activity': activityText,
        'timestamp': Timestamp.now(),
      });

      _activity.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _activity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itineraryRef = FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.tripId)
        .collection('itinerary')
        .orderBy('timestamp');

    return Scaffold(
      appBar: AppBar(title: Text("Itinerary - ${widget.tripName}")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: itineraryRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text("No itinerary items yet."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final item = docs[index].data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text(item['activity'] ?? "Unnamed activity"),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _activity,
                    decoration: const InputDecoration(
                      hintText: "Add activity...",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _addActivity,
                  child: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Add"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
