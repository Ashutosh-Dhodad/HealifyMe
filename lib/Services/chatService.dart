import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healify_me/Model/chatModel.dart';
import 'package:healify_me/Model/messageModel.dart';


class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createChatDocument(String patientId, String doctorId) async {
    String chatId = getChatId(patientId, doctorId);
    DocumentReference chatDocRef = _firestore.collection('chats').doc(chatId);

    DocumentSnapshot chatDocSnapshot = await chatDocRef.get();

    if (!chatDocSnapshot.exists) {
      await chatDocRef.set(Chat(
        chatId: chatId,
        doctorId: doctorId,
        patientId: patientId,
        latestMessage: '',
        latestMessageTimestamp: DateTime.now(),
      ).toMap());
    }
  }

  Future<void> addMessageToChat(String chatId, Message message) async {
    CollectionReference messagesRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    await messagesRef.add(message.toMap());

    await _firestore.collection('chats').doc(chatId).update({
      'latestMessage': message.text,
      'latestMessageTimestamp': FieldValue.serverTimestamp(),
    });
  }

  String getChatId(String patientId, String doctorId) {
    return patientId.hashCode <= doctorId.hashCode
        ? '$patientId-$doctorId'
        : '$doctorId-$patientId';
  }

  Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
