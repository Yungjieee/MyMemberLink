
import 'package:aasignment_1/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:aasignment_1/views/newsletter/main_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
 final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
                // You can add color or other styling here if needed
                ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            onTap: () {
              // Define onTap actions here if needed
               Navigator.push(context,
                MaterialPageRoute(builder: (content) => const MainScreen()));
            },
            title: const Text("Newsletter"),
          ),
          ListTile(
            title: const Text("Events"),
            onTap: () {
              // Navigator.push(context,
              //   MaterialPageRoute(builder: (content) => const EventScreen()));
            },
          ),
          const ListTile(
            title: Text("Members"),
          ),
          const ListTile(
            title: Text("Payments"),
          ),
          const ListTile(
            title: Text("Products"),
          ),
          const ListTile(
            title: Text("Vetting"),
          ),
          const ListTile(
            title: Text("Settings"),
          ),
          ListTile(
            title: const Text("Logout"),
            onTap: () {
              signOutwithGoogle(context);
            },
          ),
        ],
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