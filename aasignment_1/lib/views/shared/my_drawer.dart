import 'dart:convert';
import 'dart:developer';
import 'package:aasignment_1/views/events/event_screen.dart';
import 'package:aasignment_1/views/product/product_screen.dart';
import 'package:http/http.dart' as http;
import 'package:aasignment_1/myconfig.dart';
import 'package:aasignment_1/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:aasignment_1/views/newsletter/news_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyDrawer extends StatefulWidget {
  final String email;
  const MyDrawer({super.key, required this.email});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String? userName;
  String? userId;

  @override
  void initState() {
  super.initState();
  // Fetch the user's details when the screen is initialized
  fetchUserDetails(widget.email).then((details) {
    if (details != null) {
      setState(() {
        userName = details['user_name']; // Update the userName state
        userId = details['user_id'];     // Update the userId state
      });
    } else {
      setState(() {
        userName = "Unknown User"; // Fallback if details are null
        userId = "0";             // Fallback for userId
      });
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drawer Header with Background Image and User Details
          Stack(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/orange_bg.avif'), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(
                      0.2), // Add a dark overlay for better contrast
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName ?? "User Name", // Placeholder for user name
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.email, // Display user email
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Welcome Text Below Header
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Welcome to MyMemberLink!",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // List Items
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.newspaper, color: Colors.orange),
                  title: const Text("Newsletter"),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            MainScreen(email: widget.email),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin =
                              Offset(1.0, 0.0); // Slide in from the right
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (content) => MainScreen(email: widget.email),
                    //   ),
                    // );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.event, color: Colors.orange),
                  title: const Text("Events"),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            EventScreen(email: widget.email),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin =
                              Offset(1.0, 0.0); // Slide in from the right
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );


                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (content) =>
                    //             EventScreen(email: widget.email)));
                  },
                ),
                const ListTile(
                  leading: Icon(Icons.group, color: Colors.orange),
                  title: Text("Members"),
                ),
                const ListTile(
                  leading: Icon(Icons.payment, color: Colors.orange),
                  title: Text("Payments"),
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart, color: Colors.orange),
                  title: const Text("Products"),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ProductScreen(email: widget.email, userId: userId ?? "0"),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin =
                              Offset(1.0, 0.0); // Slide in from the right
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
                const ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.orange),
                  title: Text("Vetting"),
                ),
                const ListTile(
                  leading: Icon(Icons.settings, color: Colors.orange),
                  title: Text("Settings"),
                ),
              ],
            ),
          ),

          // Logout Button as Footer
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: ListTile(
              // leading: Icon(Icons.logout, color: Colors.white),
              tileColor: Colors.red,
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                signOutwithGoogle(context);
              },
            ),
          ),
        ],
      ),
    );
  }

 Future<Map<String, dynamic>?> fetchUserDetails(String email) async {
  try {
    // Define the URL of the PHP file
    String url = "${Myconfig.servername}/memberlink_asg1/api/get_user_details.php";

    // Send a POST request with the user email
    final response = await http.post(
      Uri.parse(url),
      body: {
        "userEmail": email, // Send the email to the backend
      },
    );
log(response.body);
    if (response.statusCode == 200) {
      // Parse the response
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        // Return the user ID and user name as a map
        return {
          'user_id': data['user_id'],
          'user_name': data['user_name'],
        };
      } else {
        log("Error: ${data['message']}");
        return null; // Return null if the user is not found
      }
    } else {
      log("Error: Failed to connect to the server");
      return null;
    }
  } catch (error) {
    log("Error: $error");
    return null;
  }
}

  Future signOutwithGoogle(BuildContext context) async {
    await googleSignIn.signOut();
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}
