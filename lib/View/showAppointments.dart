import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healify_me/Model/appointmentModel.dart';
import 'package:healify_me/Services/authService.dart';
import 'package:healify_me/Services/databaseService.dart';
import 'package:healify_me/View/createNewDoctorProfile.dart';
import 'package:healify_me/View/loginPage.dart';
import 'package:provider/provider.dart';

class DoctorAppointmentsScreen extends StatefulWidget {

   State createState()=> _DoctorAppointmentsScreenState();
  
}

class _DoctorAppointmentsScreenState extends State{

  String? userEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  void _fetchUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
      });
    } else {
      setState(() {
        userEmail = 'No User Logged In';
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context);
     final authService = Provider.of<Authservice>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Welcome",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const CircleAvatar(
                backgroundImage: NetworkImage('https://cdn-icons-png.freepik.com/512/6915/6915987.png'),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://cdn-icons-png.freepik.com/512/6915/6915987.png'),
                  ),
                  const SizedBox(height: 5,),
                  const Text(
                    'User Email:',
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
              
                  Text(
                    userEmail ?? 'No Email Available',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                try {
                  await authService.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Loginpage()),
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  print('Sign out failed: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sign out failed. Please try again.')),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: dbService.getAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          } else {
            List<Appointment> appointments = snapshot.data!;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                var appointment = appointments[index];
                return Container(
                  margin:const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(top: 15),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 50, bottom: 10),
                    child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Appointment With: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black, 
                          ),
                        ),
                        TextSpan(
                          text: appointment.patientName,
                          style:const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black, 
                          ),
                        ),
                      ],
                    ),
                                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 50, bottom: 10),
                    child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Date: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black, 
                          ),
                        ),
                        TextSpan(
                          text: '${appointment.dateTime}',
                          style:const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 50, bottom: 10),
                    child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Doctor Name: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: appointment.doctorName,
                          style:const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black, 
                          ),
                        ),
                      ],
                    ),
                                    ),
                  ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 250,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorProfileForm()));
          },
          backgroundColor: Colors.blueAccent,
          child: const Text(
            "Create Your Profile",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
