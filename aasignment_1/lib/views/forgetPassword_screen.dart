import 'package:aasignment_1/views/verifyotp_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';

class ForgetpasswordScreen extends StatefulWidget {
  const ForgetpasswordScreen({super.key});

  @override
  State<ForgetpasswordScreen> createState() => _ForgetpasswordScreenState();
}

class _ForgetpasswordScreenState extends State<ForgetpasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Row(
          mainAxisSize:
              MainAxisSize.min, // Centers the row contents in the AppBar
          children: [
            Image.asset(
              'assets/images/logo_white.png', // Replace with your logo asset path
              height: 50,
            ),
            const SizedBox(width: 8), // Adds spacing between logo and text
            const Text(
              'Forget Password',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20), // Sets text color to white
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/fuck.png'),
                ),
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const Text(
                        'Enter the email address associated with your account',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: const TextStyle(
                            color: Colors.grey, // Sets label color to grey
                            fontSize: 17, // Sets label font size to 17
                          ),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.orange,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (content) => const ForgetpasswordScreen(),
                          //   ),
                          // );
                        },
                        child: const Text(
                          "Try another way",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.red,
                            decorationThickness: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      MaterialButton(
                        elevation: 10,
                        onPressed: () {
                          sendOTP();
                          //                     Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (content) => const VerifyOTP(),
                          //   ),
                          // );
                        },
                        minWidth: 400,
                        height: 50,
                        color: const Color.fromARGB(255, 236, 16, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Send OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendOTP() async {
    if (await EmailOTP.sendOTP(email: emailController.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("OTP has been sent"),));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (content) => VerifyOTP(email: emailController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("OTP failed sent")));
    }
  }
}