import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String doctorId;
  final String doctorName;
  final String patientName;
  final DateTime dateTime;
  final String uid;

  Appointment({
    required this.doctorId,
    required this.doctorName,
    required this.patientName,
    required this.dateTime,
    required this.uid,
  });

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Appointment(
      doctorId: data['doctorId'] ?? "",
      doctorName: data['doctorName'] ?? "",
      patientName: data['patientName'] ?? "",
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      uid: data['uid'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'patientName': patientName,
      'dateTime': dateTime,
      'uid':uid
    };
  }
}
