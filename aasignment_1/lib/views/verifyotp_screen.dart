import 'package:aasignment_1/views/changePassword.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  //late final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController otpController = TextEditingController();
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
                  image: AssetImage('assets/images/verify_email.png'),
                ),
                const Text(
                  'Verify Your Email',
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
                        'Please enter the 4-digit code sent to your email',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      // TextField(
                      //   controller: emailController,
                      //   decoration: InputDecoration(
                      //     labelText: 'Email Address',
                      //     labelStyle: const TextStyle(
                      //       color: Colors.grey, // Sets label color to grey
                      //       fontSize: 17, // Sets label font size to 17
                      //     ),
                      //     prefixIcon: const Icon(
                      //       Icons.email,
                      //       color: Colors.orange,
                      //     ),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(30.0),
                      //     ),
                      //   ),
                      // ),
                      Pinput(
                        controller: pinController,
                        // onSubmitted: (pin) => EmailOTP.verifyOTP(otp: pin),
                        // onCompleted: (pin) => print(pin),
                        length: 4,
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
                          "Resend Code",
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
                          if (EmailOTP.verifyOTP(otp: pinController.text)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Verify OTP Success"),backgroundColor: Colors.green,));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePassword()));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Verify OTP Unsuccess"),backgroundColor: Colors.red,));

                          }
                          
                        },
                        //   Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (content) => const VerifyOTP(),
                        //   ),
                        // );
                        minWidth: 400,
                        height: 50,
                        color: const Color.fromARGB(255, 236, 16, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Verify OTP",
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

      // appBar: AppBar(title: const Text('Email OTP')),
      // body: ListView(
      //   children: [
      //     TextFormField(controller: emailController),
      //     ElevatedButton(
      //       onPressed: () async {
      //         if (await EmailOTP.sendOTP(email: emailController.text)) {
      //           ScaffoldMessenger.of(context).showSnackBar(
      //               const SnackBar(content: Text("OTP has been sent")));
      //         } else {
      //           ScaffoldMessenger.of(context).showSnackBar(
      //               const SnackBar(content: Text("OTP failed sent")));
      //         }
      //       },
      //       child: const Text('Send OTP'),
      //     ),
      //     TextFormField(controller: otpController),
      //     ElevatedButton(
      //       onPressed: () => EmailOTP.verifyOTP(otp: otpController.text),
      //       child: const Text('Verify OTP'),
      //     ),
      //   ],
      // ),
    );
  }

  
  
}
