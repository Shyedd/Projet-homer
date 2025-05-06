import 'package:flutter/material.dart';

// Page de messagerie
class MessagePage extends StatefulWidget {
  // Propriétés du contact
  final String contactName;
  final String contactImage; // Paramètre pour l'image du contact

  const MessagePage({super.key, required this.contactName, required this.contactImage});

  @override
  _MessagePageState createState() => _MessagePageState();
}

// État de la page de messagerie
class _MessagePageState extends State<MessagePage> {
  // Stockage des messages par contact
  static final Map<String, List<Map<String, String>>> _allMessages = {};
  final TextEditingController _messageController = TextEditingController();

  List<Map<String, String>> get _messages => 
      _allMessages[widget.contactName] ??= [];

  @override
  void initState() {
    super.initState();
    // Initialiser la liste des messages si elle n'existe pas
    _allMessages[widget.contactName] ??= [];
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        final now = TimeOfDay.now();
        final formattedTime = MaterialLocalizations.of(context).formatTimeOfDay(now);
        _messages.add({
          'text': _messageController.text,
          'time': formattedTime,
        });
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.contactImage), // Afficher l'image du contact
            ),
            const SizedBox(width: 10),
            Text(widget.contactName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            message['text']!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          message['time']!,
                          style: const TextStyle(fontSize: 10, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
