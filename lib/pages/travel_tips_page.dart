import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TravelTipsPage extends StatefulWidget {
  const TravelTipsPage({super.key});

  @override
  State<TravelTipsPage> createState() => _TravelTipsPageState();
}

class _TravelTipsPageState extends State<TravelTipsPage> {
  final _tipController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitTip() async {
    final text = _tipController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (text.isEmpty || user == null) return;

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection('travel_tips').add({
        'text': text,
        'author': user.email,
        'timestamp': Timestamp.now(),
      });

      _tipController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _tipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tipsRef = FirebaseFirestore.instance
        .collection('travel_tips')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text("Travel Tips & Reviews")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _tipController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Share a travel tip or experience...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submitTip,
              icon: const Icon(Icons.send),
              label: _isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Post Tip"),
            ),
          ),
          const Divider(height: 30),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: tipsRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tips = snapshot.data!.docs;

                if (tips.isEmpty) {
                  return const Center(child: Text("No tips shared yet."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tips.length,
                  itemBuilder: (context, index) {
                    final tip = tips[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(tip['text'] ?? ''),
                        subtitle: Text("— ${tip['author'] ?? 'Anonymous'}"),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
