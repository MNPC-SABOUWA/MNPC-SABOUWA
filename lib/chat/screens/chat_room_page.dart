import 'package:flutter/material.dart';

import '../models/chat_group_model.dart';
import '../models/message_model.dart';

class ChatRoomPage extends StatefulWidget {
  final ChatGroupModel group;

  const ChatRoomPage({
    super.key,
    required this.group,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _controller = TextEditingController();

  final List<MessageModel> messages = [
    MessageModel(
      id: "1",
      sender: "Salou",
      message: "Bonjour à tous",
      time: "08:30",
      isMe: true,
    ),
    MessageModel(
      id: "2",
      sender: "Mariam",
      message: "Bienvenue dans le groupe MNPC",
      time: "08:32",
      isMe: false,
    ),
    MessageModel(
      id: "3",
      sender: "Ali",
      message: "Réunion demain à 10h",
      time: "08:35",
      isMe: false,
    ),
  ];

  void sendMessage() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      messages.add(
        MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: "Moi",
          message: text,
          time: "Maintenant",
          isMe: true,
        ),
      );

      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.name,
            ),
            Text(
              "${widget.group.membersCount} membres",
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                return Align(
                  alignment: message.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: message.isMe
                          ? Colors.green.shade200
                          : Colors.grey.shade200,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.sender,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          message.message,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          message.time,
                          style: const TextStyle(
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Écrire un message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                  ),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}
