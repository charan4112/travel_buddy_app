import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TravelTipsPage extends StatefulWidget {
  const TravelTipsPage({super.key});

  @override
  State<TravelTipsPage> createState() => _TravelTipsPageState();
}

class _TravelTipsPageState extends State<TravelTipsPage> {
  final TextEditingController _tipController = TextEditingController();
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
          .showSnackBar(SnackBar(content: Text('Error: $e')));
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
    final tipsStream = FirebaseFirestore.instance
        .collection('travel_tips')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Travel Tips & Reviews')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _tipController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Share a travel tip or experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.white,
                filled: true,
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
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Post Tip'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const Divider(height: 30),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: tipsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(child: Text('No tips shared yet.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final tip = docs[index].data()! as Map<String, dynamic>;
                    final author = tip['author'] ?? 'Anonymous';
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: ListTile(
                        title: Text(tip['text'] ?? ''),
                        subtitle: Text('— $author'),
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
