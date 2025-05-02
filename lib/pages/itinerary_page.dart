import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItineraryPage extends StatefulWidget {
  final String tripId;
  final String tripName;

  const ItineraryPage({
    super.key,
    required this.tripId,
    required this.tripName,
  });

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  final TextEditingController _activityController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addActivity() async {
    final text = _activityController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId)
          .collection('itinerary')
          .add({
        'activity': text,
        'timestamp': Timestamp.now(),
      });
      _activityController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding activity: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _activityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itineraryStream = FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.tripId)
        .collection('itinerary')
        .orderBy('timestamp')
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: Text('Itinerary — ${widget.tripName}')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: itineraryStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(child: Text('No itinerary items yet.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data()! as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(data['activity'] ?? ''),
                        subtitle: Text(
                          (data['timestamp'] as Timestamp)
                              .toDate()
                              .toLocal()
                              .toString()
                              .split('.')[0],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _activityController,
                    decoration: const InputDecoration(
                      hintText: 'Add a new activity...',
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
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Add'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
