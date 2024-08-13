import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healify_me/Services/authService.dart';
import 'package:healify_me/Services/databaseService.dart';
import 'package:healify_me/View/splashScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Authservice>(create: (_)=> Authservice()),
        Provider<DatabaseService>(create: (_)=> DatabaseService())
        ], 
      child:  MaterialApp(
      home:CheckUserRole(),
      debugShowCheckedModeBanner: false,
    )
      );
  }
}
