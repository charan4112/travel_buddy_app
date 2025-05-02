import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String tripId;
  final String tripName;

  const ChatPage({
    super.key,
    required this.tripId,
    required this.tripName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool _isSending = false;

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || currentUser == null) return;

    setState(() => _isSending = true);
    try {
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId)
          .collection('chat')
          .add({
        'text': text,
        'sender': currentUser!.email,
        'timestamp': Timestamp.now(),
      });
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatStream = FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.tripId)
        .collection('chat')
        .orderBy('timestamp')
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: Text('Chat — ${widget.tripName}')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data()! as Map<String, dynamic>;
                    final isMe = data['sender'] == currentUser?.email;
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isMe)
                              Text(
                                data['sender'] ?? 'Anonymous',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            Text(data['text'] ?? ''),
                          ],
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
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  onPressed: _isSending ? null : _sendMessage,
                  icon: const Icon(Icons.send),
                  color: Colors.indigo,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
