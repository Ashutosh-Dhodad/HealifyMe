import 'package:flutter/material.dart';
import 'package:healify_me/View/audioCall.dart';
import 'package:healify_me/View/vidioCall.dart';

class doctorDetailsScreen extends StatelessWidget {
  final String doctorName;
  final String doctorSpecialization;
  final String doctorImageUrl;
  final String doctorContact;
  final String bio;
  final String uid;


  const doctorDetailsScreen({
    Key? key,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorImageUrl,
    required this.doctorContact,
    required this.bio,
    required this.uid
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(uid);
    print("*********************");
    return Scaffold(
      appBar: AppBar(
        title: Text('Dr. $doctorName',
        style:const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600
        ),),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white,),
            onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context)=> AudioCall(uid: uid)));
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white,),
            onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context)=> VideoCall(uid:uid)));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: MediaQuery.sizeOf(context).width,
                decoration:const BoxDecoration(
                       color: Colors.lightBlueAccent,
                       borderRadius: BorderRadius.only(
                       bottomLeft:Radius.circular(40),
                       bottomRight: Radius.circular(40))
                       ),
                child: Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(doctorImageUrl),
                  ),
                ),
              ),
        
              const SizedBox(height: 30,),
        
              // const Row(
              //   children: [
              //      SizedBox(width: 20,),
              //      Text("Personal Information",
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold
              //     ),),
              //   ],
              // ),
        
              Container(
                margin:const EdgeInsets.all(20),
                height: 100,
                width: MediaQuery.sizeOf(context).width,
                decoration:const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: [
                    const SizedBox(width: 40,),
                    const Text(
                      'Name:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ' DR $doctorName',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
             
              Container(
                margin:const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                height: 100,
                width: MediaQuery.sizeOf(context).width,
                decoration:const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: [
                    const SizedBox(width: 40,),
                    const Text(
                      'Specialization: ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      doctorSpecialization,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
        
              Container(
                margin:const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                height: 100,
                width: MediaQuery.sizeOf(context).width,
                decoration:const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: [
                    const SizedBox(width: 40,),
                    const Text(
                      'Available Time: ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      doctorContact,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),

              Container(
                margin:const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                height: 100,
                width: MediaQuery.sizeOf(context).width,
                decoration:const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: [
                    const SizedBox(width: 40,),
                    const Text(
                      'Bio: ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      bio,
                      maxLines: 10,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
      ),
      backgroundColor: const Color.fromARGB(255, 219, 212, 212),
    );
  }
}
