import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healify_me/Services/authService.dart';
import 'package:healify_me/Services/databaseService.dart';
import 'package:healify_me/View/patientHomeScreen.dart';
import 'package:healify_me/View/showAppointments.dart';
import 'package:healify_me/View/signUpPage.dart';
import 'package:provider/provider.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}
class _LoginpageState extends State<Loginpage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  bool isPasswordVisible = true;
  String _role = 'patient';
  bool _isLoading = false; // Add this flag

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<Authservice>(context);
    final dbService = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Login Page",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Image(
              image: NetworkImage("https://img.freepik.com/free-vector/mobile-login-concept-illustration_114360-83.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1722729600&semt=sph"),
              height: 280,
            ),
            Form(
              key: _myKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "Enter Your Email",
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter email";
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                    child: TextFormField(
                      controller: passWordController,
                      obscureText: isPasswordVisible,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: isPasswordVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                        ),
                        hintText: "Enter Your Password",
                        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter password";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            DropdownButton<String>(
              value: _role,
              items: ['patient', 'doctor'].map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _role = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator() // Show loader if loading
                : Container(
                    height: 50,
                    width: 320,
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_myKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true; // Start loading
                          });

                          User? user = await authService.signInWithEmailAndPassword(
                            emailController.text,
                            passWordController.text,
                          );

                          if (user != null) {
                            String? role = await dbService.getUserRole(user.uid);

                            if (role != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login Successful!')),
                              );

                              if (role == 'patient') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const patientHomeScreen()),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => DoctorAppointmentsScreen()),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('New user? Please sign up first.')),
                              );
                              await FirebaseAuth.instance.signOut();
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid credentials. Please try again.')),
                            );
                          }

                          setState(() {
                            _isLoading = false; // Stop loading
                          });
                        }
                      },
                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              width: 320,
              decoration: const BoxDecoration(color: Colors.blue),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Signuppage()));
                },
                style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
