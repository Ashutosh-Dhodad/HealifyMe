import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createOrUpdateDoctorProfile(String imgUrl, String name, String specialization, String bio, String available_time, String contact) async {
    String uid = _auth.currentUser!.uid;

    await _firestore.collection('doctors').doc(uid).set({
      'imgUrl':imgUrl,
      'uid': uid,
      'name': name,
      'specialization': specialization,
      'bio': bio,
      'contact': contact,
      'createdAt': FieldValue.serverTimestamp(),
      'available_time':available_time,
    }, SetOptions(merge: true));
  }
}
