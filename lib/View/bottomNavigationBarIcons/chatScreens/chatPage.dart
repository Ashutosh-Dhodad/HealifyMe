import 'package:flutter/material.dart';
import 'package:healify_me/Model/messageModel.dart';
import 'package:healify_me/Services/chatService.dart';
import 'package:healify_me/View/bottomNavigationBarIcons/chatWidgets/chatBubble.dart';
import 'package:healify_me/View/bottomNavigationBarIcons/chatWidgets/chatInputField.dart';


class ChatScreen extends StatelessWidget {
  final String doctorId;
  final String patientId;

  const ChatScreen({
    super.key,
    required this.doctorId,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    final chatId = ChatService().getChatId(patientId, doctorId);

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(""),
            fit: BoxFit.cover, 
          ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),),
          backgroundColor: Colors.blue,
          centerTitle: true,
          ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: ChatService().getMessages(chatId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
      
                  var messages = snapshot.data!;
      
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      bool isMe = message.senderId == patientId;
      
                      return ChatBubble(message: message, isMe: isMe);
                    },
                  );
                },
              ),
            ),
            ChatInputField(
              chatId: chatId,
              senderId: patientId,
              receiverId: doctorId,
            ),
          ],
        ),
      ),
    );
  }
}
