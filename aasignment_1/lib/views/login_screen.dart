import 'dart:convert';
import 'dart:developer';

import 'package:aasignment_1/myconfig.dart';
import 'package:aasignment_1/views/forgetPassword_screen.dart';
import 'package:aasignment_1/views/main_screen.dart';
import 'package:aasignment_1/views/verifyOTP_screen.dart';
//import 'package:aasignment_1/views/verifyOTP_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aasignment_1/views/register_screen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool rememberme = false;
  bool isVisible = false;
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  FacebookAuth facebookAuth = FacebookAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPref();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      }
    });
    googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 65,
                ),
                Container(
                  height: 40,
                  width: 80,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/logo_white_shadow.png'),
                    ),
                  ),
                ),
                Text(
                  "My Member Link",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: const Offset(2.0, 2.0),
                        blurRadius: 4.0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 30,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    height: 670,
                    // padding: const EdgeInsets.all(35.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35.0, vertical: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 45,
                        ),
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 233, 140, 0),
                            shadows: [
                              Shadow(
                                offset: const Offset(0.2, 0.1),
                                //blurRadius: 2,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "Welcome back to My Member Link!",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 43, 43, 43),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: emailcontroller,
                          style: const TextStyle(fontSize: 13),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: Colors.grey, // Hint text color
                              fontSize: 13, // Hint text size
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.orange,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          obscureText: !isVisible,
                          controller: passwordcontroller,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            hintText: "Password",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.orange,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off, // Toggle icon
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                setState(() {
                                  isVisible =
                                      !isVisible; // Toggle the visibility state
                                });
                              },
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: rememberme,
                              onChanged: (bool? value) {
                                setState(() {
                                  String email = emailcontroller.text;
                                  String pass = passwordcontroller.text;
                                  if (value!) {
                                    if (email.isNotEmpty && pass.isNotEmpty) {
                                      storeSharedPrefs(value, email, pass);
                                    } else {
                                      rememberme = false;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Please enter your credentials"),
                                        backgroundColor: Colors.red,
                                      ));
                                      return;
                                    }
                                  } else {
                                    email = "";
                                    pass = "";
                                    storeSharedPrefs(value, email, pass);
                                  }
                                  rememberme = value ?? false;
                                  setState(() {});
                                });
                              },
                              activeColor: Colors.orange,
                            ),
                            const Text(
                              "Remember me",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Forgot password? click ",
                              style: TextStyle(fontSize: 13),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                             const ForgetpasswordScreen()));
                              },
                              child: const Text(
                                "Here",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 255, 16, 0),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 255, 16, 0),
                                  decorationThickness: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                            elevation: 10,
                            onPressed: () {
                              onLogin();
                            },
                            minWidth: 400,
                            height: 50,
                            color: const Color.fromARGB(255, 236, 16, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text("Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold))),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 35,
                              child: Divider(
                                color: Color.fromARGB(255, 43, 43, 43),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Or sign in with",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            SizedBox(
                              width: 35,
                              child: Divider(
                                color: Color.fromARGB(255, 43, 43, 43),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                signInWithFacebook();
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.transparent,
                                ),
                                child: const Image(
                                  image: AssetImage(
                                      'assets/images/facebook_logo.png'),
                                  height: 45,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                signInwithGoogle();
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color:
                                      const Color.fromARGB(255, 219, 215, 215),
                                ),
                                child: const Image(
                                  image: AssetImage(
                                      'assets/images/google_logo.webp'),
                                  height: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 90,
                        ),
                        //Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? click ",
                              style: TextStyle(fontSize: 13),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            const RegisterScreen()));
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 255, 16, 0),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 255, 16, 0),
                                  decorationThickness: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLogin() {
    String email = emailcontroller.text;
    String password = passwordcontroller.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter email and password"),
      ));
      return;
    }

    // Email format validation
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a valid email address"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Password format validation
    final RegExp passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
    if (!passwordRegex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Password Format")),
      );
      return;
    }

    //Password length validation
    if (password.isEmpty || password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password must be at least 8 characters long"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    http.post(
        Uri.parse("${Myconfig.servername}/memberlink_asg1/api/login_user.php"),
        body: {"email": email, "password": password}).then((response) {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          // User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const MainScreen()));
        } else if (data['status'] == "wrong_password") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Password is incorrect"),
            backgroundColor: Colors.red,
          ));
        } else if (data['status'] == "no_email") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Email does not exist"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Login Failed"),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  Future<void> storeSharedPrefs(bool value, String email, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      prefs.setString("email", email);
      prefs.setString("password", pass);
      prefs.setBool("rememberme", value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Saved"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
    } else {
      prefs.setString("email", email);
      prefs.setString("password", pass);
      prefs.setBool("rememberme", value);
      emailcontroller.text = "";
      passwordcontroller.text = "";
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences is Removed"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailcontroller.text = prefs.getString("email") ?? "";
    passwordcontroller.text = prefs.getString("password") ?? "";
    rememberme = prefs.getBool("rememberme") ?? false;

    setState(() {});
  }

  Future<void> signInwithGoogle() async {
    try {
      await googleSignIn.signIn();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Colors.green,
          ));
    } catch (error) {
      print("Failed to Sign in with Google: $error");
    }
  }

  Future signInWithFacebook() async {
    final result =
        await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData();
      return userData;
    }

    return null;
  }
}
