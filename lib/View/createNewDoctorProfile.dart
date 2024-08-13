import 'package:flutter/material.dart';
import 'package:healify_me/Services/doctorService.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage

class DoctorProfileForm extends StatefulWidget {
  @override
  _DoctorProfileFormState createState() => _DoctorProfileFormState();
}

class _DoctorProfileFormState extends State<DoctorProfileForm> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  String _name = '';
  String _specialization = '';
  String _bio = '';
  String _contact = '';
  TimeOfDay? available_time;

  final DoctorService _doctorService = DoctorService();

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Method to upload image to Firebase Storage and get URL
  Future<String?> _uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('doctor_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Method to pick available time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: available_time ?? TimeOfDay.now(),
    );
    if (picked != null && picked != available_time) {
      setState(() {
        available_time = picked;
      });
    }
  }

  void _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Upload image and get URL
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      }

      // Ensure the image upload was successful
      if (imageUrl != null) {
        await _doctorService.createOrUpdateDoctorProfile(
          imageUrl,
          _name,
          _specialization,
          _bio,
          _contact,
          available_time!.format(context),
        );

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile saved successfully!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to upload image.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Profile',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.blue,
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              _imageFile!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50)),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
        
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  onSaved: (value) => _name = value!,
                  validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 15),
        
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Specialization',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  onSaved: (value) => _specialization = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter your specialization' : null,
                ),
                const SizedBox(height: 15),
        
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  onSaved: (value) => _bio = value!,
                  validator: (value) => value!.isEmpty ? 'Enter your bio' : null,
                ),
                const SizedBox(height: 15),
        
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Contact',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _contact = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter your contact' : null,
                ),
                const SizedBox(height: 15),
        
                ListTile(
                  title: Text(available_time != null
                      ? 'Available time: ${available_time!.format(context)}'
                      : 'Select Available Time',
                      style:const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,

                      ),
                      ),
                  trailing:const Icon(Icons.access_time),
                  onTap: () => _selectTime(context),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _submitProfile,
                  style: const ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(200, 50)),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  ),
                  child: const Text(
                    'Save Profile',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
