import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healify_me/Model/appointmentModel.dart';
import 'package:healify_me/Services/databaseService.dart';
import 'package:provider/provider.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {

  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(title:const Text('Book Appointment',
      style: TextStyle(color: 
      Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600
      ),),
      leading: IconButton(
          icon:const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.all(16.0),
          child: Column(
            children: [
        
              const SizedBox(height: 20,),
              
             const Image(image: NetworkImage("https://t3.ftcdn.net/jpg/02/60/79/68/360_F_260796882_QyjDubhDDk0RZXV9z7XBEw9AKnWCizXy.jpg")),
        
             const SizedBox(height: 20,),
        
              TextField(
                controller: _doctorNameController,
                decoration:const InputDecoration(labelText: 'Doctor Name', 
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))
                ),
              ),
        
              const SizedBox(height: 20,),
        
              TextField(
                controller: _patientNameController,
                decoration:const InputDecoration(labelText: 'Patient Name',
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))
                ),
              ),

              const SizedBox(height: 20,),
        
              TextField(
                keyboardType: TextInputType.number,
                controller: _phoneNumberController,
                decoration:const InputDecoration(labelText: 'Mobile Number',
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))
                ),
              ),
        
              const SizedBox(height: 30,),
        
              SizedBox(
                height: 50,
                width: 200,
        
                child: ElevatedButton(
                  onPressed: () async {
                    final appointment = Appointment(
                      doctorId: _phoneNumberController.text,
                      patientName: _patientNameController.text,
                      doctorName: _doctorNameController.text,
                      dateTime: _selectedDate,
                      uid: FirebaseAuth.instance.currentUser!.uid,
                    );
                    await dbService.addAppointment(appointment);
                    Navigator.pop(context);
                   
                    ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Appointment Book Successfully!')),
                    );
                  },
                  
                  style:const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue)),

                  child:const Text('Book Appointment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),

      backgroundColor: Colors.white,
    );
  }
}