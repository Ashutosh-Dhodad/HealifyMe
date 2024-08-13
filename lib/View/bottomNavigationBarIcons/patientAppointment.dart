import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class patientappointment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title:const Text('My Appointments',
        style:const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600
        ),),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('uid', isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No appointments booked yet.'));
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index].data() as Map<String, dynamic>;
              final doctorName = appointment['doctorName'] ?? 'Unknown Doctor';
              final appointmentTime = appointment['dateTime']?.toDate() ?? DateTime.now();
              final doctorId = appointment['doctorId'] ?? 'No Contact Found';

              return Container(
                padding:const EdgeInsets.all(20),
                margin:const EdgeInsets.all(20),
                decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("Doctor Name: ",
                        style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600
                        ),),

                         Text("DR. "+doctorName,
                        style:const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400
                        ),)
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Phone Number: ",
                        style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600
                        ),),

                         Text(doctorId,
                        style:const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400
                        ),)
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Appointment on: ",
                        style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600
                        ),),

                         Text("${appointmentTime.toLocal()}",
                        style:const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                        ),)
                      ],
                    ),
                  ],
                )
                 
             
              );
            },
          );
        },
      ),
    );
  }
}
