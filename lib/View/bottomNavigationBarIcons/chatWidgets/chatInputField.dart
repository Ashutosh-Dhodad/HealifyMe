import 'package:flutter/material.dart';
import 'package:healify_me/Model/messageModel.dart';
import 'package:healify_me/Services/chatService.dart';

class ChatInputField extends StatefulWidget {
  final String chatId;
  final String senderId;
  final String receiverId;

  const ChatInputField({
    super.key,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
  });

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final message = Message(
      senderId: widget.senderId,
      receiverId: widget.receiverId,
      text: _controller.text.trim(),
      timestamp: DateTime.now(),
    );

    ChatService().addMessageToChat(widget.chatId, message);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.all(Radius.circular(20))),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.all(Radius.circular(20)))
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
