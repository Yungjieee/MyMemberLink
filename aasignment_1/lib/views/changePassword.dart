import 'dart:convert';
import 'package:aasignment_1/views/forgetPassword_screen.dart';
import 'package:aasignment_1/views/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:aasignment_1/myconfig.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  final String email;
  const ChangePassword({super.key, required this.email});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isPasswordVisible1 = false;
  bool _isPasswordVisible2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo_white.png', // Replace with your logo asset path
              height: 50,
            ),
            const SizedBox(width: 8),
            const Text(
              'Change Password',
              style: TextStyle(color: Colors.white, fontSize: 20),
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
                  'Change New Password',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Password must not be less than 8 characters, including at least a number, an uppercase letter, a lowercase letter, and a special symbol',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: newPasswordController,
                  obscureText: !_isPasswordVisible1,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible1
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible1 = !_isPasswordVisible1;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: !_isPasswordVisible2,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible2
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible2 = !_isPasswordVisible2;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                MaterialButton(
                  elevation: 10,
                  onPressed:(){ checkNewPassword();
                  },
                  minWidth: 400,
                  height: 50,
                  color: const Color.fromARGB(255, 236, 16, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Update New Password",
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
        ),
      ),
    );
  }

   checkNewPassword() {
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Password validation regex
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    if (!passwordRegex.hasMatch(newPassword)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid Password"),
          content: const Text("Password must be at least 8 characters long, contain a number, an uppercase letter, a lowercase letter, and a special symbol."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Passwords Do Not Match"),
          content: const Text("The new password and confirmation password do not match."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }
    onUpdatePasswordDialog();

    //UpdatePassword();
   
    
  }

  void onUpdatePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Update New Password?",
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
                UpdatePassword();
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

  void UpdatePassword() {
  String newPassword = newPasswordController.text;

  http.post(
    Uri.parse("${Myconfig.servername}/memberlink_asg1/api/update_password.php"),
    body: {
      "email": widget.email, 
      "password": newPassword,
    },
  ).then((response) {
    print(response.statusCode);
      print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password Updated Successfully"),
          backgroundColor: Colors.green,
        ));
        Navigator.push(context,
              MaterialPageRoute(builder: (content) => const LoginScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Update Password Failed"),
          backgroundColor: Colors.red,
        ));
      }
    }
  });
}

}
