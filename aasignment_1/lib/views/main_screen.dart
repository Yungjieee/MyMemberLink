import 'package:aasignment_1/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Main Screen"),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            signOutwithGoogle(context);
          },
        ),
      ],
    ),
    body: const Center(
      child: Text("MAIN SCREEN"),
    ),
  );
}

  

  Future signOutwithGoogle(BuildContext context) async{
    
    await googleSignIn.signOut();
    Navigator.pop(context);
     Navigator.push(context,
              MaterialPageRoute(builder: (content) => const LoginScreen()));

  }
}