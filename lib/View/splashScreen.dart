import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healify_me/View/loginPage.dart';
import 'package:healify_me/View/patientHomeScreen.dart';
import 'package:healify_me/View/showAppointments.dart';

class CheckUserRole extends StatefulWidget {
  @override
  _CheckUserRoleState createState() => _CheckUserRoleState();
}

class _CheckUserRoleState extends State<CheckUserRole> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserRole();
    });
  }

  Future<void> _checkUserRole() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // User is logged in
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        if (role == 'doctor') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DoctorAppointmentsScreen(
                        // doctorId: user.uid,
                      )));
        } else if (role == 'patient') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const patientHomeScreen()));
        } else {
          // Handle other roles or unknown roles
        }
      } else {
        log("doc not found");
      }
    } else {
      // User is not logged in, redirect to login screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Loginpage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), // Show a loading indicator while checking
    );
  }
}
