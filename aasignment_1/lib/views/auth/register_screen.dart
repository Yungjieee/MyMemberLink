import 'dart:convert';
import 'package:aasignment_1/myconfig.dart';
import 'package:aasignment_1/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmPasswordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController phoneNumcontroller = TextEditingController();
  bool isVisible1 = false;
  bool isVisible2 = false;

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
                  color: Colors.white,
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
                          height: 15,
                        ),
                        Text(
                          "Create Account",
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
                          "Let's Started Now!",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 43, 43, 43),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: namecontroller,
                          style: const TextStyle(fontSize: 13),
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            hintText: "Full Name",
                            hintStyle: TextStyle(
                              color: Colors.grey, // Hint text color
                              fontSize: 13, // Hint text size
                            ),
                            prefixIcon: Icon(
                              Icons.person_2_outlined,
                              color: Colors.orange,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                          height: 10,
                        ),
                        TextField(
                          controller: phoneNumcontroller,
                          style: const TextStyle(fontSize: 13),
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                              color: Colors.grey, // Hint text color
                              fontSize: 13, // Hint text size
                            ),
                            prefixIcon: Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Keeps the row's width minimal
                              children: [
                                const SizedBox(width: 13.0),
                                Icon(
                                  Icons.phone_android_outlined,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                    width:
                                        8.0), // Adds space between the icon and +60
                                Text(
                                  '+60',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(width: 8.0),
                              ],
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          obscureText: !isVisible1,
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
                              Icons.lock_outlined,
                              color: Colors.orange,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isVisible1
                                    ? Icons.visibility
                                    : Icons.visibility_off, // Toggle icon
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                setState(() {
                                  isVisible1 =
                                      !isVisible1; // Toggle the visibility state
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
                        TextField(
                          obscureText: !isVisible2,
                          controller: confirmPasswordcontroller,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            hintText: "Confirmation Password",
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
                                isVisible2
                                    ? Icons.visibility
                                    : Icons.visibility_off, // Toggle icon
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                setState(() {
                                  isVisible2 =
                                      !isVisible2; // Toggle the visibility state
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
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        Container(
                          width:
                              400, // Set this to the same width as your TextField
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: const Text(
                            'Password must not be less than 8 characters, including at least a number, an uppercase letter, a lowercase letter and a special symbol',
                            style: TextStyle(fontSize: 10, height: 1.3),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                            elevation: 10,
                            onPressed: () {
                              if (validateFields()) {
                                checkEmailExists();
                              }
                            },
                            minWidth: 400,
                            height: 50,
                            color: const Color.fromARGB(255, 236, 16, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text("Sign Up",
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
                                "Or register with",
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
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                // SignInWithFacebook();
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
                                //signInwithGoogle;
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
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? click ",
                              style: TextStyle(fontSize: 13),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            const LoginScreen()));
                              },
                              child: const Text(
                                "Login",
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

  void onRegisterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                userRegistration();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void userRegistration() {
    String email = emailcontroller.text;
    String password = passwordcontroller.text;
    String name = namecontroller.text;
    String phoneNum = phoneNumcontroller.text;

    http.post(
        Uri.parse(
            "${Myconfig.servername}/memberlink_asg1/api/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "phoneNum": phoneNum,
          "password": password
        }).then((response) {
      // print(response.statusCode);
      // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          // User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Success"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const LoginScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  bool validateFields() {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    String confirmPassword = confirmPasswordcontroller.text.trim();
    String name = namecontroller.text.trim();
    String phoneNum = phoneNumcontroller.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        name.isEmpty ||
        phoneNum.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill in all the information above"),
      ));
      return false;
    }

    // Email validation
    // Regex for basic email validation
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address")),
      );
      return false;
    }

    // Password validation
    // Password regex pattern for validation
    final RegExp passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
    if (!passwordRegex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Password Format")),
      );
      return false;
    }

    // phone number validation
    final RegExp phoneNumRegex = RegExp(r'^\d{9,10}$');
    if (!phoneNumRegex.hasMatch(phoneNum)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 9-10 digit phone number")),
      );
      return false;
    }


    // Confirm Password validation
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return false;
    }

    return true;
  }

  void checkEmailExists() {
    String email = emailcontroller.text;

    http.post(
        Uri.parse("${Myconfig.servername}/memberlink_asg1/api/check_email.php"),
        body: {"email": email}).then((response) {
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "exist") {
          // User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Email already exists"),
            backgroundColor: Colors.red,
          ));
        } else {
          // Proceed to registration if email does not exist
          onRegisterDialog();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error checking email")),
        );
      }
    });
  }
}
