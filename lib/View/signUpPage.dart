import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healify_me/Services/authService.dart';
import 'package:healify_me/Services/databaseService.dart';
import 'package:healify_me/View/loginPage.dart';
import 'package:provider/provider.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final GlobalKey<FormState> _myKey = GlobalKey<FormState>();
  String _role = 'patient';
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<Authservice>(context);
    final dbService = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white
        ),),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon:const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        )
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const Image(image: NetworkImage("https://img.freepik.com/free-vector/mobile-login-concept-illustration_114360-83.jpg?size=338&ext=jpg&ga=GA1.1.2008272138.1722729600&semt=sph"),
             height: 280,),
        
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
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                  ),
                ),

                validator: (value){
                  if(value == null || value.isEmpty){
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
                decoration:  InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: (){
                      setState(() {
                        isPasswordVisible =! isPasswordVisible;
                      });
                    }, icon: isPasswordVisible? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                    
                    ),
                  hintText: "Enter Your Password",
                  border:const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                  ),
                ),

                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Please enter password";
                  }
                  return null;
                },
              ),
            )
              ],
            )),

            DropdownButton<String>(
              value: _role,
              items: ['patient', 'doctor'].map((String role){
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                  );
              }).toList(),
              onChanged :(value){
                setState(() {
                  _role = value!;
                });
              },
              ),

             const SizedBox(height: 20,),

            Container(
              height: 50,
              width: 320,
              decoration:const BoxDecoration(color: Colors.blue),
              child: ElevatedButton(
               onPressed: () async{
                if (_myKey.currentState!.validate()) {
                    // If the form is valid, display a Snackbar.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign Up Successful!'),
                      backgroundColor: Colors.black,
                      ),
                    );
                }

                 try{
                  User? user = await authService.createUserWithEmailAndPassword(
                      emailController.text,
                      passWordController.text,
                    );
                    if (user != null) {
                        await dbService.saveUserRole(user.uid, _role);
                    } else {   
                       print("User creation failed, user is null.");
                    }

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Loginpage()));
                 }catch(e){
                  print(e.toString());
                  return;
                 }
               },
                style:const ButtonStyle(backgroundColor:WidgetStatePropertyAll(Colors.blue)),
                child: const Text("Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.white
                ),
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