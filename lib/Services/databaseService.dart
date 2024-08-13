import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healify_me/Model/appointmentModel.dart';

class DatabaseService{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserRole(String uid, String role) async{
    await _db.collection('users').doc(uid).set({'role':role});
  }

  Future<String?> getUserRole(String uid) async{
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    return doc.exists? doc.get('role'):null;
  }

  Stream<List<Appointment>> getAppointments() {
    return _db.collection('appointments').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Appointment.fromFirestore(doc)).toList());
  }

  
  Future<void> addAppointment(Appointment appointment) async{
          await _db.collection('appointments').add(appointment.toMap());
  }


}