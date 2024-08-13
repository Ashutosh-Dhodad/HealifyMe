import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healify_me/Services/authService.dart';
import 'package:healify_me/View/AppointmentScreen.dart';
import 'package:healify_me/View/bottomNavigationBarIcons/chatScreens/chatList.dart';
import 'package:healify_me/View/bottomNavigationBarIcons/patientAppointment.dart';
import 'package:healify_me/View/doctorDetailsScreen.dart';
import 'package:healify_me/View/loginPage.dart';
import 'package:provider/provider.dart';

class patientHomeScreen extends StatefulWidget {
  const patientHomeScreen({super.key});

  @override
  State<patientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<patientHomeScreen> {
  int currentPage = 0;
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

  void _onItemTapped(int index) {
    setState(() {
      currentPage = index;
    });
  }

  final List<Map<String, dynamic>> medCat = [
    {
      "Icon": FontAwesomeIcons.userDoctor,
      "category": "General",
    },
    {
      "Icon": FontAwesomeIcons.heartPulse,
      "category": "Cardiology",
    },
    {
      "Icon": FontAwesomeIcons.lungs,
      "category": "Respirations",
    },
    {
      "Icon": FontAwesomeIcons.hand,
      "category": "Dermatology",
    },
    {
      "Icon": FontAwesomeIcons.personPregnant,
      "category": "Gynecology",
    },
    {
      "Icon": FontAwesomeIcons.teeth,
      "category": "Dental",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<Authservice>(context);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    
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
        actions: [
          IconButton(
            onPressed: (){},
            icon:const Icon(Icons.notifications, color: Colors.white,))
        ],
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
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                Text(
                  "Category",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: medCat.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(right: 20),
                      color: Colors.blueAccent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              medCat[index]['Icon'],
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              medCat[index]['category'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                Text(
                  "Find Your Doctor",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: _firestore.collection('doctors').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No doctors found.'));
                  }
                
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.25,
                          width: MediaQuery.sizeOf(context).width * 0.06,
                          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                     Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => doctorDetailsScreen(
                                            doctorName: data['name'] ?? 'Unknown Doctor',
                                            doctorSpecialization: data['specialization'] ?? 'General',
                                            doctorImageUrl: data['imgUrl'] ?? 'https://static.vecteezy.com/system/resources/previews/028/251/987/original/doctor-3d-icon-illustration-free-png.png',
                                            doctorContact: data['contact'] ?? 'No Contact Info',
                                            bio: data['bio'] ?? 'No Bio Available',
                                            uid:data['uid'] ?? 'No id',
                                          ),
                                        ),
                                      );

                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image(
                                        image: NetworkImage(data['imgUrl']),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 25),
                                      Text(
                                        "DR. " + data['name'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        data['specialization'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromARGB(255, 119, 114, 114),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Divider(),
                              Row(
                                children: [
                                  const Text(
                                    "Available Timing: ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 133, 129, 129),
                                    ),
                                  ),
                                  Text(
                                    data['contact'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 133, 129, 129),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Container(
                                    height: 30,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>  AppointmentScreen(),
                                          ),
                                        );
                                      },
                                      child: const Center(
                                        child: Text(
                                          "Book",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: _onItemTapped,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const patientHomeScreen()));
              },
              icon:const Icon(Icons.home),
            ),
            label: 'Home',
          ),BottomNavigationBarItem(
            icon: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>  patientappointment()));
              },
              icon:const Icon(Icons.bookmark_add),
            ),
            label: 'Your Appointments',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>  Chatlist()));
              },
              icon:const Icon(Icons.message),
            ),
            label: 'Message',
          ),
        ],
      ),
    );
  } 
}
