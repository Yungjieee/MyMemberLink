import 'package:flutter/material.dart';
import 'package:aasignment_1/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Container(
                    height: 100,
                    width: 150,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/logo_white.png'),
                      ),
                    ),
            ),
            // Image.asset(
            //   'assets/images/logo_white.png', 
            //   width: 200, 
            //   height: 150, 
            // ),
            const Text(
              "My Member Link",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 30),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) {
                return Container(
                  width: 200,
                  height: 5,
                  child: LinearProgressIndicator(
                    value: value,
                    color: Colors.white,
                    backgroundColor: Colors.grey.withOpacity(0.5),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
 }