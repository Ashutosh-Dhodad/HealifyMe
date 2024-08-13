import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatId;
  final String doctorId;
  final String patientId;
  final String latestMessage;
  final DateTime latestMessageTimestamp;

  Chat({
    required this.chatId,
    required this.doctorId,
    required this.patientId,
    required this.latestMessage,
    required this.latestMessageTimestamp,
  });

  factory Chat.fromMap(Map<String, dynamic> map, String chatId) {
    return Chat(
      chatId: chatId,
      doctorId: map['doctorId'],
      patientId: map['patientId'],
      latestMessage: map['latestMessage'],
      latestMessageTimestamp: (map['latestMessageTimestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'latestMessage': latestMessage,
      'latestMessageTimestamp': latestMessageTimestamp,
    };
  }
}
