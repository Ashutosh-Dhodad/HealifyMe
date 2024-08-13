import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healify_me/View/bottomNavigationBarIcons/chatScreens/chatPage.dart';

class Chatlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title:const Text("Let's Get Started",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600
        ),),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
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
                final doctorId = appointment['doctorId'] ?? 'No Contact Found';
                final patientId = appointment['uid'] ?? 'No Id Found';
        
        
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 450,
                      decoration:const BoxDecoration(image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/f5/3c/09/f53c0984735b1c8c25ab51ac574b3c2a.jpg"), fit: BoxFit.fill)),),

                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(
                          doctorId: doctorId,
                          patientId: patientId
                          ))
                          );
                      },
                      child:  Container(
                        height: 150,
                        width: 250,
                        decoration: BoxDecoration(border: Border.all(color: const Color.fromARGB(255, 202, 106, 197)), borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Text("Chat With: $doctorName",
                          style:const TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500
                          ),),
                        ),
                      )
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 252, 250, 251),
    );
  }
}
